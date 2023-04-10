// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:universal_io/io.dart';

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
    return 0;
  }
}
