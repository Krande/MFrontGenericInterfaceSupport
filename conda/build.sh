#!/bin/bash

mkdir build
cd build

export TFELHOME="${PREFIX}"
python_version="${CONDA_PY:0:1}.${CONDA_PY:1:2}"
echo $python_version

ls $PREFIX/include/boost/python/module.hpp
cmake --version

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -Denable-c-bindings=ON \
    -Denable-fortran-bindings=OFF \
    -Denable-python-bindings=ON \
    -Denable-portable-build=ON \
    -Denable-julia-bindings=OFF \
    -DPYTHONLIBS_VERSION_STRING="${CONDA_PY}" \
    -DPython_ADDITIONAL_VERSIONS="${python_version}" \
    -DPYTHON_EXECUTABLE:FILEPATH="${PREFIX}/bin/python" \
    -DPYTHON_LIBRARY:FILEPATH="${PREFIX}/lib/libpython${python_version}.so" \
    -DPYTHON_LIBRARY_PATH:PATH="${PREFIX}/lib" \
    -DPYTHON_INCLUDE_DIRS:PATH="${PREFIX}/include" \
    -DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
    -DUSE_EXTERNAL_COMPILER_FLAGS=ON

ls $PREFIX/include/boost/python/module.hpp

make VERBOSE=1
make check
make install