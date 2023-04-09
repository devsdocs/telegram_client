// ignore_for_file: non_constant_identifier_names, empty_catches, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:supabase_client/supabase_client.dart' as supabase_client;
import "package:isar/isar.dart" as isar;

import "package:telegram_bot_api_template/database/scheme/scheme.dart"
    as isar_scheme;
import "package:path/path.dart" as p;
import "package:telegram_bot_api_template/extension/extension.dart";

import "package:telegram_bot_api_template/scheme/scheme.dart" as tg_scheme;

class DefaultDataBase {
  static Map initData({
    bool isUser = false,
  }) {
    Map jsonData = {
      "state": {},
      "language_code": "id",
    };
    if (!isUser) {
      jsonData.updateVoid(
        data: {
          "language_code": "",
          "state": {},
        },
      );
    }
    return jsonData;
  }
}

enum DatabaseType {
  supabase,
  isar,
}

enum DatabaseDataType { bot, userbot }

class DatabaseLib {
  final DatabaseType databaseType;
  final supabase_client.Database supabase_db;
  final isar.Isar isar_db;
  final isar.Isar isar_db_chat;
  final isar.Isar isar_db_user;
  DatabaseLib({
    required this.databaseType,
    required this.supabase_db,
    required this.isar_db,
    required this.isar_db_chat,
    required this.isar_db_user,
  });
}

class DatabaseTg {
  DatabaseLib database_lib;
  Directory directory;
  DatabaseTg({
    required this.database_lib,
    required this.directory,
  });

  Directory getDirectory({
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
  }) {
    Directory dir = Directory(p.join(directory.path, databaseDataType.name));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  String getAccountId({
    required int bot_user_id,
    required int chat_id,
    // required bool isUser,
    required String chat_type,
  }) {
    if (chat_type == "private") {
      if (chat_id == bot_user_id) {
        return "${bot_user_id}-${bot_user_id}";
      }

      return "${bot_user_id}-${chat_id}";
    }
    return "${bot_user_id}-${chat_id}";
  }

  String getFromTypeSupabase({
    required int bot_user_id,
    required int chat_id,
    // required bool isUser,
    required String chat_type,
  }) {
    if (chat_type == "private") {
      if (chat_id == bot_user_id) {
        return "telegram_chat";
      }

      return "telegram_user";
    }
    return "telegram_chat";
  }

  isar.Isar isar_db({
    required tg_scheme.TgClientData tgClientData,
    required int chat_id,
    required String chat_type,
    DatabaseLib? databaseLib,
  }) {
    databaseLib ??= database_lib;
    if (chat_type == "private") {
      if (chat_id == tgClientData.client_user_id) {
        return databaseLib.isar_db_chat;
      }
      return databaseLib.isar_db_user;
    }
    return databaseLib.isar_db_chat;
  }

  Future<Map?> getData({
    required tg_scheme.TgClientData tgClientData,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    bool isSaveNotFound = true,
    Map? value,
    String from = "telegram",
    List<String>? filters,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;

    value ??= {};
    value.removeNullVoid();
    if (databaseLib.databaseType == DatabaseType.supabase) {
      Map? get_data = await databaseLib.supabase_db.getMatch(
          from: from,
          query: {
            "client_user_id": tgClientData.client_user_id,
          },
          columns: filters);
      if (get_data == null) {
        Map new_data = {};
        new_data.updateVoid(data: value);
        await databaseLib.supabase_db.add(
          from: from,
          data: {
            ...tgClientData.toJson(),
            ...new_data,
          },
        );
        return null;
      }
      return get_data;
    }
    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.TgClientData? get_data_procces = await databaseLib
          .isar_db.tgClientDatas
          .get(tgClientData.client_user_id!);
      if (get_data_procces == null) {
        isar_scheme.TgClientData tg_client_data_isar =
            isar_scheme.TgClientData();

        tg_client_data_isar.client_user_id = tgClientData.client_user_id!;

        await databaseLib.isar_db.writeTxn(() async {
          await databaseLib!.isar_db.tgClientDatas.put(tg_client_data_isar);
        });
        get_data_procces = tg_client_data_isar;
      }

      Map jsonData = {
        "client_user_id": get_data_procces.client_user_id,
        "client_token": get_data_procces.client_token,
        "client_username": get_data_procces.client_username,
        "owner_user_id": get_data_procces.owner_user_id,
        "from_bot_type": get_data_procces.from_bot_type,
        "from_bot_user_id": get_data_procces.from_bot_user_id,
        "expire_date": get_data_procces.expire_date,
      };
      jsonData.updateVoid(data: value);
      return jsonData;
    }

    return null;
  }

  void updateTgClientDataVoid({
    required isar_scheme.TgClientData tgClientDataIsar,
    required Map newValue,
  }) {
    // if (newValue)
  }

  Future<bool> saveData({
    required tg_scheme.TgClientData tgClientData,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    required Map newValue,
    String from = "telegram",
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    newValue.removeNullVoid();
    if (databaseLib.databaseType == DatabaseType.supabase) {
      await databaseLib.supabase_db.update(
        from: from,
        dataOrigin: {
          "id": tgClientData.client_user_id,
        },
        dataUpdate: newValue,
      );
      return true;
    }
    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.TgClientData? get_data_procces = await databaseLib
          .isar_db.tgClientDatas
          .get(tgClientData.client_user_id!);
      if (get_data_procces == null) {
        isar_scheme.TgClientData tg_client_data_isar =
            isar_scheme.TgClientData();
        tg_client_data_isar.client_user_id = tgClientData.client_user_id!;

        await databaseLib.isar_db.writeTxn(() async {
          await databaseLib!.isar_db.tgClientDatas.put(tg_client_data_isar);
        });
        return true;
      }
      await databaseLib.isar_db.writeTxn(() async {
        await databaseLib!.isar_db.tgClientDatas.put(get_data_procces);
      });
      return true;
    }
    return false;
  }

  Future<List<Map>> getAlls({
    String from = "telegram",
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.supabase) {
      List<Map> es = await databaseLib.supabase_db.getAll(from: from);
      return es;
    }

    return [];
  }

  Future<Map?> getClient({
    required tg_scheme.TgClientData tgClientData,
    bool isSaveNotFound = true,
    bool isWithoutFetch = false,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.supabase) {
      Map? es = await databaseLib.supabase_db.getMatch(
        from: "telegram",
        query: {
          "client_user_id": tgClientData.client_user_id,
        },
      );
      if (es == null) {
        await databaseLib.supabase_db.add(
          from: "telegram",
          data: tgClientData.toJson(),
        );
        return tgClientData.toJson();
      }
      return es;
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.TgClientData? tg_client_data_procces = await databaseLib
          .isar_db.tgClientDatas
          .filter()
          .client_user_idEqualTo(tgClientData.client_user_id!)
          .findFirst();
      if (tg_client_data_procces == null) {
        isar_scheme.TgClientData tg_client_data_new_procces =
            isar_scheme.TgClientData();
        tgClientData.toJson().forEach((key, value) {
          try {
            if (value == null) {
              return;
            }
            tg_client_data_new_procces[key] = value;
          } catch (e) {}
        });
        await databaseLib.isar_db.writeTxn(() async {
          await databaseLib!.isar_db.tgClientDatas
              .put(tg_client_data_new_procces);
        });
        return tg_client_data_new_procces.toJson();
      }
      return tg_client_data_procces.toJson();
    }
    return null;
  }

  Future<Map?> getClientByClientId({
    required tg_scheme.TgClientData tgClientData,
    bool isSaveNotFound = true,
    bool isWithoutFetch = false,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.supabase) {
      Map? es = await databaseLib.supabase_db.getMatch(
        from: "telegram",
        query: {
          "client_user_id": tgClientData.client_user_id,
        },
      );
      if (es == null) {
        await databaseLib.supabase_db.add(
          from: "telegram",
          data: tgClientData.toJson(),
        );
        return tgClientData.toJson();
      }
      return es;
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.TgClientData? tg_client_data_procces = await databaseLib
          .isar_db.tgClientDatas
          .filter()
          .client_idEqualTo(tgClientData["client_id"]!)
          .findFirst();
      if (tg_client_data_procces == null) {
        isar_scheme.TgClientData tg_client_data_new_procces =
            isar_scheme.TgClientData();
        tgClientData.toJson().forEach((key, value) {
          try {
            if (value == null) {
              return;
            }
            tg_client_data_new_procces[key] = value;
          } catch (e) {}
        });
        await databaseLib.isar_db.writeTxn(() async {
          await databaseLib!.isar_db.tgClientDatas
              .put(tg_client_data_new_procces);
        });
        return tg_client_data_new_procces.toJson();
      }
      return tg_client_data_procces.toJson();
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getClients({
    bool isSaveNotFound = true,
    bool isWithoutFetch = false,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.isar) {
      return await databaseLib.isar_db.tgClientDatas
          .filter()
          .client_user_idGreaterThan(0)
          .build()
          .exportJson();
    }
    return [];
  }

  Future<bool> deleteClient({
    required tg_scheme.TgClientData tgClientData,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.supabase) {
      await databaseLib.supabase_db.delete(
        from: "telegram",
        datas: {
          "client_user_id": tgClientData.client_user_id,
        },
      );
      return true;
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      return await databaseLib.isar_db.tgClientDatas
          .filter()
          .client_user_idEqualTo(tgClientData.client_user_id!)
          .deleteFirst();
    }
    return false;
  }

  Future<bool> deleteClientByClientId({
    required tg_scheme.TgClientData tgClientData,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.supabase) {
      await databaseLib.supabase_db.delete(
        from: "telegram",
        datas: {
          "client_user_id": tgClientData.client_user_id,
        },
      );
      return true;
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.TgClientData? tg_client_data_procces = await databaseLib
          .isar_db.tgClientDatas
          .filter()
          .client_idEqualTo(tgClientData["client_id"]!)
          .findFirst();
      if (tg_client_data_procces == null) {
        return true;
      }
      await databaseLib.isar_db.writeTxn(() async {
        await databaseLib!.isar_db.tgClientDatas
            .delete(tg_client_data_procces.id);
      });
      return true;
    }
    return false;
  }

  Future<bool> saveClient({
    required tg_scheme.TgClientData tgClientData,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.supabase) {
      await databaseLib.supabase_db.update(
        from: "telegram",
        dataOrigin: {
          "client_user_id": tgClientData.client_user_id,
        },
        dataUpdate: tgClientData.toJson(),
      );
      return true;
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.TgClientData? tg_client_data_procces = await databaseLib
          .isar_db.tgClientDatas
          .filter()
          .client_user_idEqualTo(tgClientData.client_user_id!)
          .findFirst();
      if (tg_client_data_procces == null) {
        isar_scheme.TgClientData tg_client_data_new_procces =
            isar_scheme.TgClientData();
        tgClientData.toJson().forEach((key, value) {
          try {
            if (value == null) {
              return;
            }
            tg_client_data_new_procces[key] = value;
          } catch (e) {}
        });
        await databaseLib.isar_db.writeTxn(() async {
          await databaseLib!.isar_db.tgClientDatas
              .put(tg_client_data_new_procces);
        });
        return true;
      }
      tgClientData.toJson().forEach((key, value) {
        try {
          if (value == null) {
            return;
          }
          tg_client_data_procces[key] = value;
        } catch (e) {}
      });
      await databaseLib.isar_db.writeTxn(() async {
        await databaseLib!.isar_db.tgClientDatas.put(tg_client_data_procces);
      });
      return true;
    }
    return false;
  }

  List<int> encryptData({
    required Map data,
    DatabaseLib? databaseLib,
    tg_scheme.TgClientData? tgClientData,
  }) {
    databaseLib ??= database_lib;
    try {
      return gzip.encode(utf8.encode(json.encode(data)));
    } catch (e, stack) {
      print("encrypt: ${e}, ${stack}");
      print(tgClientData);
      rethrow;
    }
  }

  Map decyprtData({
    required List<int> data,
    DatabaseLib? databaseLib,
    tg_scheme.TgClientData? tgClientData,
  }) {
    databaseLib ??= database_lib;
    try {
      return (json.decode(utf8.decode(gzip.decode(data))) as Map);
    } catch (e, stack) {
      print("decrypt: ${e}, ${stack}");
      print(tgClientData);
      rethrow;
    }
  }

  Future<tg_scheme.ChatData> getChat({
    required String chat_type,
    required int chat_id,
    required tg_scheme.TgClientData tgClientData,
    bool isSaveNotFound = true,
    bool isWithoutFetch = false,
    Map? value,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
    required Future<tg_scheme.ChatData> Function() onNotFoundData,
  }) async {
    databaseLib ??= database_lib;
    value ??= {};
    if (isWithoutFetch) {
      return tg_scheme.ChatData(value);
    }
    String account_id_procces = getAccountId(
      bot_user_id: tgClientData.client_user_id!,
      chat_id: chat_id,
      chat_type: chat_type,
    );
    if (databaseLib.databaseType == DatabaseType.supabase) {
      Map? es = await databaseLib.supabase_db.getMatch(
        from: getFromTypeSupabase(
          bot_user_id: tgClientData.client_user_id!,
          chat_id: chat_id,
          chat_type: chat_type,
        ),
        query: {
          "account_id": (account_id_procces),
        },
      );
      if (es == null) {
        Map jsonData = {
          "account_id": (account_id_procces),
          "data": value,
        };
        await databaseLib.supabase_db.add(
          from: getFromTypeSupabase(
            bot_user_id: tgClientData.client_user_id!,
            chat_id: chat_id,
            chat_type: chat_type,
          ),
          data: jsonData,
        );
        return jsonData["data"];
      }
      return tg_scheme.ChatData(es["data"] as Map);
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.ChatData? chat_data_procces = await isar_db(
        tgClientData: tgClientData,
        chat_id: chat_id,
        chat_type: chat_type,
      )
          .chatDatas
          .filter()
          .chat_idEqualTo(chat_id)
          .client_user_idEqualTo(tgClientData.client_user_id!)
          .findFirst();

      if (chat_data_procces == null) {
        return await onNotFoundData.call();
      }
      try {
        return tg_scheme.ChatData(decyprtData(
          data: chat_data_procces.data,
          databaseLib: databaseLib,
          tgClientData: tgClientData,
        ));
        // return (json.decode(chat_data_procces.data) as Map);
      } catch (e) {
        return tg_scheme.ChatData(value);
      }
    }

    return await onNotFoundData.call();
  }

  Future<int> getChatsCount({
    required tg_scheme.TgClientData tgClientData,
    required String chat_type,
    required int chat_id,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    int chat_data_count = await isar_db(
      tgClientData: tgClientData,
      chat_id: chat_id,
      chat_type: chat_type,
      databaseLib: databaseLib,
    )
        .chatDatas
        .filter()
        .client_user_idEqualTo(tgClientData.client_user_id!)
        .count();
    return chat_data_count;
  }

  Future<bool> saveChat({
    required String chat_type,
    required int chat_id,
    required Map newData,
    required tg_scheme.TgClientData tgClientData,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    String account_id_procces = getAccountId(
      bot_user_id: tgClientData.client_user_id!,
      chat_id: chat_id,
      chat_type: chat_type,
    );

    if (databaseLib.databaseType == DatabaseType.supabase) {
      await databaseLib.supabase_db.update(
        from: getFromTypeSupabase(
          bot_user_id: tgClientData.client_user_id!,
          chat_id: chat_id,
          chat_type: chat_type,
        ),
        dataOrigin: {
          "account_id": account_id_procces,
        },
        dataUpdate: {"data": newData},
      );
      return true;
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.ChatData? chat_data_procces = await isar_db(
        tgClientData: tgClientData,
        chat_id: chat_id,
        chat_type: chat_type,
      )
          .chatDatas
          .filter()
          .chat_idEqualTo(chat_id)
          .client_user_idEqualTo(tgClientData.client_user_id!)
          .findFirst();
      if (chat_data_procces == null) {
        isar_scheme.ChatData chat_data_new_procces = isar_scheme.ChatData();
        chat_data_new_procces.chat_id = chat_id;
        chat_data_new_procces.client_user_id = tgClientData.client_user_id!;
        // chat_data_new_procces.data = json.encode(newData);
        chat_data_new_procces.data = encryptData(
          data: newData,
          databaseLib: databaseLib,
          tgClientData: tgClientData,
        );
        await isar_db(
          tgClientData: tgClientData,
          chat_id: chat_id,
          chat_type: chat_type,
        ).writeTxn(() async {
          await isar_db(
            tgClientData: tgClientData,
            chat_id: chat_id,
            chat_type: chat_type,
          ).chatDatas.put(chat_data_new_procces);
        });
        return true;
      }
      chat_data_procces.data = encryptData(
        data: newData,
        databaseLib: databaseLib,
        tgClientData: tgClientData,
      );
      await isar_db(
        tgClientData: tgClientData,
        chat_id: chat_id,
        chat_type: chat_type,
      ).writeTxn(() async {
        await isar_db(
          tgClientData: tgClientData,
          chat_id: chat_id,
          chat_type: chat_type,
        ).chatDatas.put(chat_data_procces);
      });
      return true;
    }
    return false;
  }

  Future<List<Map>> getChats({
    required String chat_type,
    required Map defaultValue,
    required tg_scheme.TgClientData tgClientData,
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    String from = "telegram",
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.supabase) {
      Map? es = await databaseLib.supabase_db.getMatch(
        from: from,
        query: {
          "client_user_id": tgClientData.client_user_id,
        },
        columns: [chat_type],
      );
      if (es == null) {
        await databaseLib.supabase_db.add(from: from, data: {
          ...tgClientData.toJson(),
          chat_type: [defaultValue]
        });
        return [defaultValue];
      }
      if (es.containsKey(chat_type)) {
        return (es[chat_type] as List).cast<Map>();
      } else {
        return [defaultValue];
      }
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.TgClientData? get_data_procces = await databaseLib
          .isar_db.tgClientDatas
          .get(tgClientData.client_user_id!);
      if (get_data_procces == null) {
        isar_scheme.TgClientData tg_client_data_isar =
            isar_scheme.TgClientData();
        tg_client_data_isar.client_user_id = tgClientData.client_user_id!;

        await databaseLib.isar_db.writeTxn(() async {
          await databaseLib!.isar_db.tgClientDatas.put(tg_client_data_isar);
        });
        return [defaultValue];
      }
    }

    return [].cast<Map>();
  }

  Future<bool> saveChats({
    required String chat_type,
    required List<Map> value,
    required tg_scheme.TgClientData tgClientData,
    String from = "telegram",
    DatabaseDataType databaseDataType = DatabaseDataType.bot,
    DatabaseLib? databaseLib,
  }) async {
    databaseLib ??= database_lib;
    if (databaseLib.databaseType == DatabaseType.supabase) {
      late Map dataUpdate = {};
      dataUpdate[chat_type] = value;
      dataUpdate.updateVoid(data: tgClientData.toJson());
      await databaseLib.supabase_db.update(
        from: from,
        dataOrigin: {
          "client_user_id": tgClientData.client_user_id,
        },
        dataUpdate: dataUpdate,
      );
      return true;
    }

    if (databaseLib.databaseType == DatabaseType.isar) {
      isar_scheme.TgClientData? get_data_procces = await databaseLib
          .isar_db.tgClientDatas
          .get(tgClientData.client_user_id!);
      if (get_data_procces == null) {
        isar_scheme.TgClientData tg_client_data_isar =
            isar_scheme.TgClientData();
        tg_client_data_isar.client_user_id = tgClientData.client_user_id!;

        await databaseLib.isar_db.writeTxn(() async {
          await databaseLib!.isar_db.tgClientDatas.put(tg_client_data_isar);
        });
        return true;
      }

      await databaseLib.isar_db.writeTxn(() async {
        await databaseLib!.isar_db.tgClientDatas.put(get_data_procces);
      });
      return true;
    }

    return false;
  }
}
