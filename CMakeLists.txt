cmake_minimum_required(VERSION 3.12)
project(swiftshader-ext)

include(ExternalProject)

set(SCIN_EXT_INSTALL_DIR "${PROJECT_BINARY_DIR}/install-ext" CACHE PATH "Scintallor External Dependencies")
file(MAKE_DIRECTORY "${SCIN_EXT_INSTALL_DIR}")
file(MAKE_DIRECTORY "${SCIN_EXT_INSTALL_DIR}/share/vulkan/icd.d")
set(SWIFTSHADER_GIT_TAG 8def9063c4fdefa8e644198d2254ef279952c88b)

#### Swiftshader software renderer
if (APPLE)
    ExternalProject_Add(swiftshader
        PREFIX ext
        STEP_TARGETS install
        GIT_REPOSITORY https://github.com/google/swiftshader
        GIT_TAG ${SWIFTSHADER_GIT_TAG}
        GIT_PROGRESS ON
        UPDATE_COMMAND ""
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=Release -DSWIFTSHADER_BUILD_SAMPLES=OFF -DSWIFTSHADER_BUILD_TESTS=OFF -DSWIFTSHADER_WARNINGS_AS_ERRORS=OFF -DSWIFTSHADER_BUILD_VULKAN=ON -DSWIFTSHADER_BUILD_EGL=OFF -DSWIFTSHADER_BUILD_GLESv2=OFF -DSWIFTSHADER_BUILD_GLES_CM=OFF -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        INSTALL_COMMAND cp "<BINARY_DIR>/Debug/libvk_swiftshader.dylib" "<BINARY_DIR>/Darwin/vk_swiftshader_icd.json" "${SCIN_EXT_INSTALL_DIR}/share/vulkan/icd.d/."
    )
elseif(UNIX)
    # TODO(43): figure out why non-Debug builds crash on Pipeline creation.
    # See https://github.com/google/amber/issues/754 for discussion of shared linker flag on Linux
    ExternalProject_Add(swiftshader
        PREFIX ext
        STEP_TARGETS install
        GIT_REPOSITORY https://github.com/google/swiftshader
        GIT_TAG ${SWIFTSHADER_GIT_TAG}
        GIT_PROGRESS ON
        UPDATE_COMMAND ""
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=Debug -DSWIFTSHADER_BUILD_SAMPLES=OFF -DSWIFTSHADER_BUILD_TESTS=OFF -DSWIFTSHADER_WARNINGS_AS_ERRORS=OFF -DSWIFTSHADER_BUILD_VULKAN=ON -DSWIFTSHADER_BUILD_EGL=OFF -DSWIFTSHADER_BUILD_GLESv2=OFF -DSWIFTSHADER_BUILD_GLES_CM=OFF -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_SHARED_LINKER_FLAGS=\"-fuse-ld=gold\"
        INSTALL_COMMAND cp "<BINARY_DIR>/Linux/libvk_swiftshader.so" "<BINARY_DIR>/Linux/vk_swiftshader_icd.json" "${SCIN_EXT_INSTALL_DIR}/share/vulkan/icd.d"
    )
elseif(WIN32)
    ExternalProject_Add(swiftshader
        PREFIX ext
        STEP_TARGETS install
        GIT_REPOSITORY https://github.com/google/swiftshader
        GIT_TAG ${SWIFTSHADER_GIT_TAG}
        GIT_PROGRESS ON
        UPDATE_COMMAND ""
        CMAKE_ARGS cmake -DCMAKE_BUILD_TYPE=Release -DSWIFTSHADER_BUILD_PVR=OFF -DSWIFTSHADER_BUILD_TESTS=OFF -DSWIFTSHADER_WARNINGS_AS_ERRORS=OFF -DSWIFTSHADER_BUILD_VULKAN=ON -Thost=x64 ..
        INSTALL_COMMAND cp "<BINARY_DIR>/Release/vk_swiftshader.dll" "${SCIN_EXT_INSTALL_DIR}/share/vulkan/icd.d"
    )
else()
    message(FATAL_ERROR "unsupported build platform")
endif()


