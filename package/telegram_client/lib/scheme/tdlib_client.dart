// ignore_for_file: non_constant_identifier_names, empty_catches

import 'dart:convert';

// import 'package:telegram_client/isolate/isolate.dart';

/// add state data
class TdlibClient {
  int client_id;
  int client_user_id;
  Map client_option;
  DateTime join_date = DateTime.now();

  TdlibClient({
    required this.client_id,
    required this.client_option,
    this.client_user_id = 0,
  });

  Map toJson() {
    return {
      "client_id": client_id,
      "client_user_id": client_user_id,
      "join_date": join_date.toString(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

/// add state data
class TdlibClientExit {
  int client_id;

  TdlibClientExit({
    required this.client_id,
  });
}
