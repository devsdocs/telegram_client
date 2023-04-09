// ignore_for_file: non_constant_identifier_names, unused_local_variable, empty_catches

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_bot_api_template/database/database.dart';
import 'package:telegram_bot_api_template/extension/extension.dart';
import 'package:telegram_bot_api_template/scheme/scheme.dart';
import 'package:telegram_bot_api_template/update_bot.dart';
import 'package:telegram_client/telegram_client.dart';

Future<Map?> updateMessage(
  Map update, {
  required DatabaseTg databaseTg,
  required TgClientData tgClientData,
  required TelegramBotApi tg,
  required UpdateBot updateBot,
}) async {
  int main_bot_user_id = int.parse(tg.token_bot.split(":")[0]);
  tgClientData["client_user_id"] = main_bot_user_id;
  if (update["chat"]["type"] == "channel") {
    update["from"] = update["sender_chat"];
  }
  bool isMainBot = false;

  var msg = update;
  int msg_id = msg["message_id"];
  String text = "";
  String msg_caption = "";
  if (msg["text"] is String) {
    text = msg["text"];
  }
  String caption = "";
  if (msg["caption"] is String) {
    caption = msg["caption"];
  }
  if (text.isNotEmpty) {
    msg_caption = text;
  }
  if (caption.isNotEmpty) {
    msg_caption = caption;
  }

  Map msg_from = msg["from"];
  Map msg_chat = msg["chat"];
  Map msg_auto_from = {
    "id": msg_from["id"],
  };

  msg_from.forEach((key, value) {
    msg_auto_from[key] = value;
  });

  Map msg_auto_chat = {
    "id": 0,
  };
  Map msg_bot = {
    "id": tgClientData.client_user_id,
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
    msg_chat.forEach((key, value) {
      msg_auto_chat[key] = value;
    });
  }

  int msg_auto_chat_id = msg_auto_chat["id"];

  var stringChatId =
      msg["chat"]["id"].toString().replaceAll(RegExp(r"(-100|-)"), "");

  ChatData get_chat_data = await databaseTg.getChat(
    chat_type: chat_type,
    chat_id: msg_auto_chat_id,
    value: msg_auto_chat,
    isSaveNotFound: false,
    tgClientData: tgClientData,
    onNotFoundData: () async {
      try {
        if (chat_type == "private") {
          msg_auto_chat["join_date"] = msg["date"];
          Map getMe = await tg.request("getMe");
          msg_auto_chat.addAll((getMe["result"] as Map));
        } else {
          try {
            Map getChatAdministrators = await tg.request(
                "getChatAdministrators",
                parameters: {"chat_id": chat_id});
            if (getChatAdministrators["ok"] == true &&
                getChatAdministrators["result"] is List) {
              List admins_array = (getChatAdministrators["result"] as List);
              List id_admins =
                  admins_array.map((res) => res["user"]["id"]).toList();
              msg_auto_chat["admins"] = admins_array;
            }
          } catch (e) {}
        }

        try {
          msg_auto_chat.updateVoid(
              data: DefaultDataBase.initData(isUser: false));
        } catch (e) {}
        ChatData chatData = ChatData(msg_auto_chat);
        await databaseTg.saveChat(
          chat_type: chat_type,
          chat_id: msg_auto_chat_id,
          newData: msg_auto_chat,
          tgClientData: tgClientData,
        );
        return chatData;
      } catch (e) {
        ChatData chatData = ChatData(msg_auto_chat);
        await databaseTg.saveChat(
          chat_type: chat_type,
          chat_id: msg_auto_chat_id,
          newData: msg_auto_chat,
          tgClientData: tgClientData,
        );
        return chatData;
      }
    },
  );
  try {
    get_chat_data.rawData
        .updateVoid(data: DefaultDataBase.initData(isUser: false));
  } catch (e) {}
  ChatData? get_user_data = await databaseTg.getChat(
    chat_type: chat_type_private,
    chat_id: from_id,
    value: msg_auto_from,
    isSaveNotFound: false,
    tgClientData: tgClientData,
    onNotFoundData: () async {
      try {
        try {
          msg_auto_from.updateVoid(
              data: DefaultDataBase.initData(isUser: true));
        } catch (e) {}
        ChatData chatData = ChatData(msg_auto_from);
        await databaseTg.saveChat(
          chat_type: chat_type_private,
          chat_id: from_id,
          newData: msg_auto_from,
          tgClientData: tgClientData,
        );
        return chatData;
      } catch (e) {
        ChatData chatData = ChatData(msg_auto_from);
        await databaseTg.saveChat(
          chat_type: chat_type_private,
          chat_id: from_id,
          newData: msg_auto_from,
          tgClientData: tgClientData,
        );
        return chatData;
      }
    },
  );

  try {
    get_user_data.rawData
        .updateVoid(data: DefaultDataBase.initData(isUser: true));
  } catch (e) {}
  if (get_chat_data["wallet"] is Map == false) {
    get_chat_data["wallet"] = {};
  }

  try {
    if (text.isNotEmpty) {
      if (RegExp(r"^(/start)", caseSensitive: false).hashData(text)) {
        return await tg.request("sendMessage", parameters: {
          "chat_id": chat_id,
          "text": "Hai perkenalkan saya adalah robot dari Azkadev",
          "reply_markup": {
            "inline_keyboard": [
              [
                {
                  "text": "Main Menu",
                  "callback_data": "bot main_menu",
                }
              ],
              [
                {
                  "text": "Github",
                  "url": "https://github.com/azkadev",
                }
              ]
            ]
          }
        });
      }
      if (RegExp(r"^(/ping)", caseSensitive: false).hashData(text)) {
        return await tg.request("sendMessage",
            parameters: {"chat_id": chat_id, "text": "Pong"});
      }
    }
  } catch (e) {}

  return null;
}
