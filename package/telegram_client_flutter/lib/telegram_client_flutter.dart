// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:io';

String getLibraryTdlib() {
  String library_tdlib = "libtdjson";
  if (Platform.isAndroid || Platform.isLinux) {
    library_tdlib += ".so";
  }
  if (Platform.isMacOS || Platform.isIOS) {
    library_tdlib += ".framework/${library_tdlib}";
  }
  if (Platform.isWindows || Platform.isIOS) {
    library_tdlib += ".dll";
  }
  return library_tdlib;
}
