// ignore_for_file: non_constant_identifier_names, unused_local_variable, unnecessary_brace_in_string_interps

import 'dart:io';
import 'dart:math';

import 'package:alfred/alfred.dart';
import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_bot_api_template/database/database.dart';
import 'package:telegram_bot_api_template/telegram_bot_api_template.dart';
import 'package:telegram_client/telegram_client.dart';

import "package:telegram_bot_api_template/database/scheme/scheme.dart"
    as isar_scheme;
import "package:path/path.dart" as path;
import "package:isar/isar.dart" as isar;
import 'package:xendit/xendit.dart';
import "package:supabase_client/supabase_client.dart" as supabase_client;

void main(List<String> arguments) async {
  Directory directory_current = Directory.current;
  String random_port = List.generate(4, (index) {
    List<int> numbers = List.generate(10, (index) => index).toList();
    return numbers[Random().nextInt(numbers.length)];
  }).toList().join("");

  int port = int.parse(Platform.environment["PORT"] ?? random_port);
  String host = Platform.environment["HOST"] ?? "0.0.0.0";
  bool is_local_bot_api = (Platform.environment["is_local_bot_api"] != null);
  int bot_api_port = int.parse(Platform.environment["bot_api_port"] ?? "9000");
  int api_id = int.tryParse(Platform.environment["api_id"] ?? "94575") ?? 94575;
  String api_hash =
      Platform.environment["api_hash"] ?? "a3406de8d171bb422bb6ddf3bbd800e2";
  String url_webhook = Platform.environment["tg_bot_webhook"] ?? "";
  String xen_key_api = Platform.environment["xen_key_api"] ?? "";
  String supabase_id = Platform.environment["supabase_id"] ?? "";
  String supabase_key = Platform.environment["supabase_key"] ?? "";
  Map telegram_bot_api_option = {};

  String current_path = Directory.current.path;
  Directory tg_bot_dir = Directory(path.join(current_path, "telegram_bot"));
  Directory tg_bot_db_dir = Directory(path.join(tg_bot_dir.path, "db"));
  if (!tg_bot_db_dir.existsSync()) {
    await tg_bot_db_dir.create(recursive: true);
  }

  String token_bot = Platform.environment["token_bot"] ?? "";

  if (is_local_bot_api) {
    print("local bot api: http://localhost:${bot_api_port}/");
    telegram_bot_api_option["api"] = "http://localhost:${bot_api_port}/";
    TelegramBotApiServer telegramBotApiServer = TelegramBotApiServer();
    Process shell = await telegramBotApiServer.run(
      executable: "telegram-bot-api",
      arguments: telegramBotApiServer.optionsParameters(
        api_id: "${api_id}",
        api_hash: api_hash,
        local: "yes",
        http_port: "${bot_api_port}",
        dir: tg_bot_db_dir.path,
      ),
      runInShell: false,
    );
    shell.stderr.listen((event) {
      stderr.add(event);
    });

    shell.stdout.listen((event) {
      stdout.add(event);
    });
  }

  EventEmitter eventEmitter = EventEmitter();
  TelegramBotApi tg =
      TelegramBotApi(token_bot, clientOption: telegram_bot_api_option);
  Map get_me = await tg.request("getMe");

  print(jsonToMessage(get_me["result"], jsonFullMedia: {}));
  File file = File(
      "/home/galaxeus/Documents/hexaminate/app/telegram_client/package/telegram_client/template/telegram_bot_api_template/README.md");
  var bytes = file.readAsBytesSync();
  await tg.request(
    "sendMediaGroup",
    parameters: {
      "chat_id": 5308590964,
      "media": [
        {"type": "document", "media": file},
        {"type": "document", "media": file}
      ],
    },
    is_form: false,
  );
  exit(0);
}
