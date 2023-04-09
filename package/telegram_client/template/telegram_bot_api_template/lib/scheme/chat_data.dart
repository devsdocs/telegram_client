// ignore_for_file: non_constant_identifier_names
import "json_dart.dart";
// import "dart:convert";

import "admins.dart";
import "state.dart";

class ChatData extends JsonDart {
  ChatData(super.rawData);

  static Map get defaultData {
    return {
      "@type": "ChatData",
      "id": -1001874491091,
      "title": "asaskak",
      "username": "masmkamskamksmak",
      "first_name": "",
      "last_name": "",
      "is_bot": true,
      "is_auto_read": true,
      "is_auto_clear": true,
      "is_auto_block": false,
      "is_afk": false,
      "is_ai_chatbot": false,
      "is_ai_task": false,
      "is_blocked": false,
      "is_mute": false,
      "ads_gateway_price_day": 10000,
      "ads_gateway_price_pinned": 10000,
      "ads_gateway_price_repeat_msg_day": 10000,
      "ads_gateway_blacklist_word": "",
      "is_ads_gateway": false,
      "ads_gateway_is_require_review": false,
      "ads_gateway_type_content": ["text"],
      "is_subscribe": false,
      "is_start_msg_log": false,
      "is_restrict_log": false,
      "subscribe_expire_date": 0,
      "admins": [
        {
          "user": {
            "@type": "user",
            "id": 5604530106,
            "is_bot": false,
            "first_name": "Kazekage",
            "username": "sadssfsmfm",
            "language_code": "en"
          },
          "status": "creator",
          "can_be_edited": false,
          "can_manage_chat": true,
          "can_change_info": true,
          "can_delete_messages": true,
          "can_invite_users": true,
          "can_restrict_members": true,
          "can_pin_messages": true,
          "can_promote_members": true,
          "can_manage_video_chats": true,
          "is_anonymous": false,
          "can_manage_voice_chats": true,
          "@type": "admins"
        },
        {
          "user": {
            "id": 5604530106,
            "is_bot": false,
            "first_name": "Kazekage",
            "username": "sadssfsmfm",
            "language_code": "en"
          },
          "status": "creator",
          "is_anonymous": false,
          "@type": "admins"
        }
      ],
      "state": {
        "@type": "state",
        "chat_id": 121,
        "user_id": 123124,
        "setting": "",
        "message_id": 12141,
        "setup": {"@type": "setup", "id": "setChat", "chat_id": 31313131},
        "message_data": "",
        "is_without_delete_msg_me": false,
        "is_delete_msg": false,
        "step": "",
        "version": "",
        "data": {
          "@type": "data",
          "month": 0,
          "token_bot": "",
          "username": "",
          "password": "",
          "token": "",
          "target_user_id": 0,
          "amount": 0,
          "user_id": 0,
          "invoice": {
            "@type": "invoice",
            "id": "6400761f118264bbc49c871b",
            "status": "pending",
            "external_id": "oaksoaks",
            "amount": 50000,
            "title": "HEXAMINATE",
            "profile_picture": {
              "@type": "profilePictureUrl",
              "url":
                  "https://xnd-merchant-logos.s3.amazonaws.com/business/production/610836e3824b6140a513dc38-1648053563560.png"
            },
            "url": "https://checkout.xendit.co/web/6400761f118264bbc49c871b"
          }
        }
      }
    };
  }

  String? get special_type {
    try {
      if (rawData["@type"] is String == false) {
        return null;
      }
      return rawData["@type"] as String;
    } catch (e) {
      return null;
    }
  }

  int? get id {
    try {
      if (rawData["id"] is int == false) {
        return null;
      }
      return rawData["id"] as int;
    } catch (e) {
      return null;
    }
  }

  String? get title {
    try {
      if (rawData["title"] is String == false) {
        return null;
      }
      return rawData["title"] as String;
    } catch (e) {
      return null;
    }
  }

  String? get username {
    try {
      if (rawData["username"] is String == false) {
        return null;
      }
      return rawData["username"] as String;
    } catch (e) {
      return null;
    }
  }

  String? get first_name {
    try {
      if (rawData["first_name"] is String == false) {
        return null;
      }
      return rawData["first_name"] as String;
    } catch (e) {
      return null;
    }
  }

  String? get last_name {
    try {
      if (rawData["last_name"] is String == false) {
        return null;
      }
      return rawData["last_name"] as String;
    } catch (e) {
      return null;
    }
  }

  bool? get is_bot {
    try {
      if (rawData["is_bot"] is bool == false) {
        return null;
      }
      return rawData["is_bot"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_auto_read {
    try {
      if (rawData["is_auto_read"] is bool == false) {
        return null;
      }
      return rawData["is_auto_read"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_auto_clear {
    try {
      if (rawData["is_auto_clear"] is bool == false) {
        return null;
      }
      return rawData["is_auto_clear"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_auto_block {
    try {
      if (rawData["is_auto_block"] is bool == false) {
        return null;
      }
      return rawData["is_auto_block"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_afk {
    try {
      if (rawData["is_afk"] is bool == false) {
        return null;
      }
      return rawData["is_afk"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_ai_chatbot {
    try {
      if (rawData["is_ai_chatbot"] is bool == false) {
        return null;
      }
      return rawData["is_ai_chatbot"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_ai_task {
    try {
      if (rawData["is_ai_task"] is bool == false) {
        return null;
      }
      return rawData["is_ai_task"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_blocked {
    try {
      if (rawData["is_blocked"] is bool == false) {
        return null;
      }
      return rawData["is_blocked"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_mute {
    try {
      if (rawData["is_mute"] is bool == false) {
        return null;
      }
      return rawData["is_mute"] as bool;
    } catch (e) {
      return null;
    }
  }

  int? get ads_gateway_price_day {
    try {
      if (rawData["ads_gateway_price_day"] is int == false) {
        return null;
      }
      return rawData["ads_gateway_price_day"] as int;
    } catch (e) {
      return null;
    }
  }

  int? get ads_gateway_price_pinned {
    try {
      if (rawData["ads_gateway_price_pinned"] is int == false) {
        return null;
      }
      return rawData["ads_gateway_price_pinned"] as int;
    } catch (e) {
      return null;
    }
  }

  int? get ads_gateway_price_repeat_msg_day {
    try {
      if (rawData["ads_gateway_price_repeat_msg_day"] is int == false) {
        return null;
      }
      return rawData["ads_gateway_price_repeat_msg_day"] as int;
    } catch (e) {
      return null;
    }
  }

  String? get ads_gateway_blacklist_word {
    try {
      if (rawData["ads_gateway_blacklist_word"] is String == false) {
        return null;
      }
      return rawData["ads_gateway_blacklist_word"] as String;
    } catch (e) {
      return null;
    }
  }

  bool? get is_ads_gateway {
    try {
      if (rawData["is_ads_gateway"] is bool == false) {
        return null;
      }
      return rawData["is_ads_gateway"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get ads_gateway_is_require_review {
    try {
      if (rawData["ads_gateway_is_require_review"] is bool == false) {
        return null;
      }
      return rawData["ads_gateway_is_require_review"] as bool;
    } catch (e) {
      return null;
    }
  }

  List<String> get ads_gateway_type_content {
    try {
      if (rawData["ads_gateway_type_content"] is List == false) {
        return [];
      }
      return (rawData["ads_gateway_type_content"] as List).cast<String>();
    } catch (e) {
      return [];
    }
  }

  bool? get is_subscribe {
    try {
      if (rawData["is_subscribe"] is bool == false) {
        return null;
      }
      return rawData["is_subscribe"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_start_msg_log {
    try {
      if (rawData["is_start_msg_log"] is bool == false) {
        return null;
      }
      return rawData["is_start_msg_log"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_restrict_log {
    try {
      if (rawData["is_restrict_log"] is bool == false) {
        return null;
      }
      return rawData["is_restrict_log"] as bool;
    } catch (e) {
      return null;
    }
  }

  int? get subscribe_expire_date {
    try {
      if (rawData["subscribe_expire_date"] is int == false) {
        return null;
      }
      return rawData["subscribe_expire_date"] as int;
    } catch (e) {
      return null;
    }
  }

  List<Admins> get admins {
    try {
      if (rawData["admins"] is List == false) {
        return [];
      }
      return (rawData["admins"] as List)
          .map((e) => Admins(e as Map))
          .toList()
          .cast<Admins>();
    } catch (e) {
      return [];
    }
  }

  State get state {
    try {
      if (rawData["state"] is Map == false) {
        return State({});
      }
      return State(rawData["state"] as Map);
    } catch (e) {
      return State({});
    }
  }

  static ChatData create({
    String? special_type,
    int? id,
    String? title,
    String? username,
    String? first_name,
    String? last_name,
    bool? is_bot,
    bool? is_auto_read,
    bool? is_auto_clear,
    bool? is_auto_block,
    bool? is_afk,
    bool? is_ai_chatbot,
    bool? is_ai_task,
    bool? is_blocked,
    bool? is_mute,
    int? ads_gateway_price_day,
    int? ads_gateway_price_pinned,
    int? ads_gateway_price_repeat_msg_day,
    String? ads_gateway_blacklist_word,
    bool? is_ads_gateway,
    bool? ads_gateway_is_require_review,
    List<String>? ads_gateway_type_content,
    bool? is_subscribe,
    bool? is_start_msg_log,
    bool? is_restrict_log,
    int? subscribe_expire_date,
    List<Admins>? admins,
    State? state,
  }) {
    ChatData chatData = ChatData({
      "@type": special_type,
      "id": id,
      "title": title,
      "username": username,
      "first_name": first_name,
      "last_name": last_name,
      "is_bot": is_bot,
      "is_auto_read": is_auto_read,
      "is_auto_clear": is_auto_clear,
      "is_auto_block": is_auto_block,
      "is_afk": is_afk,
      "is_ai_chatbot": is_ai_chatbot,
      "is_ai_task": is_ai_task,
      "is_blocked": is_blocked,
      "is_mute": is_mute,
      "ads_gateway_price_day": ads_gateway_price_day,
      "ads_gateway_price_pinned": ads_gateway_price_pinned,
      "ads_gateway_price_repeat_msg_day": ads_gateway_price_repeat_msg_day,
      "ads_gateway_blacklist_word": ads_gateway_blacklist_word,
      "is_ads_gateway": is_ads_gateway,
      "ads_gateway_is_require_review": ads_gateway_is_require_review,
      "ads_gateway_type_content": ads_gateway_type_content,
      "is_subscribe": is_subscribe,
      "is_start_msg_log": is_start_msg_log,
      "is_restrict_log": is_restrict_log,
      "subscribe_expire_date": subscribe_expire_date,
      "admins": (admins != null)
          ? admins.map((res) => res.toJson()).toList().cast<Map>()
          : null,
      "state": (state != null) ? state.toJson() : null,
    });

    return chatData;
  }
}
