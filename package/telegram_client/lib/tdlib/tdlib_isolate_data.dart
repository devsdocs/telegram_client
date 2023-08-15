import 'package:telegram_client/isolate/isolate.dart';
import 'package:telegram_client/scheme/scheme.dart';

class TdlibIsolateData {
  SendPort sendPort;
  TdlibClient tdlibClient;
  String pathTdlib;
  bool isAndroid;
  Duration? delayUpdate;
  double timeOutUpdate;
  TdlibIsolateData({
    required this.sendPort,
    required this.tdlibClient,
    required this.pathTdlib,
    required this.isAndroid,
    required this.delayUpdate,
    required this.timeOutUpdate,
  });
}
