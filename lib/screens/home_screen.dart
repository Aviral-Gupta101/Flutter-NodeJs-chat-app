import 'dart:math';
import 'package:chat_app/providers/chat_message_provider.dart';
import 'package:chat_app/resources/socket_io_config.dart';
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
      // _joinRoomController.text = id;
      id = _joinRoomController.text;
      joinedRooms.add(id);
    });
    socket.emit("create-room", id);
    ref.read(chatMessageProvider.notifier).addRoom(id);
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
    print("build");
    final msg = ref.read(chatMessageProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (room != null && userMsg != null && user != null)
        msg.addMessage([room!, user!, userMsg!]);
    });
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
          joinedRooms.isEmpty && !isRoom
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
                    }

                    if (snapshot.data != null) {
                      print("Snapshot recieved : ${snapshot.data}");
                      List<String> list = (snapshot.data as String).split(',');
                      room = list[0].substring(1);
                      user = list[1].substring(1);
                      userMsg = list[2].substring(1, list[2].length - 1);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (room != null && userMsg != null && user != null) {
                          msg.addMessage([room!, user!, userMsg!]);
                        }
                      });
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: joinedRooms.length,
                        itemBuilder: (context, index) {
                          return RoomCard(
                            key: ValueKey(joinedRooms[index]),
                            snapshot: snapshot.data.toString(),
                            roomId: joinedRooms[index],
                            leaveRoom: leaveRoom,
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
