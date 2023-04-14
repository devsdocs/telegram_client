// ignore_for_file: non_constant_identifier_names, empty_catches

import 'dart:convert';

import 'package:telegram_client/isolate/isolate.dart';

/// add state data
class MtprotoClient {
  int client_id;
  Isolate isolate;
  int client_user_id;
  DateTime join_date = DateTime.now();

  MtprotoClient({
    required this.client_id,
    required this.isolate,
    this.client_user_id = 0,
  });

  /// close
  void close() {
    isolate.kill();
  }

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

extension MtprotoClients on List<MtprotoClient> {
  // exit
  MtprotoClient? getClientByUserId(int clientUserId) {
    for (var i = 0; i < length; i++) {
      MtprotoClient tdlibClient = this[i];
      if (tdlibClient.client_user_id == clientUserId) {
        return tdlibClient;
      }
    }
    return null;
  }

  // exit
  MtprotoClient? getClientById(int clientId) {
    for (var i = 0; i < length; i++) {
      MtprotoClient tdlibClient = this[i];
      if (tdlibClient.client_id == clientId) {
        return tdlibClient;
      }
    }
    return null;
  }

  Future<bool> exitClientById(
    int clientId, {
    String? extra,
  }) async {
    MtprotoClient? tdlibClient = getClientById(clientId);
    if (tdlibClient != null) {
      tdlibClient.close();
      remove(tdlibClient);
      return true;
    }
    return false;
  }
}
