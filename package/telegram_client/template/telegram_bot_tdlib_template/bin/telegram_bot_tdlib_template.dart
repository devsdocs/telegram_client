// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps

import "dart:io";

import "package:telegram_bot_tdlib_template/telegram_bot_tdlib_template.dart";
import "package:telegram_client/telegram_client.dart";
import "package:path/path.dart" as path;

String get getFormatLibrary {
  if (Platform.isAndroid || Platform.isLinux) {
    return "so";
  } else if (Platform.isIOS || Platform.isMacOS) {
    return "dylib";
  } else {
    return "dll";
  }
}

void main(List<String> arguments) async {
  Directory directory_current = Directory.current;
  Directory telegram_directory =
      Directory(path.join(directory_current.path, "tg_database"));

  /// telegram database
  int api_id = 0; // telegram api id
  String api_hash = ""; // telegram api hash
  int owner_chat_id = 0; // owner telegram chat id
  List<String> tokenBots = []; // token bots

  Tdlib tg = Tdlib(
    pathTdl: "libtdjson.${getFormatLibrary}",
    clientOption: {
      'api_id': api_id,
      'api_hash': api_hash,
    },
    invokeTimeOut: Duration(minutes: 10),
    delayInvoke: Duration(milliseconds: 10),
  );

  TelegramBotTdlibTemplate telegram_bot_tdlib_template =
      TelegramBotTdlibTemplate(
    tg: tg,
    telegram_directory: telegram_directory,
    owner_chat_id: owner_chat_id,
    tokenBots: tokenBots,
  );

  await telegram_bot_tdlib_template.bot();
}
