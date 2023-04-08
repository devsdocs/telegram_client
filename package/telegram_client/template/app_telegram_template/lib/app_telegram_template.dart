// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app_telegram_template/page/page.dart';
import 'package:flutter/material.dart';
import 'package:telegram_client/telegram_client.dart';

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
      Tdlib tdlib = Tdlib(
        clientOption: {
          'api_id': 25556854,
          'api_hash': 'e6c8340cbeaee2d1fad5bd57fa33bbea',
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
      Timer.periodic(Duration(microseconds: 1), (timer) async {
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
