// ignore_for_file: non_constant_identifier_names, empty_catches, unnecessary_type_check, void_checks, unnecessary_brace_in_string_interps, prefer_final_fields, subtype_of_sealed_class

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

import 'dart:convert';
import 'package:galaxeus_lib/event_emitter/event_emitter.dart';
import 'package:telegram_client/isolate/isolate.dart';
import 'package:telegram_client/scheme/scheme.dart';
import 'package:telegram_client/tdlib/tdlib.dart';
import 'package:universal_io/io.dart';
import 'package:web_ffi/web_ffi.dart';
import 'package:web_ffi/web_ffi.dart' as ffi;
import 'package:web_ffi/web_ffi_modules.dart';
// and additionally

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
  bool is_cli;
  late final String path_tdlib;
  bool is_android = Platform.isAndroid;
  List<TdlibClient> clients = [];
  int client_id = 0;
  String event_invoke = "invoke";
  String event_update = "update";
  EventEmitter event_emitter = EventEmitter();
  Duration delay_update = Duration(milliseconds: 1);
  Duration delay_invoke = Duration(milliseconds: 1);
  late double timeOutUpdate;
  late Module module;
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
    module = await EmscriptenModule.process("moduleName");
    return;
  }

  ffi.DynamicLibrary get tdLib {
    return ffi.DynamicLibrary.fromModule(module);
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
    return;
  }

  /// client_execute
  Map<String, dynamic> client_execute(int clientId, [Map? parameters]) {
    return {"@type": "error"};
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
    return null;
  }

  /// add this for multithread on flutter apps
  Future<void> initIsolate({
    int? clientId,
    Map? clientOption,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    clientId ??= client_id;
    var client_new_option = client_option;
    if (clientOption != null) {
      client_new_option.addAll(clientOption);
    }
    ReceivePort receivePort = ReceivePort();
    receivePort.listen((message) async {
      try {
        if (message[0] is Map && message[0]["@extra"] is String) {
          event_emitter.emit(event_invoke, null, message);
        } else {
          event_emitter.emit(event_update, null, message);
        }
      } catch (e) {
        event_emitter.emit(event_update, null, message);
      }
    });

    try {
      Isolate isolate = await Isolate.spawn(
        (List args) async {
          SendPort sendPortToMain = args[0];
          Map option = args[1];
          int clientId = args[2];
          String pathTdl = args[3];
          Duration duration = args[5];
          double timeout = args[6];
          Tdlib tg = Tdlib(
            pathTdl: pathTdl,
            clientOption: option,
            clientId: clientId,
          );
          while (true) {
            await Future.delayed(duration);
            var updateOrigin = tg.client_receive(clientId, timeout);
            if (updateOrigin != null) {
              sendPortToMain.send([updateOrigin, clientId, option]);
            }
          }
        },
        [
          receivePort.sendPort,
          client_new_option,
          clientId,
          path_tdlib,
          is_android,
          delay_update,
          timeOutUpdate,
        ],
        onExit: receivePort.sendPort,
        onError: receivePort.sendPort,
      );
      clients.add(TdlibClient(
        client_id: clientId,
        isolate: isolate,
      ));
    } catch (e) {
      receivePort.close();
    }
  }

  // exit
  // Future<bool> exitClient(
  //   int clientId, {
  //   bool isClose = false,
  //   String? extra,
  // }) async {
  //   for (var i = 0; i < clients.length; i++) {
  //     TdlibClient tdlibClient = clients[i];
  //     if (tdlibClient.client_id == clientId) {
  //       if (isClose) {
  //         await invoke(
  //           "close",
  //           clientId: clientId,
  //           extra: extra,
  //         );
  //       }
  //       tdlibClient.close();
  //       clients.removeAt(i);
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  /// add this for multithread new client on flutter apps
  Future<void> initIsolateNewClient(
      {required int clientId, required Map clientOption}) async {
    await Future.delayed(Duration(seconds: 2));
    client_option.addAll(clientOption);
    await initIsolate(clientId: clientId, clientOption: client_option);
  }
}

class Utf8s extends ffi.Opaque {}

/// Extension method for converting a`Pointer<Utf8>` to a [String].
extension Utf8Pointers on Pointer<Utf8s> {
  /// The number of UTF-8 code units in this zero-terminated UTF-8 string.
  ///
  /// The UTF-8 code units of the strings are the non-zero code units up to the
  /// first zero code unit.
  int get length {
    _ensureNotNullptr('length');
    final codeUnits = cast<Uint8>();
    return _length(codeUnits);
  }

  /// Converts this UTF-8 encoded string to a Dart string.
  ///
  /// Decodes the UTF-8 code units of this zero-terminated byte array as
  /// Unicode code points and creates a Dart string containing those code
  /// points.
  ///
  /// If [length] is provided, zero-termination is ignored and the result can
  /// contain NUL characters.
  ///
  /// If [length] is not provided, the returned string is the string up til
  /// but not including  the first NUL character.
  String toDartString({int? length}) {
    _ensureNotNullptr('toDartString');
    final codeUnits = cast<Uint8>();
    if (length != null) {
      RangeError.checkNotNegative(length, 'length');
    } else {
      length = _length(codeUnits);
    }
    return utf8.decode(codeUnits.asTypedList(length));
  }

  static int _length(Pointer<Uint8> codeUnits) {
    var length = 0;
    while (codeUnits[length] != 0) {
      length++;
    }
    return length;
  }

  void _ensureNotNullptr(String operation) {
    if (this == nullptr) {
      throw UnsupportedError(
          "Operation '$operation' not allowed on a 'nullptr'.");
    }
  }
}

/// Extension method for converting a [String] to a `Pointer<Utf8>`.
extension StringUtf8Pointer on String {
  /// Creates a zero-terminated [Utf8] code-unit array from this String.
  ///
  /// If this [String] contains NUL characters, converting it back to a string
  /// using [Utf8Pointer.toDartString] will truncate the result if a length is
  /// not passed.
  ///
  /// Unpaired surrogate code points in this [String] will be encoded as
  /// replacement characters (U+FFFD, encoded as the bytes 0xEF 0xBF 0xBD) in
  /// the UTF-8 encoded result. See [Utf8Encoder] for details on encoding.
  ///
  /// Returns an [allocator]-allocated pointer to the result.
  Pointer<Utf8s> toNativeUtf8(
      // {
      // ffi.Allocator allocator = malloc,
      // }
      ) {
    // final units = utf8.encode(this);
    // final Pointer<Uint8> result = allocator<Uint8>(units.length + 1);
    // final Uint8List nativeString = result.asTypedList(units.length + 1);
    // nativeString.setAll(0, units);
    // nativeString[units.length] = 0;
    // return result.cast();
    return Pointer.fromAddress(12);
  }
}
