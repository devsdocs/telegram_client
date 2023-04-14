import 'package:telegram_client/isolate/isolate.dart';

class MtprotoIsolateData {
  SendPort sendPort;
  Map clientOption;
  int clientId;
  String pathMtproto;
  bool isAndroid;
  Duration delayUpdate;
  double timeOutUpdate;
  MtprotoIsolateData({
    required this.sendPort,
    required this.clientOption,
    required this.clientId,
    required this.pathMtproto,
    required this.isAndroid,
    required this.delayUpdate,
    required this.timeOutUpdate,
  });
}
