// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unused_import

import "dart:io";

import "package:galaxeus_lib/galaxeus_lib.dart";
import "package:telegram_userbot_tdlib_template/telegram_userbot_tdlib_template.dart";
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

String ask({
  required String question,
}) {
  while (true) {
    stdout.write(question);
    String? res = stdin.readLineSync();
    if (res != null && res.isNotEmpty) {
      return res;
    }
  }
}

void main(List<String> arguments) async {
  Directory directory_current = Directory.current;
  Directory telegram_directory = Directory(path.join(directory_current.path, "tg_database"));

  List<String> name_clients = ["azka"];

  /// telegram database
  int api_id = 0; // telegram api id
  String api_hash = ""; // telegram api hash
  int owner_chat_id = 0; // owner telegram chat id
  Map<String, Map> extraData = {};
  Tdlib tg = Tdlib(
    pathTdl: "libtdjson.${getFormatLibrary}",
    clientOption: {
      'api_id': api_id,
      'api_hash': api_hash,
    },
    invokeTimeOut: Duration(minutes: 10),
    delayInvoke: Duration(milliseconds: 10),
    on_get_invoke_data: (extra, client_id) async {
      print("Get Data");
      while (true) {
        await Future.delayed(Duration(milliseconds: 1));
        Map? data = extraData[extra];
        if (data != null) {
          data = data.clone();
          print("send: ${data}");
          extraData.remove(extra);
          return data;
        }
      }
    },
    on_receive_update: (update, libTdJson) async {
      if (update is TdlibIsolateReceiveData) {
        TdlibIsolateReceiveData tdlibIsolateReceiveData = update;
        try {
          if (tdlibIsolateReceiveData.updateData["@extra"] is String) {
            extraData[tdlibIsolateReceiveData.updateData["@extra"]] = tdlibIsolateReceiveData.updateData;
          } else {
            libTdJson.event_emitter.emit(libTdJson.event_update, null, tdlibIsolateReceiveData);
          }
        } catch (e) {
          libTdJson.event_emitter.emit(libTdJson.event_update, null, tdlibIsolateReceiveData);
        }
      } else if (update is TdlibIsolateReceiveDataError) {
        TdlibIsolateReceiveDataError tdlibIsolateReceiveDataError = update;
        try {
          TdlibClient? tdlibClient = libTdJson.clients.getClientById(tdlibIsolateReceiveDataError.clientId);
          if (tdlibClient != null) {
            tdlibClient.close();
          }
        } catch (e) {}
      }
    },
  );

  TelegramUserbotTdlibTemplate telegram_userbot_tdlib_template = TelegramUserbotTdlibTemplate(
    tg: tg,
    telegram_directory: telegram_directory,
    owner_chat_id: owner_chat_id,
    name_clients: name_clients,
  );

  await telegram_userbot_tdlib_template.userbot(
    onAuthState: (int client_id, String name_client, AuthorizationStateType authorizationStateType) async {
      ///
      if (authorizationStateType == AuthorizationStateType.phone_number) {
        String phone_number = ask(question: "Phone Number: ");
        phone_number = phone_number.replaceAll(RegExp(r"(\+|([ ]+))", caseSensitive: false), "");
        await tg.request(
          "setAuthenticationPhoneNumber",
          parameters: {
            "phone_number": phone_number,
          },
          clientId: client_id, // add this if your project more one client
        );
      }

      if (authorizationStateType == AuthorizationStateType.code) {
        String code = ask(question: "Code: ");
        await tg.request(
          "checkAuthenticationCode",
          parameters: {
            "code": code,
          },
          clientId: client_id, // add this if your project more one client
        );
      }
      if (authorizationStateType == AuthorizationStateType.password) {
        String password = ask(question: "Password: ");
        await tg.request(
          "checkAuthenticationPassword",
          parameters: {
            "password": password,
          },
          clientId: client_id, // add this if your project more one client
        );
      }
    },
  );
}
