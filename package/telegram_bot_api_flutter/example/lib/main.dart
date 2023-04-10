import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:telegram_bot_api_flutter/telegram_bot_api_flutter.dart' as telegram_bot_api_flutter;
import 'package:telegram_client/telegram_client.dart';
import "package:path/path.dart" as path;

import "package:galaxeus_lib/galaxeus_lib.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String current_path = Directory.current.path;
  Directory tg_bot_dir = Directory(path.join(current_path, "telegram_bot"));
  Directory tg_bot_db_dir = Directory(path.join(tg_bot_dir.path, "db")); 
  if (!tg_bot_db_dir.existsSync()) {
    await tg_bot_db_dir.create(recursive: true);
  }
  List<String> paths = dart.resolvedExecutable.split(dart.pathSeparator);
  paths.removeLast();
  Directory directory_app = Directory(path.joinAll([dart.pathSeparator, ...paths]));
  int api_id = int.tryParse(Platform.environment["api_id"] ?? "94575") ?? 94575;
  String api_hash = Platform.environment["api_hash"] ?? "a3406de8d171bb422bb6ddf3bbd800e2";
  TelegramBotApiServer telegramBotApiServer = TelegramBotApiServer();
  await Process.run("chmod", ["777", path.join(directory_app.path, "bin", "telegram-bot-api-cli")], runInShell: false);
  Process shell = await telegramBotApiServer.run(
    executable: path.join(directory_app.path, "bin", "telegram-bot-api-cli"),
    workingDirectory: path.join(
      directory_app.path,
      "bin",
    ),
    arguments: telegramBotApiServer.optionsParameters(
      api_id: "${api_id}",
      api_hash: api_hash,
      local: "yes",
      http_port: "9001",
      dir: tg_bot_db_dir.path,
      temp_dir: tg_bot_db_dir.path,
    ),
    runInShell: true,
  );
  shell.stderr.listen((event) {
    stderr.add(event);
  });

  shell.stdout.listen((event) {
    stdout.add(event);
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
