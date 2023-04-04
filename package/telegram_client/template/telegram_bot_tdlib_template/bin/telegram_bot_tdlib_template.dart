import "package:telegram_client/telegram_client.dart";

void main(List<String> arguments) {
  Tdlib tg = Tdlib(pathTdl: "libtdjson.so");
  tg.client_create();
  tg.initIsolate();
}
