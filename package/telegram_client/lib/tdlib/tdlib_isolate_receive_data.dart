class TdlibIsolateReceiveData {
  Map updateData;
  int clientId;
  Map clientOption;
  TdlibIsolateReceiveData({
    required this.updateData,
    required this.clientId,
    required this.clientOption,
  });
}

class TdlibIsolateReceiveDataError {
  int clientId;
  Map clientOption;
  TdlibIsolateReceiveDataError({
    required this.clientId,
    required this.clientOption,
  });
}
