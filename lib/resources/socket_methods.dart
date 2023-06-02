// ignore_for_file: library_prefixes

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketMethods {
  static IO.Socket? socket;

  void sendMessage(String roomId, String msg) {
    socket!.emit("send-message", [roomId, socket!.id, msg]);
  }
}
