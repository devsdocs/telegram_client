# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "telegram_client_flutter")
project(${PROJECT_NAME} LANGUAGES CXX)

# begin td
set(dll_path "${CMAKE_CURRENT_SOURCE_DIR}/tdlib")
install(FILES "${dll_path}/libcrypto-1_1-x64.dll" DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)
install(FILES "${dll_path}/libssl-1_1-x64.dll" DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)
install(FILES "${dll_path}/tdjson.dll" DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)
install(FILES "${dll_path}/zlib1.dll" DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)
# end td

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accomodate different builds.
# add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

# # List of absolute paths to libraries that should be bundled with the plugin.
# # This list could contain prebuilt libraries, or libraries created by an
# # external build triggered from this build file.
# set(telegram_client_flutter_bundled_libraries
#   # Defined in ../src/CMakeLists.txt.
#   # This can be changed to accomodate different builds.
#   $<TARGET_FILE:telegram_client_flutter>
#   PARENT_SCOPE
# )
