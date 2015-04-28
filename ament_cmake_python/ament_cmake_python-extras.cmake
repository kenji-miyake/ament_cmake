# Copyright 2014-2015 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# copied from ament_cmake_python/ament_cmake_python-extras.cmake

# register environment hook for PYTHONPATH once
macro(_ament_cmake_python_register_environment_hook)
  if(NOT DEFINED _AMENT_CMAKE_PYTHON_ENVIRONMENT_HOOK_REGISTERED)
    set(_AMENT_CMAKE_PYTHON_ENVIRONMENT_HOOK_REGISTERED TRUE)

    _ament_cmake_python_get_python_install_dir()

    find_package(ament_cmake_core QUIET REQUIRED)
    ament_environment_hooks(
      "${ament_cmake_package_templates_ENVIRONMENT_HOOK_PYTHONPATH}")
  endif()
endmacro()

macro(_ament_cmake_python_get_python_install_dir)
  if(NOT DEFINED PYTHON_INSTALL_DIR)
    set(_python_code
      "from distutils.sysconfig import get_python_lib"
      "from os.path import relpath"
      "print(relpath(get_python_lib(prefix='${CMAKE_INSTALL_PREFIX}'), start='${CMAKE_INSTALL_PREFIX}').replace('\\\\', '/'))"
    )
    execute_process(
      COMMAND
      "${PYTHON_EXECUTABLE}"
      "-c"
      "${_python_code}"
      OUTPUT_VARIABLE _output
      RESULT_VARIABLE _result
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if(NOT _result EQUAL 0)
      message(FATAL_ERROR
        "execute_process(${PYTHON_EXECUTABLE} -c '${_python_code}') returned "
        "error code ${_result}")
    endif()

    set(PYTHON_INSTALL_DIR
      "${_output}"
      CACHE INTERNAL
      "The directory for Python library installation. This needs to be in PYTHONPATH when 'setup.py install' is called.")
  endif()
endmacro()

include("${ament_cmake_python_DIR}/ament_python_install_module.cmake")
include("${ament_cmake_python_DIR}/ament_python_install_package.cmake")