// ignore_for_file: non_constant_identifier_names, empty_catches, unnecessary_type_check, void_checks, unnecessary_brace_in_string_interps

// ignore: slash_for_doc_comments
/**
Licensed under the MIT License <http://opensource.org/licenses/MIT>.
SPDX-License-Identifier: MIT
Copyright (c) 2021 Azkadev Telegram Client <http://github.com/azkadev/telegram_client>.
Permission is hereby  granted, free of charge, to any  person obtaining a copy
of this software and associated  documentation files (the "Software"), to deal
in the Software  without restriction, including without  limitation the rights
to  use, copy,  modify, merge,  publish, distribute,  sublicense, and/or  sell
copies  of  the Software,  and  to  permit persons  to  whom  the Software  is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE  IS PROVIDED "AS  IS", WITHOUT WARRANTY  OF ANY KIND,  EXPRESS OR
IMPLIED,  INCLUDING BUT  NOT  LIMITED TO  THE  WARRANTIES OF  MERCHANTABILITY,
FITNESS FOR  A PARTICULAR PURPOSE AND  NONINFRINGEMENT. IN NO EVENT  SHALL THE
AUTHORS  OR COPYRIGHT  HOLDERS  BE  LIABLE FOR  ANY  CLAIM,  DAMAGES OR  OTHER
LIABILITY, WHETHER IN AN ACTION OF  CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE  OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. 
**/

import 'dart:ffi' as ffi;
// import 'dart:ffi';
import 'dart:convert' as convert;

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_client/isolate/isolate.dart';
import 'package:telegram_client/scheme/scheme.dart';
import 'package:telegram_client/tdlib/tdlib_isolate_data.dart';
import 'package:telegram_client/tdlib/tdlib_isolate_receive_data.dart';
import 'package:universal_io/io.dart';
import 'package:ffi/ffi.dart' as pkgffi;

/// Cheatset
///
/// ```dart
/// Tdlib tg = Tdlib("libtdjson.so", {
///   "api_id": 121315,
///   "api_hash": "saskaspasad"
/// });
/// tg.on("update", (UpdateTd update) async {
///   print(update.raw);
/// });
/// tg.initIsolate();
/// ````
///
class LibTdJson {
  ReceivePort receivePort = ReceivePort();
  late Map client_option = {
    'api_id': 0,
    'api_hash': '',
    'database_directory': "",
    'files_directory': "",
    "use_file_database": true,
    "use_chat_info_database": true,
    "use_message_database": true,
    "use_secret_chats": true,
    'enable_storage_optimizer': true,
    'system_language_code': 'en',
    'new_verbosity_level': 0,
    'application_version': 'v1',
    'device_model': 'Telegram Client HexaMinate @azkadev Galaxeus',
    'system_version': Platform.operatingSystemVersion,
    "database_key": "",
    "start": true,
  };
  late final String path_tdlib;
  bool is_cli;
  bool is_android = Platform.isAndroid;
  List<TdlibClient> clients = [];
  int client_id = 0;
  String event_invoke = "invoke";
  String event_update = "update";
  EventEmitter event_emitter = EventEmitter();
  Duration delay_update = Duration(milliseconds: 1);
  Duration delay_invoke = Duration(milliseconds: 1);
  late double timeOutUpdate;
  LibTdJson({
    String? pathTdl,
    Map? clientOption,
    this.is_cli = false,
    this.event_invoke = "invoke",
    this.event_update = "update",
    EventEmitter? eventEmitter,
    Duration? delayUpdate,
    this.timeOutUpdate = 1.0,
    Duration? delayInvoke,
  }) {
    pathTdl ??= "libtdjson.${getFormatLibrary}";
    path_tdlib = pathTdl;
    if (eventEmitter != null) {
      event_emitter = eventEmitter;
    }

    if (clientOption != null) {
      client_option.addAll(clientOption);
      if (clientOption["is_android"] == true) {
        is_android = true;
      }
    }

    receivePort.listen((update) {
      if (update is TdlibIsolateReceiveData) {
        TdlibIsolateReceiveData tdlibIsolateReceiveData = update;
        try {
          if (tdlibIsolateReceiveData.updateData["@extra"] is String) {
            event_emitter.emit(event_invoke, null, tdlibIsolateReceiveData);
          } else {
            event_emitter.emit(event_update, null, tdlibIsolateReceiveData);
          }
        } catch (e) {
          event_emitter.emit(event_update, null, tdlibIsolateReceiveData);
        }
      }
      if (update is TdlibIsolateReceiveDataError) {
        TdlibIsolateReceiveDataError tdlibIsolateReceiveDataError = update;

        try {
          TdlibClient? tdlibClient =
              clients.getClientById(tdlibIsolateReceiveDataError.clientId);
          if (tdlibClient != null) {
            tdlibClient.close();
          }
        } catch (e) {}
      }
    });
  }

  String get getFormatLibrary {
    if (Platform.isAndroid || Platform.isLinux) {
      return "so";
    } else if (Platform.isIOS || Platform.isMacOS) {
      return "dylib";
    } else {
      return "dll";
    }
  }

  Future<void> init() async {
    return;
  }

  ffi.DynamicLibrary get tdLib {
    if (Platform.isIOS || Platform.isMacOS) {
      if (is_cli) {
        return ffi.DynamicLibrary.open(path_tdlib);
      } else {
        return ffi.DynamicLibrary.process();
      }
    } else {
      return ffi.DynamicLibrary.open(path_tdlib);
    }
  }

  /// create client id for multi client
  int client_create() {
    // pkgffi;
    return tdLib
        .lookupFunction<ffi.Pointer Function(), ffi.Pointer Function()>(
            '${is_android ? "_" : ""}td_json_client_create')
        .call()
        .address;
  }

  ffi.Pointer client_id_addres(int clientId) {
    return ffi.Pointer.fromAddress(clientId);
  }

  /// client_send
  void client_send(int clientId, [Map? parameters]) {
    ffi.Pointer client_id_addres_data = client_id_addres(clientId);
    ffi.Pointer<pkgffi.Utf8> request_data =
        convert.json.encode(parameters).toNativeUtf8();
    tdLib
        .lookupFunction<
                ffi.Void Function(
                    ffi.Pointer client, ffi.Pointer<pkgffi.Utf8> request),
                void Function(
                    ffi.Pointer client, ffi.Pointer<pkgffi.Utf8> request)>(
            '${is_android ? "_" : ""}td_json_client_send')
        .call(client_id_addres_data, request_data);
    pkgffi.malloc.free(request_data);
    return;
  }

  /// client_execute
  Map<String, dynamic> client_execute(int clientId, [Map? parameters]) {
    ffi.Pointer client_id_addres_data = client_id_addres(clientId);
    ffi.Pointer<pkgffi.Utf8> request_data =
        convert.json.encode(parameters).toNativeUtf8();
    ffi.Pointer<pkgffi.Utf8> result = tdLib
        .lookupFunction<
                ffi.Pointer<pkgffi.Utf8> Function(
                    ffi.Pointer, ffi.Pointer<pkgffi.Utf8>),
                ffi.Pointer<pkgffi.Utf8> Function(
                    ffi.Pointer, ffi.Pointer<pkgffi.Utf8>)>(
            '${is_android ? "_" : ""}td_json_client_execute')
        .call(client_id_addres_data, request_data);
    Map<String, dynamic> result_data =
        convert.json.decode(result.toDartString());
    pkgffi.malloc.free(request_data);

    return result_data;
  }

  /// client_destroy
  void client_destroy(int clientId) {
    ffi.Pointer client_id_addres_data = client_id_addres(clientId);
    tdLib
        .lookupFunction<
            ffi.Void Function(ffi.Pointer),
            void Function(
                ffi.Pointer)>('${is_android ? "_" : ""}td_json_client_destroy')
        .call(client_id_addres_data);

    return;
  }

  /// fetch update
  Map<String, dynamic>? client_receive(int clientId, [double timeout = 1.0]) {
    try {
      ffi.Pointer client_id_addres_data = client_id_addres(clientId);
      ffi.Pointer<pkgffi.Utf8> update = tdLib
          .lookupFunction<
              ffi.Pointer<pkgffi.Utf8> Function(ffi.Pointer, ffi.Double),
              ffi.Pointer<pkgffi.Utf8> Function(ffi.Pointer,
                  double)>('${is_android ? "_" : ""}td_json_client_receive')
          .call(client_id_addres_data, timeout);
      if (update.address != 0 &&
          update.toDartString() is String &&
          update.toDartString().toString().isNotEmpty) {
        Map<String, dynamic>? updateOrigin;
        try {
          updateOrigin = convert.json.decode(update.toDartString());
        } catch (e) {}
        if (updateOrigin != null) {
          return updateOrigin;
        }
      } else {}
    } catch (e) {}
    return null;
  }

  /// add this for multithread on flutter apps
  Future<void> initIsolate({
    int? clientId,
    int clientUserId = 0,
    Map? clientOption,
  }) async {
    clientId ??= client_id;
    Map client_new_option = client_option.clone();
    if (clientOption != null) {
      client_new_option.addAll(clientOption);
    }
    TdlibIsolateData tdlibIsolateData = TdlibIsolateData(
      sendPort: receivePort.sendPort,
      clientOption: client_new_option,
      clientId: clientId,
      pathTdlib: path_tdlib,
      isAndroid: is_android,
      delayUpdate: delay_update,
      timeOutUpdate: timeOutUpdate,
    );
    Isolate isolate = await Isolate.spawn<TdlibIsolateData>(
      (TdlibIsolateData tdlibIsolateData) async {
        try {
          LibTdJson tg = LibTdJson(
            pathTdl: tdlibIsolateData.pathTdlib,
            clientOption: tdlibIsolateData.clientOption,
          );
          while (true) {
            await Future.delayed(tdlibIsolateData.delayUpdate);
            Map? new_update = tg.client_receive(
                tdlibIsolateData.clientId, tdlibIsolateData.timeOutUpdate);
            if (new_update != null) {
              tdlibIsolateData.sendPort.send(
                TdlibIsolateReceiveData(
                  updateData: new_update,
                  clientId: tdlibIsolateData.clientId,
                  clientOption: tdlibIsolateData.clientOption,
                ),
              );
            }
          }
        } catch (e) {
          tdlibIsolateData.sendPort.send(
            TdlibIsolateReceiveDataError(
              clientId: tdlibIsolateData.clientId,
              clientOption: tdlibIsolateData.clientOption,
            ),
          );
        }
      },
      tdlibIsolateData,
      onExit: receivePort.sendPort,
      onError: receivePort.sendPort,
    );
    clients.add(TdlibClient(
      client_id: clientId,
      isolate: isolate,
      client_user_id: clientUserId,
    ));
  }

  /// add this for multithread new client on flutter apps
  Future<void> initIsolateNewClient({
    required int clientId,
    required Map clientOption,
    int clientUserId = 0,
  }) async {
    await initIsolate(
      clientId: clientId,
      clientOption: {
        ...client_option,
        ...clientOption,
      },
      clientUserId: clientUserId,
    );
  }
}
