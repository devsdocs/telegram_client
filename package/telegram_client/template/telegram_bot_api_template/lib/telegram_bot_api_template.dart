// ignore_for_file: non_constant_identifier_names, unused_local_variable, unnecessary_brace_in_string_interps

import 'package:alfred/alfred.dart';
import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_bot_api_template/telegram_bot_api_template/telegram_bot_api_template.dart';
import 'package:telegram_client/telegram_client.dart';

class UpdateBot {
  Map body;
  Map query;
  String type;
  UpdateBot({
    required this.body,
    required this.query,
    required this.type,
  });
}

class TelegramBotApiTemplate {
  TelegramBotApi tg;
  Alfred server;
  EventEmitter eventEmitter;
  String event_update_bot;
  TelegramBotApiTemplate({
    required this.tg,
    required this.server,
    required this.eventEmitter,
    this.event_update_bot = "tg_bot_api",
  });

  void run() {
    eventEmitter.on(event_update_bot, null, (ev, context) async {
      if (ev.eventData is UpdateBot) {
        try {
          await bot(updateBot: (ev.eventData as UpdateBot));
        } catch (e, stack) {
          print("${e} ${stack}");
        }
      }
    });
    server.post("/telegram/webhook", (HttpRequest req, HttpResponse res) async {
      try {
        Map<String, String> query = req.uri.queryParameters;
        Map<String, dynamic> body = await req.bodyAsJsonMap;
        eventEmitter.emit(
          event_update_bot,
          null,
          UpdateBot(
            body: body,
            query: query,
            type: "webhook",
          ),
        );
        return {
          "status": 200,
          "result": {},
        };
      } catch (e) {
        return {
          "status": 200,
          "result": {},
        };
      }
    });
  }

  Future<Map?> bot({
    required UpdateBot updateBot,
  }) async {
    try {
      Map query = updateBot.query;
      Map update = updateBot.body;

      Map update_message = {};
      if (update["inline_query"] is Map) {
        return await inlineQuery(
          update["inline_query"],
          updateBot: updateBot,
          tg: tg,
        );
      } else if (update["callback_query"] is Map) {
        return await callbackQuery(
          update["callback_query"],
          updateBot: updateBot,
          tg: tg,
        );
      } else if (update["edited_channel_post"] is Map) {
        update_message = update["edited_channel_post"];
      } else if (update["edited_message"] is Map) {
        update_message = update["edited_message"];
      } else if (update["channel_post"] is Map) {
        update_message = update["channel_post"];
      } else if (update["message"] is Map) {
        update_message = update["message"];
      }
      if (update_message.isNotEmpty) {
        return await updateMessage(
          update_message,
          updateBot: updateBot,
          tg: tg,
        );
      }
      return {"@type": "ok"};
    } catch (e, stack) {
      print("${e.toString()}, ${stack.toString()}");
      return {"@type": "error"};
    }
  }
}
