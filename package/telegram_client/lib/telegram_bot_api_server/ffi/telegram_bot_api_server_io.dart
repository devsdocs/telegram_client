// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:universal_io/io.dart';

class Args {
  List<String> args;
  Args(this.args);
  Pointer<Pointer<Utf8>> toNativeList() {
    List<Pointer<Utf8>> utf8PointerList =
        args.map((str) => str.toNativeUtf8()).toList();
    final Pointer<Pointer<Utf8>> pointerPointer =
        malloc.allocate(utf8PointerList.length);
    args.asMap().forEach((index, utf) {
      pointerPointer[index] = utf8PointerList[index];
    });
    return pointerPointer;
  }
}

typedef NativeMainFunction = Int Function(
    Int argc, Pointer<Pointer<Utf8>> args);

typedef DartMainFunction = int Function(int argc, Pointer<Pointer<Utf8>> args);

class LibTelegramBotApi {
  LibTelegramBotApi();

  String getLibraryLibTelegramBotapi() {
    String libraryLibTelegramBotApi = "libtelegram-bot-api";
    if (Platform.isAndroid || Platform.isLinux) {
      libraryLibTelegramBotApi += ".so";
    }
    if (Platform.isMacOS || Platform.isIOS) {
      libraryLibTelegramBotApi += ".framework/${libraryLibTelegramBotApi}";
    }
    if (Platform.isWindows || Platform.isIOS) {
      libraryLibTelegramBotApi += ".dll";
    }
    return libraryLibTelegramBotApi;
  }

  int runFromLibrary({
    String? telegramBotApiLibrary,
    required List<String> arguments,
  }) {
    telegramBotApiLibrary ??= getLibraryLibTelegramBotapi();
    DynamicLibrary dynamicLibrary = DynamicLibrary.open(telegramBotApiLibrary);
    Args args_test = Args([
      "./telegram-bot-api",
      ...arguments,
    ]);
    return dynamicLibrary
        .lookupFunction<NativeMainFunction, DartMainFunction>("cli")
        .call(args_test.args.length, args_test.toNativeList());
  }
}
