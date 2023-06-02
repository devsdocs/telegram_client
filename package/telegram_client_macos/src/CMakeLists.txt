# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(telegram_client_macos_library VERSION 0.0.1 LANGUAGES C)

add_library(telegram_client_macos SHARED
  "telegram_client_macos.c"
)

set_target_properties(telegram_client_macos PROPERTIES
  PUBLIC_HEADER telegram_client_macos.h
  OUTPUT_NAME "telegram_client_macos"
)

target_compile_definitions(telegram_client_macos PUBLIC DART_SHARED_LIB)
