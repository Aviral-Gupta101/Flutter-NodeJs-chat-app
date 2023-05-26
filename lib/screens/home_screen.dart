import 'dart:math';
import 'package:chat_app/resources/socket_io_config.dart';
import 'package:chat_app/resources/socket_methods.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _joinRoomController = TextEditingController();
  final IO.Socket socket = SocketMethods.socket!;
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
    socket.emit("create-room", id);
  }

  void leaveRoom(String id) {
    socket.emit("leave-room", id);
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
              : StreamBuilder(
                  stream: streamSocket.getResponse,
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Some error occured in stream"),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    print("Snapshot: ${snapshot.data}");
                    return Expanded(
                        child: ListView.builder(
                      itemCount: joinedRooms.length,
                      itemBuilder: (context, index) {
                        return RoomCard(
                          snapshot: snapshot.data.toString(),
                          roomId: joinedRooms[index],
                          leaveRoom: leaveRoom,
                        );
                      },
                    ));
                  },
                )
        ],
      ),
    );
  }
}
