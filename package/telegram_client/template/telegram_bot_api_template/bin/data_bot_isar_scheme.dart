// import 'package:database_dart/database_dart.dart';
// import 'package:test/test.dart';

// void main() {
//   test('calculate', () {
//     expect(calculate(), 42);
//   });
// }

// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:io';

import 'package:galaxeus_lib/galaxeus_lib.dart';

import "package:path/path.dart" as path;

void main() async {
  List<Map<String, dynamic>> datas = [
    {
      "@type": "TgClientData",
      "id": 0,
      "created_at": "2022-12-26T05:26:40.500935+00:00",
      // "group": [],
      // "private": [],
      "client_user_id": 0,
      "client_id": 0,
      "client_token": "",
      "owner_user_id": 0,
      "client_type": "",
      "from_bot_type": "",
      "can_join_groups": false,
      "can_read_all_group_messages": false,
      "from_bot_user_id": 0,
      "expire_date": 0,
      "client_username": "",
      "client_data": "{}"
      // "channel": [],
    },
    {
      "@type": "ChatData",
      "client_user_id": 0,
      "chat_id": 0,
      "data": [0],
    },
  ];

  // List array = [];
  for (var i = 0; i < datas.length; i++) {
    Map<String, dynamic> data = datas[i];
    if (!data.containsKey("@type")) {
      continue;
    }
    String type_name = data["@type"] as String;
    if (type_name.isEmpty) {
      continue;
    }
    data.remove("@type");
    JsonDataScript res = jsonToIsar(
      data,
      isUseClassName: true,
      className: type_name,
      // isStatic: false,
    );
    await res.saveToFile(Directory(
        path.join(Directory.current.path, "lib", "database", "scheme")));
  }
}

// bool isUpperCase(String data) {
//   return RegExp(
//     r"[A-Z]",
//   ).hasMatch(data);
// }

// int nextInt(int index, int total) {
//   if ((index + 1) >= total) {
//     return index;
//   } else {
//     return index + 1;
//   }
// }
