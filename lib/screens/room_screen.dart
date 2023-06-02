import 'package:chat_app/providers/chat_message_provider.dart';
import 'package:chat_app/resources/socket_methods.dart';
import 'package:chat_app/util/colors.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  final Function(String) leaveRoom;
  const RoomScreen({
    required this.roomId,
    required this.leaveRoom,
    super.key,
  });

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void sendMessage() {
    SocketMethods().sendMessage(widget.roomId, _controller.text);
    _controller.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessage = ref.watch(chatMessageProvider);
    // print("room screen build again");
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
      body: ListView.builder(
          controller: _scrollController,
          itemCount: chatMessage[widget.roomId].length,
          itemBuilder: (context, index) {
            var data = chatMessage[widget.roomId][index];
            // print(data[0]);
            if (data[0] == SocketMethods.socket!.id.toString()) {
              return ChatMessage(data[0], data[1]);
            } else {
              return ChatMessage(
                data[0],
                data[1],
                left: true,
              );
            }
          }),
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
                  onPressed: sendMessage,
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
