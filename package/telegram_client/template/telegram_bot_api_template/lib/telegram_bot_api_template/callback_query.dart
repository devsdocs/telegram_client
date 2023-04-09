// ignore_for_file: non_constant_identifier_names, unused_local_variable, empty_catches

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_bot_api_template/database/database.dart';
import 'package:telegram_bot_api_template/extension/extension.dart';
import 'package:telegram_bot_api_template/scheme/scheme.dart';
import 'package:telegram_bot_api_template/update_bot.dart';
import 'package:telegram_client/telegram_client.dart';

class CallBackData {
  List<String> callback_datas;
  CallBackData({
    required this.callback_datas,
  });

  /// operator map data
  String? operator [](int index) {
    return get(index);
  }

  String? get last {
    try {
      return callback_datas.last;
    } catch (e) {}
    return null;
  }

  String? get first {
    try {
      return callback_datas.first;
    } catch (e) {}
    return null;
  }

  String? get(int index) {
    try {
      return callback_datas[index];
    } catch (e) {}
    return null;
  }
}

Future<Map?> callbackQuery(
  Map update, {
  required DatabaseTg databaseTg,
  required TgClientData tgClientData,
  required TelegramBotApi tg,
  required UpdateBot updateBot,
}) async {
  int main_bot_user_id = int.parse(tg.token_bot.split(":")[0]);
  tgClientData["client_user_id"] = main_bot_user_id;
  bool isMainBot = false;

  if (update["message"] is Map == false) {
    update["message"] = {
      "message_id": 0,
      "from": {
        "id": 0,
        "first_name": "",
        "last_name": "",
        "username": "",
        "type": "private",
      },
      "chat": {
        "id": 0,
        "first_name": "",
        "last_name": "",
        "username": "",
        "type": "private",
      },
      "date": 0,
      "text": ""
    };
  }
  if (update["message"]["chat"] is Map == false) {
    update["message"]["chat"] = {
      "id": 0,
      "first_name": "",
      "last_name": "",
      "username": "",
      "type": "private",
    };
  }
  if (update["message"]["from"] is Map == false) {
    update["message"]["from"] = {
      "id": 0,
      "first_name": "",
      "last_name": "",
      "username": "",
      "type": "private",
    };
  }
  update["from_bot"] = update["message"]["from"];
  var cb = update;
  var msg = update["message"];
  msg["from"] = update["from"];
  var chat_id = msg["chat"]["id"];
  int msg_id = msg["message_id"];
  late String inline_message_id = "";
  if (cb["inline_message_id"] is String) {
    inline_message_id = cb["inline_message_id"];
  } else {
    inline_message_id = "";
  }
  late String text = "";
  late String msg_caption = "";
  if (msg["text"] is String) {
    text = msg["text"];
  }
  late String caption = "";
  if (msg["caption"] is String) {
    caption = msg["caption"];
  }
  if (text.isNotEmpty) {
    msg_caption = text;
  }
  if (caption.isNotEmpty) {
    msg_caption = caption;
  }
  int from_id = msg["from"]["id"];
  String chat_title = "";
  if (msg["chat"]["title"] is String) {
    chat_title = msg["chat"]["title"];
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
  String data = cb["data"];
  String subData = cb["data"]
      .toString()
      .replaceAll(RegExp(r"(.*:|=.*)", caseSensitive: false), "");
  String subDataId = cb["data"]
      .toString()
      .replaceAll(RegExp(r"(.*=|\-.*)", caseSensitive: false), "");
  String subSubData = cb["data"]
      .toString()
      .replaceAll(RegExp(r"(.*\-)", caseSensitive: false), "");

  List<String> callback_datas = data.split(" ");
  CallBackData callBackData = CallBackData(callback_datas: callback_datas);

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

  late Map option = {
    "method": "editMessageText",
    "callback_query_id": cb["id"],
    "show_alert": true,
    "chat_id": chat_id,
    "message_id": msg_id,
    "parse_mode": "html",
  };

  if (cb["inline_message_id"] is String) {
    option.remove("chat_id");
    option.remove("message_id");
    option["inline_message_id"] = cb["inline_message_id"];
  }
  if (msg["text"] == null) {
    option["method"] = "editMessageCaption";
  }
  try {
    if (RegExp(r"^bot$", caseSensitive: false).hashData(callBackData.first)) {
      if (RegExp(r"^(main_menu)$", caseSensitive: false)
          .hashData(callBackData[1])) {
        option["text"] = "Bot menu\n\nSilahkan tap menunya kak";
        option["reply_markup"] = {
          "inline_keyboard": [
            [
              {
                "text": "Get Me",
                "callback_data": "bot get_me",
              },
              {
                "text": "Sub Menu",
                "callback_data": "bot sub_menu",
              },
            ]
          ]
        };
        return await tg.request(option["method"], parameters: option);
      }
      if (RegExp(r"^(main_menu)$", caseSensitive: false)
          .hashData(callBackData[1])) {
        option["text"] = "Bot menu\n\nSilahkan tap menunya kak";
        option["reply_markup"] = {
          "inline_keyboard": [
            [
              {
                "text": "Get Me",
                "callback_data": "bot get_me",
              },
              {
                "text": "Sub Menu",
                "callback_data": "bot sub_menu",
              },
            ]
          ]
        };
        return await tg.request(option["method"], parameters: option);
      }
      if (RegExp(r"^(sub_menu)$", caseSensitive: false)
          .hashData(callBackData[1])) {
        option["text"] = "Sub menu\n\nSilahkan tap menunya kak";
        option["reply_markup"] = {
          "inline_keyboard": [
            [
              {
                "text": "Back Menu",
                "callback_data": "bot main_menu",
              },
            ]
          ]
        };
        return await tg.request(option["method"], parameters: option);
      }
    }
  } catch (e) {}

  return null;
}
