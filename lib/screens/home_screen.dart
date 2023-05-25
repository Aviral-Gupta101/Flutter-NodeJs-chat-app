import 'dart:math';
import 'package:chat_app/screens/room_screen.dart';
import 'package:chat_app/util/colors.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  final IO.Socket socket;
  const HomeScreen(this.socket, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _joinRoomController = TextEditingController();
  List joinedRooms = [];

  void createRoom() {
    String id = "";
    for (int i = 0; i < 8; i++) {
      id = id + Random().nextInt(9).toString();
    }
    setState(() {
      _joinRoomController.text = id;
      joinedRooms.add(id);
    });
    widget.socket.emit("create-room", id);
  }

  void leaveRoom(String id) {
    widget.socket.emit("leave-room", id);
    setState(() {
      joinedRooms.remove(id);
    });
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
          CustomTextField(_joinRoomController),
          joinedRooms.isEmpty
              ? const Center(
                  child: Text('No join room'),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: joinedRooms.length,
                    itemBuilder: (context, index) {
                      return Card(
                        key: ValueKey(joinedRooms[index]),
                        child: ListTile(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => RoomScreen(
                                      joinedRooms[index], leaveRoom))),
                          title: Text(
                            "Room ID: #${joinedRooms[index]}",
                            style: TextStyle(
                              fontSize: 16.5,
                              color: colorScheme.primary,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              leaveRoom(joinedRooms[index]);
                            },
                            icon: Icon(
                              Icons.logout,
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
