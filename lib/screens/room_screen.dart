import 'package:chat_app/util/colors.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class RoomScreen extends StatefulWidget {
  final String snapshot;
  final String roomId;
  final Function(String) leaveRoom;
  const RoomScreen({
    required this.snapshot,
    required this.roomId,
    required this.leaveRoom,
    super.key,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text("Room ID: #${widget.roomId}"),
        actions: [
          IconButton(
            onPressed: () {
              widget.leaveRoom(widget.roomId);
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.logout,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text(widget.snapshot),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: 3,
              right: 3,
              bottom: MediaQuery.of(context).viewInsets.bottom + 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(64)),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter a message...",
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
