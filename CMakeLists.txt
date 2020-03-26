cmake_minimum_required(VERSION 3.13)

include(ExternalProject)

set(SCIN_EXT_INSTALL_DIR "${PROJECT_BINARY_DIR}/install-ext" CACHE PATH "Scintallor External Dependencies")
file(MAKE_DIRECTORY "${SCIN_EXT_INSTALL_DIR}")
file(MAKE_DIRECTORY "${SCIN_EXT_INSTALL_DIR}/share/vulkan/icd.d")

#### Swiftshader software renderer
# See https://github.com/google/amber/issues/754 for discussion of shared linker flag on Linux
if (APPLE)
    set(SWIFTSHADER_SHARED_LINKER "")
    set(SWIFTSHADER_INSTALL_COMMAND cp "<BINARY_DIR>/Debug/libvk_swiftshader.dylib" "<BINARY_DIR>/Darwin/vk_swiftshader_icd.json" "${SCIN_EXT_INSTALL_DIR}/share/vulkan/icd.d/.")
    set(SWIFTSHADER_GIT_TAG master)
    set(SWIFTSHADER_BUILD_CONFIG Release)
elseif(UNIX)
    set(SWIFTSHADER_SHARED_LINKER "-DCMAKE_SHARED_LINKER_FLAGS=\"-fuse-ld=gold\"")
    set(SWIFTSHADER_INSTALL_COMMAND cp "<BINARY_DIR>/Linux/libvk_swiftshader.so" "<BINARY_DIR>/Linux/vk_swiftshader_icd.json" "${SCIN_EXT_INSTALL_DIR}/share/vulkan/icd.d")
    set(SWIFTSHADER_GIT_TAG 8def9063c4fdefa8e644198d2254ef279952c88b)
    # TODO(43): figure out why non-Debug builds crash on Pipeline creation.
    set(SWIFTSHADER_BUILD_CONFIG Debug)
else()
    set(SWIFTSHADER_SHARED_LINKER "")
    set(SWIFTSHADER_INSTALL_COMMAND "")
    set(SWIFTSHADER_GIT_TAG "")
    set(SWIFTSHADER_BUILD_CONFIG "")
endif()

ExternalProject_Add(swiftshader
    PREFIX ext
    STEP_TARGETS install
    GIT_REPOSITORY https://github.com/google/swiftshader
    GIT_TAG ${SWIFTSHADER_GIT_TAG}
    GIT_PROGRESS ON
    UPDATE_COMMAND ""
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${SWIFTSHADER_BUILD_CONFIG} -DSWIFTSHADER_BUILD_SAMPLES=OFF -DSWIFTSHADER_BUILD_TESTS=OFF -DSWIFTSHADER_WARNINGS_AS_ERRORS=OFF -DSWIFTSHADER_BUILD_VULKAN=ON -DSWIFTSHADER_BUILD_EGL=OFF -DSWIFTSHADER_BUILD_GLESv2=OFF -DSWIFTSHADER_BUILD_GLES_CM=OFF -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} ${SWIFTSHADER_SHARED_LINKER}
    INSTALL_COMMAND ${SWIFTSHADER_INSTALL_COMMAND}
)

if(UNIX AND NOT APPLE)
add_custom_target(swiftshader-local
    COMMAND mkdir -p "$ENV{HOME}/.local/share/vulkan"
    COMMAND cp -R "${SCIN_EXT_INSTALL_DIR}/share/vulkan/icd.d" "$ENV{HOME}/.local/share/vulkan/."
    COMMENT "installing swiftshader in $ENV{HOME}/.local/share/vulkan/icd.d"
    DEPENDS swiftshader-install
    VERBATIM
)
endif()

