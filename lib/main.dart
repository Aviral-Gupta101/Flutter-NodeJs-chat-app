import 'package:chat_app/resources/socket_io_config.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/room_screen.dart';
import 'package:chat_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    socket = connectAndListen();
  }

  @override
  void dispose() {
    super.dispose();
    streamSocket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
      ),
      home: HomeScreen(socket),
      // home: RoomScreen(),
    );
  }
}
