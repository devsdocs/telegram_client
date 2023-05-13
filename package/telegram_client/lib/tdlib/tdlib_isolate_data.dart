import 'package:telegram_client/isolate/isolate.dart';

class TdlibIsolateData {
  SendPort sendPort;
  Map clientOption;
  int clientId;
  String pathTdlib;
  bool isAndroid;
  Duration? delayUpdate;
  double timeOutUpdate;
  TdlibIsolateData({
    required this.sendPort,
    required this.clientOption,
    required this.clientId,
    required this.pathTdlib,
    required this.isAndroid,
    required this.delayUpdate,
    required this.timeOutUpdate,
  });
}
