// ignore_for_file: non_constant_identifier_names, unused_local_variable, unnecessary_brace_in_string_interps

// import 'package:alfred/alfred.dart';
import 'dart:convert';
import 'dart:io';

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_bot_tdlib_template/utils/utils.dart';
import 'package:telegram_client/telegram_client.dart';
import "package:telegram_bot_tdlib_template/update_tdlib/update_tdlib.dart"
    as update_tdlib;
import "package:path/path.dart" as path;

class UpdateBot {
  Map body;
  Map query;
  String type;
  UpdateBot({
    required this.body,
    required this.query,
    required this.type,
  });
}

class TelegramBotTdlibTemplate {
  Tdlib tg;

  String event_update_bot;
  String telegram_database_key;
  Directory telegram_directory;
  int owner_chat_id;
  List<int> clientUserIds = [];
  List<String> tokenBots;
  TelegramBotTdlibTemplate({
    required this.tg,
    required this.telegram_directory,
    required this.owner_chat_id,
    required this.tokenBots,
    this.telegram_database_key = "",
    this.event_update_bot = "tg_bot_api",
  }) {
    if (!telegram_directory.existsSync()) {
      telegram_directory.createSync(recursive: true);
    }
  }

  Future<Map?> bot() async {
    //// handler update
    tg.on(tg.event_invoke, (UpdateTd update) async {
      if (update.raw["@type"] == "error") {
        tg.event_emitter.emit(
          tg.event_update,
          null,
          UpdateTd(
            update: update.update,
            client_id: update.client_id,
            client_option: update.client_option,
          ),
        );
      }
    });
    tg.on(tg.event_update, (UpdateTd update) async {
      try {
        int bot_user_id =
            parserBotUserIdFromToken(update.client_option["token_bot"]);
        int current_admin_user_id = 0;
        int current_from_client_client_id = 0;
        String current_from_client_type = "core";
        bool is_bot = (update.client_option["is_login_bot"] == true);

        int current_user_id = 0;
        if (is_bot) {
          current_user_id = bot_user_id;
        } else if (update.client_option["client_user_id"] is int) {
          current_user_id = update.client_option["client_user_id"];
        }
        if (update.client_option["from_client_type"] is String) {
          current_from_client_type = update.client_option["from_client_type"];
        }
        if (update.client_option["from_client_client_id"] is int) {
          current_from_client_client_id =
              update.client_option["from_client_client_id"];
        }
        if (update.client_option["admin_user_id"] is int) {
          current_admin_user_id = update.client_option["admin_user_id"];
        }

        if (update.raw["@type"] == "error") {
          if (RegExp(r"Too Many Requests: retry after [0-9]+",
                  caseSensitive: false)
              .hasMatch(update.raw["message"])) {
            if (is_bot) {
              print("exit");
              return null;
            }
            try {
              var getMe = await tg.getMe(clientId: update.client_id);
              print("#00_client_exit: ${getMe["result"]}");
              clientUserIds.remove(getMe["result"]["id"]);
            } catch (e, stack) {
              print("${e.toString()}, ${stack.toString()}");
            }
            print("#1_exit_many_request: ${update.client_id}");
            return await tg.exitClientById(update.client_id, isClose: true);
          }

          if (update.raw["message"] == "Wrong password") {
            try {
              var getMe = await tg.getMe(clientId: update.client_id);
              clientUserIds.remove(getMe["result"]["id"]);
            } catch (e, stack) {
              print("${e.toString()}, ${stack.toString()}");
            }

            return await tg.exitClientById(update.client_id);
          }
        }
        if (update.raw["@type"] == "updateAuthorizationState") {
          if (update.raw["authorization_state"] is Map) {
            var authStateType = update.raw["authorization_state"]["@type"];
            if (tg.client_id != update.client_id) {
              update.client_option["database_key"] = telegram_database_key;
              await tg.initClient(update,
                  clientId: update.client_id,
                  tdlibParameters: update.client_option,
                  isVoid: true);
            } else {
              await tg.initClient(update,
                  clientId: update.client_id,
                  tdlibParameters: update.client_option,
                  isVoid: true);
            }

            if (authStateType == "authorizationStateWaitRegistration") {
              if (update.raw["authorization_state"]["terms_of_service"]
                  is Map) {
                Map terms_of_service = update.raw["authorization_state"]
                    ["terms_of_service"] as Map;
                if (terms_of_service["text"] is Map) {
                  await tg.invoke(
                    "registerUser",
                    parameters: {
                      "first_name": "random name",
                      "last_name": "Azkadev ${DateTime.now().toString()}",
                    },
                    clientId: update.client_id,
                  );
                }
              }
            }

            if (authStateType == "authorizationStateLoggingOut") {}

            if (authStateType == "authorizationStateClosed") {
              print("close: ${update.client_id}");
              await tg.exitClientById(update.client_id);
            }
            if (authStateType == "authorizationStateWaitPhoneNumber") {
              print("wait number or token bot");
              await tg.request(
                "checkAuthenticationBotToken",
                parameters: {
                  "token": update.client_option["token_bot"],
                },
                clientId: update.client_id,
              );
            }

            if (authStateType == "authorizationStateReady") {
              var getMe = await tg.getMe(clientId: update.client_id);
              print(getMe);

              if (tg.client_id == update.client_id) {
                print("succes login main bot");
                // try {
                //   await tg.request(
                //     "createPrivateChat",
                //     parameters: {
                //       "user_id": owner_chat_id,
                //       "force": true,
                //     },
                //     clientId: update.client_id,
                //     isAutoGetChat: false,
                //   );
                //   await tg.request(
                //     "sendMessage",
                //     parameters: {
                //       "chat_id": owner_chat_id,
                //       "text": "Bot Telah Di Restart",
                //     },
                //     clientId: update.client_id,
                //     isAutoGetChat: false,
                //   );
                // } catch (e, stack) {
                //   print("${e.toString()}, ${stack.toString()}");
                // }
              } else {
                print("succes: ${update.client_id}");
              }
            }
          }
        }
        if (update.raw["@type"] == "updateNewInlineQuery") {
          //
        }

        if (update.raw["@type"] == "updateNewCallbackQuery" ||
            update.raw["@type"] == "updateNewInlineCallbackQuery") {
          //
          Map? msg = await update_tdlib.apiUpdateCallbackQuery(update, tg: tg);
          if (msg != null) {
            await updateCallbackQuery(
              msg: msg,
              update: update,
            );
          }
        }

        if (update.raw["@type"] == "updateNewMessage") {
          //
          Map updateNewMessage = update.raw["message"];
          if (updateNewMessage["@type"] == "message") {
            Map? msg = await update_tdlib.apiUpdateMsg(
              updateNewMessage,
              update: update,
              tg: tg,
            );
            if (msg != null) {
              await updateMessage(
                msg: msg,
                updateTd: update,
              );
            }
          }
        }
      } catch (e, stack) {
        print("${e} ${stack}");
      }
    });

    for (var i = 0; i < tokenBots.length; i++) {
      String tokenBot = tokenBots[i];
      int bot_user_id = parserBotUserIdFromToken(tokenBot);
      await Future.delayed(Duration(milliseconds: 10));
      if (i == 0) {
        await tg.initIsolate(
          clientId: tg.client_id,
          clientUserId: bot_user_id,
          clientOption: {
            "token_bot": tokenBot,
            'database_directory':
                path.join(telegram_directory.path, "${bot_user_id}"),
            'files_directory':
                path.join(telegram_directory.path, "${bot_user_id}"),
          },
        );
      } else {
        await tg.initIsolateNewClient(
          clientId: tg.client_create(),
          clientOption: {
            "token_bot": tokenBot,
            'database_directory':
                path.join(telegram_directory.path, "${bot_user_id}"),
            'files_directory':
                path.join(telegram_directory.path, "${bot_user_id}"),
          },
          clientUserId: bot_user_id,
        );
      }
    }
    return null;
  }

  Future<Map?> updateCallbackQuery({
    required Map msg,
    required UpdateTd update,
  }) async {
    int bot_user_id =
        parserBotUserIdFromToken(update.client_option["token_bot"]);
    int current_admin_user_id = 0;
    int current_from_client_client_id = 0;
    String current_from_client_type = "core";
    bool is_bot = (update.client_option["is_login_bot"] == true) ? true : false;
    int current_user_id = 0;
    if (is_bot) {
      current_user_id = bot_user_id;
    } else if (update.client_option["client_user_id"] is int) {
      current_user_id = update.client_option["client_user_id"];
    }
    if (update.client_option["from_client_type"] is String) {
      current_from_client_type = update.client_option["from_client_type"];
    }
    if (update.client_option["from_client_client_id"] is int) {
      current_from_client_client_id =
          update.client_option["from_client_client_id"];
    }
    if (update.client_option["admin_user_id"] is int) {
      current_admin_user_id = update.client_option["admin_user_id"];
    }
    var cb = msg;
    var cbm = msg["message"];
    var text = cb["data"];
    var chatId = cb["chat"]["id"];
    var fromId = cb["from"]["id"];
    Map msg_from = cb["from"];
    Map msg_chat = cb["chat"];
    Map msg_auto_chat = {
      "id": current_user_id,
    };
    Map msg_bot = {
      "id": current_user_id,
      "is_bot": true,
    };
    int from_id = msg["from"]["id"];
    int chat_id = msg["chat"]["id"];
    String chat_type = msg["chat"]["type"]
        .toString()
        .replaceAll(RegExp(r"super", caseSensitive: false), "");
    String chat_type_private = "private";
    if (chat_type == chat_type_private) {
      msg_bot.forEach((key, value) {
        msg_auto_chat[key] = value;
      });
    } else {
      // msg_chat.forEach((key, value) {
      //   msg_auto_chat[key] = value;
      // });
    }
    int msg_auto_chat_id = msg_auto_chat["id"];
    var stringChatId =
        msg["chat"]["id"].toString().replaceAll(RegExp(r"(-100|-)"), "");
    var subMenu = text
        .toString()
        .replaceAll(RegExp(r".*:|=.*", caseSensitive: false), "");
    var subSubMenu =
        text.toString().replaceAll(RegExp(r".*=", caseSensitive: false), "");
    String subData = cb["data"]
        .toString()
        .replaceAll(RegExp(r"(.*:|=.*)", caseSensitive: false), "");
    String subDataId = cb["data"]
        .toString()
        .replaceAll(RegExp(r"(.*=|\-.*)", caseSensitive: false), "");
    String subSubData = cb["data"]
        .toString()
        .replaceAll(RegExp(r"(.*\-)", caseSensitive: false), "");
    int msg_id = (cbm["message_id"] is int) ? cbm["message_id"] : 0;

    Map<String, dynamic> option = {
      "method": "editMessageText",
      "chat_id": chatId,
      "message_id": cbm["message_id"],
      "callback_query_id": cb["id"],
      "show_alert": true,
      "parse_mode": "html",
    };

    if (cb["inline_message_id"] != null) {
      return null;
    }

    if (RegExp(r"bot:.*", caseSensitive: false).hashData(text)) {
      if (RegExp(r"main_menu", caseSensitive: false).hashData(subMenu)) {
        return await tg.request(
          "editMessageText",
          parameters: {
            "chat_id": chatId,
            "message_id": cbm["message_id"],
            "text": "Hallo manies\n\nDari menu ini anda\n\n",
            "reply_markup": {
              "inline_keyboard": [
                [
                  {
                    "text": "Sub Menu",
                    "callback_data": "bot:sub_menu",
                  }
                ],
              ]
            }
          },
          clientId: update.client_id,
        );
      }
      if (RegExp(r"sub_menu", caseSensitive: false).hashData(subMenu)) {
        return await tg.request(
          "editMessageText",
          parameters: {
            "chat_id": chatId,
            "message_id": cbm["message_id"],
            "text": "Ini sub menu",
            "reply_markup": {
              "inline_keyboard": [
                [
                  {
                    "text": "Back",
                    "callback_data": "bot:main_menu",
                  }
                ],
              ]
            }
          },
          clientId: update.client_id,
        );
      }
    }
    return null;
  }

  Future<Map?> updateMessage({
    required Map msg,
    required UpdateTd updateTd,
  }) async {
    String text = "";
    if (msg["text"] is String) {
      text = msg["text"];
    }
    bool isOutgoing = false;
    if (msg["is_outgoing"] is bool) {
      isOutgoing = msg["is_outgoing"];
    }
    if (msg["chat"] is Map == false) {
      return null;
    }
    bool isAdmin = false;
    Map msg_from = msg["from"];
    Map msg_chat = msg["chat"];
    Map msg_auto_from = {
      "id": msg_from["id"],
    };
    msg_from.forEach((key, value) {
      msg_auto_from[key] = value;
    });
    int msg_id = (msg["message_id"] is int) ? (msg["message_id"] as int) : 0;
    int from_id = msg_from["id"];
    int chat_id = msg_chat["id"];
    if (msg["chat"]["type"] is String == false) {
      msg["chat"]["type"] = "";
    }
    String chat_type = (msg["chat"]["type"] as String)
        .replaceAll(RegExp(r"super", caseSensitive: false), "");
    if (chat_type.isEmpty) {
      return null;
    }

    if (RegExp(r"^(/start)$", caseSensitive: false).hashData(text)) {
      return await tg.request(
        "sendMessage",
        parameters: {
          "chat_id": chat_id,
          "text": "Hallo Perkenalkan saya adalah robot @azkadev",
          "reply_markup": {
            "inline_keyboard": [
              [
                {
                  "text": "Main Menu",
                  "callback_data": "bot:main_menu",
                }
              ],
            ]
          }
        },
        isAutoExtendMessage: true,
        clientId: updateTd.client_id,
      );
    }
    if (RegExp(r"^(/ping)$", caseSensitive: false).hashData(text)) {
      return await tg.request(
        "sendMessage",
        parameters: {
          "chat_id": chat_id,
          "text": "Pong",
        },
        isAutoExtendMessage: true,
        clientId: updateTd.client_id,
      );
    }
    if (RegExp(r"^(/jsondump)$", caseSensitive: false).hashData(text)) {
      return await tg.request(
        "sendMessage",
        parameters: {
          "chat_id": chat_id,
          "text": json.encode(msg),
        },
        isAutoExtendMessage: true,
        clientId: updateTd.client_id,
      );
    }
    return null;
  }
}
