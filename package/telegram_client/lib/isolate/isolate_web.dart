class ReceivePort {
  ReceivePort();

  SendPort get sendPort {
    return SendPort();
  }

  listen(Future<dynamic> Function(dynamic data) callback) {}
}

class SendPort {
  SendPort();

  void send(dynamic data) {}
}

class Isolate {
  static Future<Isolate> spawn<T>(
    Future<dynamic> Function(T data) callback,
    T data, {
    SendPort? onExit,
    SendPort? onError,
  }) async {
    return Isolate();
  }

  void kill() {}
}
