# toolchain.cmake

# Set MY_PY_VER from the environment, or default to "39" if not provided
set(MY_PY_VER $ENV{MY_PY_VER} CACHE STRING "Python Version" FORCE)

# Set PREFIX from the environment, or default to the provided path if not set
set(PREFIX $ENV{PREFIX} CACHE STRING "Prefix" FORCE)

# Set CMAKE_PREFIX_PATH from the environment or default to constructed value
list(APPEND CMAKE_PREFIX_PATH_LIST
        "${PREFIX}"
        "${PREFIX}/include"
        "${PREFIX}/lib"
        "${PREFIX}/bin")
if(DEFINED ENV{CMAKE_PREFIX_PATH})
    list(APPEND CMAKE_PREFIX_PATH_LIST $ENV{CMAKE_PREFIX_PATH})
endif()
set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH_LIST} CACHE STRING "CMake Prefix Path" FORCE)

# Set TFELHOME
set(TFELHOME $ENV{TFELHOME} CACHE STRING "TFEL Home" FORCE)

set (Python_EXECUTABLE $ENV{PYTHON_EXECUTABLE} CACHE STRING "Python Executable" FORCE)

# Set PYTHON_EXECUTABLE
set(PYTHON_EXECUTABLE $ENV{PYTHON_EXECUTABLE} CACHE STRING "Python Executable" FORCE)

# Set PYTHON_LIBRARIES
set(PYTHON_LIBRARIES $ENV{PYTHON_LIBRARIES} CACHE STRING "Python Libraries" FORCE)

# Set PYTHON_INCLUDE_DIRS
set(PYTHON_INCLUDE_DIRS $ENV{PYTHON_INCLUDE_DIRS} CACHE STRING "Python Include Dirs" FORCE)

# Set PYTHON_LIBRARY_PATH
set(PYTHON_LIBRARY_PATH $ENV{PYTHON_LIBRARY_PATH} CACHE STRING "Python Library Path" FORCE)

# Set PYTHON_LIBRARY_FULL
set(PYTHON_LIBRARY_FULL $ENV{PYTHON_LIBRARY_FULL} CACHE STRING "Full Python Library Name" FORCE)

set(Boost_INCLUDE_DIRS $ENV{PYTHON_INCLUDE_DIRS} CACHE STRING "Python Include Dirs" FORCE)

# Direct settings that you've been passing in
set(enable-website OFF CACHE BOOL "Enable Website" FORCE)
set(enable-doxygen-doc OFF CACHE BOOL "Enable Doxygen Documentation" FORCE)
set(enable-c-bindings OFF CACHE BOOL "Enable C Bindings" FORCE)
set(enable-fortran-bindings OFF CACHE BOOL "Enable Fortran Bindings" FORCE)
set(enable-python-bindings ON CACHE BOOL "Enable Python Bindings" FORCE)
set(enable-portable-build ON CACHE BOOL "Enable Portable Build" FORCE)
