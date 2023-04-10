# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(telegram_bot_api_flutter_library VERSION 0.0.1 LANGUAGES C)

add_library(telegram_bot_api_flutter SHARED
  "telegram_bot_api_flutter.c"
)

set_target_properties(telegram_bot_api_flutter PROPERTIES
  PUBLIC_HEADER telegram_bot_api_flutter.h
  OUTPUT_NAME "telegram_bot_api_flutter"
)

target_compile_definitions(telegram_bot_api_flutter PUBLIC DART_SHARED_LIB)
