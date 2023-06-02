// ignore_for_file: library_prefixes

import 'package:chat_app/providers/chat_message_provider.dart';
import 'package:chat_app/resources/socket_io_config.dart';
import 'package:chat_app/resources/socket_methods.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  String? room, userMsg, user;

  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    SocketMethods.socket = connectAndListen();
    socket = SocketMethods.socket!;
  }

  @override
  void dispose() {
    super.dispose();
    streamSocket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final msg = ref.read(chatMessageProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (room != null && userMsg != null && user != null) {
        msg.addMessage([room!, user!, userMsg!]);
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
      ),
      home: StreamBuilder(
        stream: streamSocket.getResponse,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Some error occured in stream"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Wating for socket connection ...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 50),
                    CircularProgressIndicator(
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            );
          }

          if (snapshot.data != null && snapshot.data != "connected") {
            // print("Snapshot recieved : ${snapshot.data}");
            List<String> list = (snapshot.data as String).split(',');
            room = list[0].substring(1);
            user = list[1].substring(1);
            userMsg = list[2].substring(1, list[2].length - 1);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (room != null && userMsg != null && user != null) {
                msg.addMessage([room!, user!, userMsg!]);
              }
            });

            // clear the snapshot data so that does not affect fetch the same data
            // if same room is left and joined again
          }
          return const HomeScreen();
        },
      ),
    );
  }
}
