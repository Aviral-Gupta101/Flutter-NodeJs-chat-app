import 'package:flutter/material.dart';

import '../screens/room_screen.dart';
import '../util/colors.dart';

class RoomCard extends StatelessWidget {
  final String snapshot;
  final String roomId;
  final Function(String) leaveRoom;
  const RoomCard(
      {required this.snapshot,
      required this.roomId,
      required this.leaveRoom,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(roomId),
      child: ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RoomScreen(
                  key: ValueKey(roomId),
                  snapshot: snapshot,
                  roomId: roomId,
                  leaveRoom: leaveRoom,
                ))),
        title: Text(
          "Room ID: #$roomId",
          style: TextStyle(
            fontSize: 16.5,
            color: colorScheme.primary,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            leaveRoom(roomId);
          },
          icon: Icon(
            Icons.logout,
            color: colorScheme.error,
          ),
        ),
      ),
    );
  }
}
