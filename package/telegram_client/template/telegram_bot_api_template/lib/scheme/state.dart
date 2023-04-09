// ignore_for_file: non_constant_identifier_names
import "json_dart.dart";
// import "dart:convert";

import "setup.dart";
import "data.dart";

class State extends JsonDart {
  State(super.rawData);

  static Map get defaultData {
    return {
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

  int? get chat_id {
    try {
      if (rawData["chat_id"] is int == false) {
        return null;
      }
      return rawData["chat_id"] as int;
    } catch (e) {
      return null;
    }
  }

  int? get user_id {
    try {
      if (rawData["user_id"] is int == false) {
        return null;
      }
      return rawData["user_id"] as int;
    } catch (e) {
      return null;
    }
  }

  String? get setting {
    try {
      if (rawData["setting"] is String == false) {
        return null;
      }
      return rawData["setting"] as String;
    } catch (e) {
      return null;
    }
  }

  int? get message_id {
    try {
      if (rawData["message_id"] is int == false) {
        return null;
      }
      return rawData["message_id"] as int;
    } catch (e) {
      return null;
    }
  }

  Setup get setup {
    try {
      if (rawData["setup"] is Map == false) {
        return Setup({});
      }
      return Setup(rawData["setup"] as Map);
    } catch (e) {
      return Setup({});
    }
  }

  String? get message_data {
    try {
      if (rawData["message_data"] is String == false) {
        return null;
      }
      return rawData["message_data"] as String;
    } catch (e) {
      return null;
    }
  }

  bool? get is_without_delete_msg_me {
    try {
      if (rawData["is_without_delete_msg_me"] is bool == false) {
        return null;
      }
      return rawData["is_without_delete_msg_me"] as bool;
    } catch (e) {
      return null;
    }
  }

  bool? get is_delete_msg {
    try {
      if (rawData["is_delete_msg"] is bool == false) {
        return null;
      }
      return rawData["is_delete_msg"] as bool;
    } catch (e) {
      return null;
    }
  }

  String? get step {
    try {
      if (rawData["step"] is String == false) {
        return null;
      }
      return rawData["step"] as String;
    } catch (e) {
      return null;
    }
  }

  String? get version {
    try {
      if (rawData["version"] is String == false) {
        return null;
      }
      return rawData["version"] as String;
    } catch (e) {
      return null;
    }
  }

  Data get data {
    try {
      if (rawData["data"] is Map == false) {
        return Data({});
      }
      return Data(rawData["data"] as Map);
    } catch (e) {
      return Data({});
    }
  }

  static State create({
    String? special_type,
    int? chat_id,
    int? user_id,
    String? setting,
    int? message_id,
    Setup? setup,
    String? message_data,
    bool? is_without_delete_msg_me,
    bool? is_delete_msg,
    String? step,
    String? version,
    Data? data,
  }) {
    State state = State({
      "@type": special_type,
      "chat_id": chat_id,
      "user_id": user_id,
      "setting": setting,
      "message_id": message_id,
      "setup": (setup != null) ? setup.toJson() : null,
      "message_data": message_data,
      "is_without_delete_msg_me": is_without_delete_msg_me,
      "is_delete_msg": is_delete_msg,
      "step": step,
      "version": version,
      "data": (data != null) ? data.toJson() : null,
    });

    return state;
  }
}
