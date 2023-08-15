// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:telegram_client/isolate/isolate.dart';
import 'package:telegram_client/scheme/tdlib_client.dart';
import 'package:telegram_client/tdlib/tdlib.dart';
import 'package:telegram_client/tdlib/tdlib_ffi/tdlib_io.dart';

/// add this for multithread new client on flutter apps
Future<void> tdlibIsolate(TdlibIsolateData tdlibIsolateData) async {
  try {
    LibTdJson tg = LibTdJson(
      pathTdl: tdlibIsolateData.pathTdlib,
      clientOption: tdlibIsolateData.tdlibClient.client_option,
    );
    tg.clients[tdlibIsolateData.tdlibClient.client_id] = tdlibIsolateData.tdlibClient;
    ReceivePort receivePort = ReceivePort();

    List<MapEntry<int, TdlibClient>> clients = tg.clients.entries.toList();

    receivePort.listen((message) {
      bool is_update_tdlib_clients = false;
      if (message is TdlibClient) {
        tg.clients[message.client_id] = message;
        is_update_tdlib_clients = true;
      }
      if (message is TdlibClientExit) {
        tg.clients.remove(message.client_id);
        is_update_tdlib_clients = true;
      }
      if (is_update_tdlib_clients) {
        clients = tg.clients.entries.toList();
      }
    });

    tdlibIsolateData.sendPort.send(receivePort.sendPort);
    Duration duration = tdlibIsolateData.delayUpdate ?? Duration(microseconds: 1);
    while (true) {
      await Future.delayed(duration);
      for (var i = 0; i < clients.length; i++) {
        TdlibClient tdlibClient = clients[i].value;
        await Future.delayed(duration);
        try {
          Map? new_update = tg.client_receive(tdlibClient.client_id, 0.0);
          if (new_update != null) {
            tdlibIsolateData.sendPort.send(
              TdlibIsolateReceiveData(
                updateData: new_update,
                clientId: tdlibClient.client_id,
                clientOption: tdlibClient.client_option,
              ),
            );
          }
        } catch (e) {}
      }
      // print("send");
    }
  } catch (e) {
    tdlibIsolateData.sendPort.send(
      TdlibIsolateReceiveDataError(
        clientId: tdlibIsolateData.tdlibClient.client_id,
        clientOption: tdlibIsolateData.tdlibClient.client_option,
      ),
    );
  }
}
