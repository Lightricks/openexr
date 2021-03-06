
PROJECT (pyilmbase)

IF (OPENEXR_BUILD_SHARED)
  # User wants to build Dynamic Libraries, so change the LIB_TYPE variable to CMake keyword 'SHARED'
  SET (LIB_TYPE SHARED)
  IF (WIN32)
    ADD_DEFINITIONS(-DOPENEXR_DLL)
  ENDIF ()
ELSE (OPENEXR_BUILD_SHARED)
  SET (LIB_TYPE STATIC)
ENDIF (OPENEXR_BUILD_SHARED)

LINK_DIRECTORIES ( ${ILMBASE_PACKAGE_PREFIX}/lib )
MESSAGE ( "ILMBASE_PACKAGE_PREFIX = " ${ILMBASE_PACKAGE_PREFIX})

MACRO(SET_ILMBASE_INCLUDE_DIRS _target)
  TARGET_INCLUDE_DIRECTORIES(${_target}
    PRIVATE ${PYTHON_INCLUDE_PATH}
    PRIVATE ${Boost_INCLUDE_DIRS}
    PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/../config
    PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/../../IlmBase/config
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../PyIex
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../PyImath
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../PyImathNumpy
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../IlmBase/Half
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../IlmBase/Iex
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../IlmBase/IexMath
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../IlmBase/IlmThread
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../IlmBase/Imath
  )
ENDMACRO()

##########################
ADD_SUBDIRECTORY ( PyIex )
ADD_SUBDIRECTORY ( PyImath )

IF (NUMPY_FOUND)
  ADD_SUBDIRECTORY ( PyImathNumpy )
  ADD_SUBDIRECTORY ( PyImathNumpyTest )
ENDIF ()

##########################
# Tests
##########################
IF (ENABLE_TESTS)
  ADD_SUBDIRECTORY ( PyIexTest )
  ADD_SUBDIRECTORY ( PyImathTest )
ENDIF ()

