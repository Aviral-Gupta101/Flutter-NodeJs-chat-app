import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/room_screen.dart';
import '../util/colors.dart';

class RoomCard extends StatefulWidget {
  final String roomId;
  final Function(String) leaveRoom;
  const RoomCard({required this.roomId, required this.leaveRoom, super.key});

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(widget.roomId),
      child: ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RoomScreen(
                  key: ValueKey(widget.roomId),
                  roomId: widget.roomId,
                  leaveRoom: widget.leaveRoom,
                ))),
        title: Text(
          "Room ID: #${widget.roomId}",
          style: TextStyle(
            fontSize: 16.5,
            color: colorScheme.primary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                Clipboard.setData(ClipboardData(text: widget.roomId));
                setState(() {
                  copied = true;
                });
                await Future.delayed(
                  const Duration(seconds: 3),
                );
                setState(() {
                  copied = false;
                });
              },
              icon: copied
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const Icon(Icons.copy),
            ),
            IconButton(
              onPressed: () {
                widget.leaveRoom(widget.roomId);
              },
              icon: Icon(
                Icons.logout,
                color: colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
