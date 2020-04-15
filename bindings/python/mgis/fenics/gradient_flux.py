#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Gradient and Flux classes

@author: Jeremy Bleyer, Ecole des Ponts ParisTech,
Laboratoire Navier (ENPC,IFSTTAR,CNRS UMR 8205)
@email: jeremy.bleyer@enpc.f
"""
from dolfin import *
import numpy as np
import ufl
from .utils import local_project, symmetric_tensor_to_vector, \
                nonsymmetric_tensor_to_vector, get_quadrature_element

class Gradient:
    """
    This class provides a representation of MFront gradient objects. Its main
    purpose is to provide the corresponding UFL expression, linking MFront and
    FEniCS concepts. It also handles:
        - the reshaping from UFL tensorial representation to MFront vectorial conventions
        - the symbolic expression of the gradient variation (directional derivative)
        - the representation as a Quadrature function

    This class is intended for internal use only. Gradient objects must be declared
    by the user using the registration concept.
    """
    def __init__(self, variable, expression, name, symmetric=None):
        self.variable = variable
        if symmetric is None:
            self.expression = expression
        elif symmetric:
            if self.variable.geometric_dimension()==2:
                self.expression = as_vector([symmetric_tensor_to_vector(expression)[i] for i in range(4)])
            else:
                self.expression = symmetric_tensor_to_vector(expression)
        else:
            if self.variable.geometric_dimension()==2:
                self.expression = as_vector([nonsymmetric_tensor_to_vector(expression)[i] for i in range(5)])
            else:
                self.expression = nonsymmetric_tensor_to_vector(expression)
        shape = ufl.shape(self.expression)
        if len(shape)==1:
            self.shape = shape[0]
        elif shape==():
            self.shape = 0
        else:
            self.shape = shape
        self.name = name

    def __call__(self, v):
        return ufl.replace(self.expression, {self.variable:v})
    def variation(self, v):
        """ Directional derivative in direction v """
        return ufl.algorithms.expand_derivatives(ufl.derivative(self.expression, self.variable, v))

    def initialize_function(self, mesh, quadrature_degree):
        self.quadrature_degree = quadrature_degree
        self.dx = Measure("dx", metadata={"quadrature_degree": quadrature_degree})
        We = get_quadrature_element(mesh.ufl_cell(), self.quadrature_degree, self.shape)
        self.function_space = FunctionSpace(mesh, We)
        self.function = Function(self.function_space, name=self.name)

    def update(self, x=None):
        if x is None:
            self._evaluate_at_quadrature_points(self.expression)
        else:
            if isinstance(x, np.ndarray):
                self.function.vector().set_local(x)
            else:
                self._evaluate_at_quadrature_points(x)

    def _evaluate_at_quadrature_points(self, x):
        local_project(x, self.function_space, self.dx, self.function)


class Var(Gradient):
    """ A simple variable """
    def __init__(self, variable, name):
        return Gradient.__init__(self, variable, variable, name)


class Flux:
    def __init__(self, name, shape, gradients=[]):
        self.shape = shape
        self.name = name
        self.gradients = gradients

    def initialize_functions(self, mesh, quadrature_degree):
        We = get_quadrature_element(mesh.ufl_cell(), quadrature_degree, self.shape)
        W = FunctionSpace(mesh, We)
        self.function = Function(W, name=self.name)
        values = [Function(FunctionSpace(mesh,
                          get_quadrature_element(mesh.ufl_cell(),
                          quadrature_degree, dim=(self.shape, g.shape))),
                           name="d{}_d{}".format(self.name, g.name))
                          for g in self.gradients]
        keys = [g.name for g in self.gradients]
        self.tangent_blocks = dict(zip(keys, values))

    def update(self, x):
        self.function.vector().set_local(x)

    def previous(self):
        try:
            self.previous = Function(self.function.function_space(), name=self.name+"_previous")
            self.previous.assign(self.function)
            return self.previous
        except:
            raise ValueError("Function must be initialized first.")
