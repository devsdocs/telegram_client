// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, empty_catches

import 'dart:async';

import 'package:http/http.dart';
import 'package:universal_io/io.dart';

/// telegram bot api server
class TelegramBotApiServer {
  /// if you want bot server local use this
  TelegramBotApiServer();

  /// make parameters easy
  List<String> optionsParameters({
    bool? local,
    required String api_id,
    required String api_hash,
    String? http_port,
    String? http_stat_port,
    String? dir,
    String? temp_dir,
    String? filter,
    String? max_webhook_connections,
    String? http_ip_address,
    String? http_stat_ip_address,
    String? log,
    String? verbosity,
    String? memory_verbosity,
    String? log_max_file_size,
    String? username,
    String? groupname,
    String? max_connections,
    String? proxy,
  }) {
    Map data = {
      "--local": local,
      "--api-id": api_id,
      "--api-hash": api_hash,
      "--http-port": http_port,
      "--http-stat-port": http_stat_port,
      "--dir": dir,
      "--temp-dir": temp_dir,
      "--filter": filter,
      "--max-webhook-connections": max_webhook_connections,
      "--http-ip-address": http_ip_address,
      "--http-stat-ip-address": http_stat_ip_address,
      "--log": log,
      "--verbosity": verbosity,
      "--memory-verbosity": memory_verbosity,
      "--log-max-file-size": log_max_file_size,
      "--username": username,
      "--groupname": groupname,
      "--max-connections": max_connections,
      "--proxy": proxy,
    };
    List<String> arguments = ["test"];
    data.forEach((key, value) {
      if (key == "--local") {
        if (value == true) {
          arguments.add("${key}");
        }
      } else if (value != null) {
        arguments.add("${key}=${value}");
      }
    });
    if (arguments.length > 2) {
      arguments.remove("test");
    }
    return arguments;
  }

  /// run executable telegram bot api
  Future<Process> run({
    required String executable,
    required List<String> arguments,
    required String host,
    required int tg_bot_api_port,
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = true,
    ProcessStartMode mode = ProcessStartMode.normal,
    bool is_print = false,
  }) async {
    Process shell_tg_bot = await Process.start(
      executable,
      arguments,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      workingDirectory: workingDirectory,
      mode: mode,
    );

    if (is_print) {
      var stderr_wa = shell_tg_bot.stderr.listen((event) {
        try {
          stderr.add(event);
        } catch (e) {}
      });
      // shell_tg_bot
      var stdout_wa = shell_tg_bot.stdout.listen((event) {
        try {
          stdout.add(event);
        } catch (e) {}
      });
      Timer.periodic(Duration(seconds: 2), (timer) async {
        try {
          await get(Uri.parse("http://${host}:${tg_bot_api_port}"));
        } catch (e) {
          if (e is ClientException) {
            if (e.message == "Connection refused") {
              timer.cancel();
              await stderr_wa.cancel();
              await stdout_wa.cancel();
              shell_tg_bot.kill(ProcessSignal.sigkill);
              await run(
                executable: executable,
                arguments: arguments,
                host: host,
                tg_bot_api_port: tg_bot_api_port,
                workingDirectory: workingDirectory,
                environment: environment,
                includeParentEnvironment: includeParentEnvironment,
                runInShell: runInShell,
                mode: mode,
                is_print: is_print,
              );
            }
          }
        }
      });
    } else {
      Timer.periodic(Duration(seconds: 2), (timer) async {
        try {
          await get(Uri.parse("http://${host}:${tg_bot_api_port}"));
        } catch (e) {
          if (e is ClientException) {
            if (e.message == "Connection refused") {
              timer.cancel();
              // await stderr_wa.cancel();
              // await stdout_wa.cancel();
              shell_tg_bot.kill(ProcessSignal.sigkill);
              await run(
                executable: executable,
                arguments: arguments,
                host: host,
                tg_bot_api_port: tg_bot_api_port,
                workingDirectory: workingDirectory,
                environment: environment,
                includeParentEnvironment: includeParentEnvironment,
                runInShell: runInShell,
                mode: mode,
                is_print: is_print,
              );
            }
          }
        }
      });
    }

    return shell_tg_bot;
  }
}
