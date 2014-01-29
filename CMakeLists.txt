project(cgExercise)
cmake_minimum_required(VERSION 2.4)

if(COMMAND cmake_policy)
   cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)

#set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)
find_package(GLEW REQUIRED)
include_directories( ${OPENGL_INCLUDE_DIRS}  ${GLUT_INCLUDE_DIR} ${GLEW_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR})

add_executable(cgExercise01 main01.cpp shader01.frag shader01.vert shader01.geom)
target_link_libraries(cgExercise01 ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLEW_LIBRARIES} ${GLUT_glut_LIBRARY})

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/main02.cpp)
add_executable(cgExercise02 main02.cpp shader02.frag shader02.vert shader02.geom)
target_link_libraries(cgExercise02 ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLEW_LIBRARIES} ${GLUT_glut_LIBRARY})
endif()

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/main03.cpp)
add_executable(cgExercise03 main03.cpp shader03.frag shader03.vert shader03.geom)
target_link_libraries(cgExercise03 ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLEW_LIBRARIES} ${GLUT_glut_LIBRARY})
endif()

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/main04.cpp)
add_executable(cgExercise04 main04.cpp shader04.frag shader04.vert shader04.geom)
target_link_libraries(cgExercise04 ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLEW_LIBRARIES} ${GLUT_glut_LIBRARY})
endif()

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/main05.cpp)
add_executable(cgExercise05 main05.cpp shader05.frag shader05.vert)
target_link_libraries(cgExercise05 ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLEW_LIBRARIES} ${GLUT_glut_LIBRARY})
endif()

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/main06.cpp)
add_executable(cgExercise06 main06.cpp shader06.frag shader06.vert)
target_link_libraries(cgExercise06 ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLEW_LIBRARIES} ${GLUT_glut_LIBRARY})
endif()