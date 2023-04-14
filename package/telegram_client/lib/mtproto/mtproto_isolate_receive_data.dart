class MtprotoIsolateReceiveData {
  Map updateData;
  int clientId;
  Map clientOption;
  MtprotoIsolateReceiveData({
    required this.updateData,
    required this.clientId,
    required this.clientOption,
  });
}

class MtprotoIsolateReceiveDataError {
  int clientId;
  Map clientOption;
  MtprotoIsolateReceiveDataError({
    required this.clientId,
    required this.clientOption,
  });
}
