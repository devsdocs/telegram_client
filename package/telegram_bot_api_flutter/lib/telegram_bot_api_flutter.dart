library telegram_bot_api_flutter;

import 'package:galaxeus_lib/galaxeus_lib.dart';

class TelegramBotApiFlutter {
  static String get getNameBinary {
    if (dart.isWindows) {
      return "telegram-bot-api.exe";
    }
    return "telegram-bot-api";
  }
}
