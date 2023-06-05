// import 'package:telegram_client/telegram_client.dart';
import "tdlib_core.dart";

class TdlibApi extends Tdlib {
  TdlibApi({
    super.pathTdl,
    super.clientOption,
    super.is_cli,
    super.clientId,
    super.invokeTimeOut,
    super.event_invoke = "invoke",
    super.event_update = "update",
    super.delayUpdate,
    super.timeOutUpdate = 1.0,
    super.eventEmitter,
    super.delayInvoke,
    super.isAutoGetChat = false,
    super.on_get_invoke_data,
    super.on_receive_update,
    super.on_generate_extra_invoke,
  });
 
}

void main(List<String> args) {
  // TdlibApi tdlibApi = TdlibApi();
}
