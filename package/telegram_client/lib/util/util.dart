// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:convert';

/// telegram util
class TgUtils {
  /// telegram utils
  TgUtils();

  /// getMessage real like bot api
  num getMessageId(dynamic message_id, [bool is_reverse = false]) {
    if (message_id is num) {
      if (is_reverse) {
        return (message_id ~/ 1048576);
      } else {
        return (message_id * 1048576).toInt();
      }
    }
    return 0;
  }

  num messageTdlibToApi(dynamic message_id) {
    if (message_id is num) {
      return (message_id ~/ 1048576).toInt();
    }
    return 0;
  }

  num messageApiToTdlib(dynamic message_id) {
    if (message_id is num) {
      return (message_id * 1048576).toInt();
    }
    return 0;
  }

  List<int> messagesTdlibToApi(dynamic message_ids) {
    if (message_ids is List<int>) {
      return message_ids
          .map((message_id) => messageTdlibToApi(message_id).toInt())
          .toList()
          .cast<int>();
    }
    return [];
  }

  List<int> messagesApiToTdlib(message_ids) {
    if (message_ids is List<int>) {
      return message_ids
          .map((message_id) => messageApiToTdlib(message_id).toInt())
          .toList()
          .cast<int>();
    }
    return [];
  }

  int toSuperGroupId(dynamic chat_id) {
    if (chat_id is int) {
      if (chat_id.isNegative) {
        return int.parse("${chat_id}".replaceAll(RegExp(r"-100"), ""));
      }
    }
    return 0;
  }

  /// ccreate offset for tl
  static List<String> splitByLength(String text, int length,
      {bool ignoreEmpty = false}) {
    List<String> pieces = [];

    for (int i = 0; i < text.length; i += length) {
      int offset = i + length;
      String piece =
          text.substring(i, offset >= text.length ? text.length : offset);

      if (ignoreEmpty) {
        piece = piece.replaceAll(RegExp(r'\s+'), '');
      }

      pieces.add(piece);
    }
    return pieces;
  }

  /// ccreate offset for tl
  static List<int> createOffset({
    required int totalCount,
    required int limitCount,
  }) {
    late int offset = 0;
    late List<int> listOffset = [0];
    for (var i = 0; i < (totalCount ~/ limitCount).toInt(); i++) {
      for (var ii = 0; ii <= limitCount; ii++) {
        if (ii == limitCount) {
          offset = (offset + limitCount);
        }
      }
      listOffset.add(offset);
    }
    return listOffset;
  }

  static bool getBoolean(dynamic data) {
    if (data == null) {
      return false;
    }
    if (data is String) {
      if (data.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else if (data is Map) {
      if (data.isEmpty) {
        return true;
      } else {
        return false;
      }
    } else if (data is List) {
      if (data.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else if (data is int) {
      if (data < 0) {
        return true;
      } else if (data.isOdd) {
        return true;
      } else {
        return false;
      }
    }
    if (data is bool) {
      return data;
    } else {
      return false;
    }
  }
}

class Buffer {
  static String base64 = "base64";
  static String utf8 = "utf8";
  static Encode from(String data, [String type = "utf8"]) {
    return Encode(data, type);
  }
}

class Encode {
  String text;
  String type;
  Encode(this.text, this.type);

  String toStringEncode(String typeEncode) {
    if (RegExp(r"^utf8$", caseSensitive: false).hasMatch(type)) {
      if (RegExp(r"^base64$", caseSensitive: false).hasMatch(typeEncode)) {
        return base64.encode(utf8.encode(text));
      }
    }
    if (RegExp(r"^base64$", caseSensitive: false).hasMatch(type)) {
      if (RegExp(r"^utf8$", caseSensitive: false).hasMatch(typeEncode)) {
        return utf8.decode(base64.decode(text));
      }
    }
    return text;
  }
}
