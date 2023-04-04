// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:io';
import 'dart:math';

import 'package:alfred/alfred.dart';
import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_bot_api_template/telegram_bot_api_template.dart';
import 'package:telegram_client/telegram_bot_api/telegram_bot_api.dart';

void main(List<String> arguments) async {
  Directory directory_current = Directory.current;
  String random_port = List.generate(4, (index) {
    List<int> numbers = List.generate(10, (index) => index).toList();
    return numbers[Random().nextInt(numbers.length)];
  }).toList().join("");

  int port = int.parse(Platform.environment["PORT"] ?? random_port);
  String host = Platform.environment["HOST"] ?? "0.0.0.0";
  bool is_local_bot_api = false;

  Map telegram_bot_api_option = {};

  String token_bot = "";
  EventEmitter eventEmitter = EventEmitter();
  TelegramBotApi tg =
      TelegramBotApi(token_bot, clientOption: telegram_bot_api_option);
  Alfred server = Alfred();

  TelegramBotApiTemplate telegramBotApiTemplate = TelegramBotApiTemplate(
    tg: tg,
    server: server,
    eventEmitter: eventEmitter,
  );

  telegramBotApiTemplate.run();

  await server.listen(
    port,
    host,
  );
}
