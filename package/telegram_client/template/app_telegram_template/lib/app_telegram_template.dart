// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app_telegram_template/page/page.dart';
import 'package:flutter/material.dart';
import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telegram_client/telegram_client.dart';
import 'package:universal_io/io.dart';
import "package:path/path.dart" as path;

import "package:app_telegram_template/database/scheme/scheme.dart"
    as isar_scheme;

class AppTelegramTemplate extends StatefulWidget {
  const AppTelegramTemplate({super.key});

  @override
  State<AppTelegramTemplate> createState() => _AppTelegramTemplateState();
}

class _AppTelegramTemplateState extends State<AppTelegramTemplate> {
  bool is_found = false;
  int count = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) async {
      await task();
    });
  }

  Future<void> task() async {
    Future(() async {
      await Future.delayed(const Duration(seconds: 2));
      Directory get_app_docs_dir = await getApplicationDocumentsDirectory();
      Directory app_tg_dir =
          Directory(path.join(get_app_docs_dir.path, "tg_dir"));
      if (!app_tg_dir.existsSync()) {
        await app_tg_dir.create(recursive: true);
      }
      Isar isar_db_account = await Isar.open(
        [
          isar_scheme.TgClientDataSchema,
        ],
        directory: app_tg_dir.path,
        maxSizeMiB: Isar.defaultMaxSizeMiB * 100,
      );

      // atur dahulu account nya
      int account_counts = await isar_db_account.tgClientDatas.count();
      await isar_db_account.writeTxn(
        () async {
          /// ccreate offset for tl
          List<int> createOffset({
            required int totalCount,
            required int limitCount,
          }) {
            int offset = 0;
            List<int> listOffset = [0];
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

          List<int> count_datas = createOffset(
            totalCount: account_counts,
            limitCount: 10,
          );

          for (var i = 0; i < count_datas.length; i++) {
            List<isar_scheme.TgClientData> tgClientDatas = await isar_db_account
                .tgClientDatas
                .filter()
                .idGreaterThan(0)
                .offset(count_datas[i])
                .limit(10)
                .findAll();

            for (var index = 0; index < tgClientDatas.length; index++) {
              isar_scheme.TgClientData tgClientData = tgClientDatas[index];
              if (tgClientData.client_id == 0) {
                continue;
              }
              tgClientData.client_id = 0;
              await isar_db_account.tgClientDatas.put(tgClientData);
            }
          }
        },
        silent: true,
      );

      Tdlib tdlib = Tdlib(
        clientOption: {
          'api_id': 25556854,
          'api_hash': 'e6c8340cbeaee2d1fad5bd57fa33bbea',
        },
        on_generate_extra_invoke: (client_id, libTdJson) async {
          while (true) {
            await Future.delayed(const Duration(milliseconds: 1));
            try {
              String new_extra_id = generateUuid(15);
              return new_extra_id;
            } catch (e) {}
          }
        },
        on_get_invoke_data: (extra, client_id, libTdJson) async {
          print("Get Data");
          while (true) {
            await Future.delayed(const Duration(milliseconds: 1));
            // isar_db.collection().filter();
            // Map? data = extraData[extra];
            // if (data != null) {
            //   data = data.clone();
            //   print("send: ${data}");
            //   extraData.remove(extra);
            //   return data;
            // }
          }
        },
        on_receive_update: (update, libTdJson) async {
          if (update is TdlibIsolateReceiveData) {
            TdlibIsolateReceiveData tdlibIsolateReceiveData = update;
            try {
              if (tdlibIsolateReceiveData.updateData["@extra"] is String) {
                // extraData[tdlibIsolateReceiveData.updateData["@extra"]] = tdlibIsolateReceiveData.updateData;
              } else {
                libTdJson.event_emitter.emit(
                    libTdJson.event_update, null, tdlibIsolateReceiveData);
              }
            } catch (e) {
              libTdJson.event_emitter
                  .emit(libTdJson.event_update, null, tdlibIsolateReceiveData);
            }
          } else if (update is TdlibIsolateReceiveDataError) {
            TdlibIsolateReceiveDataError tdlibIsolateReceiveDataError = update;
            try {
              TdlibClient? tdlibClient = libTdJson.clients
                  .getClientById(tdlibIsolateReceiveDataError.clientId);
              if (tdlibClient != null) {
                tdlibClient.close();
              }
            } catch (e) {}
          }
        },
      );

      bool is_complete = false;
      tdlib.on(tdlib.event_update, (update) async {
        print(update.raw);

        if (update.raw["@type"] == "updateAuthorizationState") {
          if (update.raw["authorization_state"] is Map) {
            var authStateType = update.raw["authorization_state"]["@type"];

            update.client_option["database_key"] = "";
            await tdlib.initClient(
              update,
              clientId: update.client_id,
              tdlibParameters: update.client_option,
              isVoid: true,
            );

            if (authStateType == "authorizationStateWaitRegistration") {
              if (update.raw["authorization_state"]["terms_of_service"]
                  is Map) {
                Map terms_of_service = update.raw["authorization_state"]
                    ["terms_of_service"] as Map;
                if (terms_of_service["text"] is Map) {
                  await tdlib.invoke(
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

            if (authStateType == "authorizationStateLoggingOut") {
              await tdlib.exitClientById(update.client_id);
            }
            if (authStateType == "authorizationStateClosed") {
              print("close: ${update.client_id}");
              await tdlib.exitClientById(update.client_id);
            }
            if (authStateType == "authorizationStateWaitPhoneNumber") {
              is_complete = true;
            }
            if (authStateType == "authorizationStateWaitCode") {}
            if (authStateType == "authorizationStateWaitPassword") {}
            if (authStateType == "authorizationStateReady") {}
          }
        }
      });

      print(tdlib.client_id);
      await tdlib.initIsolate();
      is_complete = true;
      Timer.periodic(const Duration(microseconds: 1), (timer) async {
        if (is_complete) {
          timer.cancel();
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const SignPage();
              },
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
