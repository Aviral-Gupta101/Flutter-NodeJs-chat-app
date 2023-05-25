import 'package:chat_app/util/colors.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';

class RoomScreen extends StatelessWidget {
  final String roomId;
  final Function(String) leaveRoom;
  const RoomScreen(this.roomId, this.leaveRoom, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Room ID: #${roomId}"),
        actions: [
          IconButton(
            onPressed: () {
              leaveRoom(roomId);
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.logout,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      body: ListView(
        children: const [
          ChatMessage("Hello aviral"),
          ChatMessage(
            "Hello aviral",
            left: true,
          ),
        ],
      ),
    );
  }
}
