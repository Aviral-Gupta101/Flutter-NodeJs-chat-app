// ignore_for_file: library_prefixes

import 'dart:math';
import 'package:chat_app/providers/chat_message_provider.dart';
import 'package:chat_app/resources/socket_methods.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _joinRoomController = TextEditingController();
  final IO.Socket socket = SocketMethods.socket!;
  bool isRoom = false;
  List joinedRooms = [];

  String? room, user, userMsg;

  void createRoom() {
    isRoom = true;
    String id = "";
    for (int i = 0; i < 8; i++) {
      id = id + Random().nextInt(9).toString();
    }
    setState(() {
      _joinRoomController.text = id;
      // id = _joinRoomController.text;
      joinedRooms.add(id);
    });
    socket.emit("create-room", id);
    ref.read(chatMessageProvider.notifier).addRoom(id);
  }

  void joinRoom() {
    if (_joinRoomController.text.trim().length < 5) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Room ID should be atleast 5 character long"),
        ),
      );
      return;
    }
    if (joinedRooms.contains(_joinRoomController.text.trim()) == false) {
      setState(() {
        joinedRooms.add(_joinRoomController.text.trim());
      });
      socket.emit("create-room", _joinRoomController.text);
      ref.read(chatMessageProvider.notifier).addRoom(_joinRoomController.text);
    }
  }

  void leaveRoom(String id) {
    socket.emit("leave-room", id);
    setState(() {
      joinedRooms.remove(id);
    });
    ref.read(chatMessageProvider.notifier).deleteRoom(id);
  }

  @override
  void dispose() {
    super.dispose();
    _joinRoomController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        title: const Text("Chat App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createRoom,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          CustomTextField(_joinRoomController, joinRoom),
          Expanded(
            child: ListView.builder(
              itemCount: joinedRooms.length,
              itemBuilder: (context, index) {
                return RoomCard(
                  key: ValueKey(joinedRooms[index]),
                  roomId: joinedRooms[index],
                  leaveRoom: leaveRoom,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
