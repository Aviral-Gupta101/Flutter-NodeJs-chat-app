import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blueGrey[900]!,
  brightness: Brightness.dark,
);

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController _joinRoomController = TextEditingController();

  bool isCopied = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _joinRoomController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          centerTitle: true,
          title: const Text("Chat App"),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                    color: colorScheme.onBackground.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _joinRoomController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          border: InputBorder.none,
                          hintText: "Join a room",
                          hintStyle: TextStyle(fontSize: 16.5),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isCopied = false;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: _joinRoomController.text.trim()));
                        setState(() {
                          isCopied = true;
                        });
                      },
                      icon: isCopied
                          ? Icon(
                              Icons.check,
                              color: Colors.green.shade400,
                              size: 30,
                            )
                          : const Icon(Icons.copy),
                    ),
                  ],
                ),
              ),
            ),
            isCopied
                ? Text(
                    "Text Coped !!!",
                    style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
            const Center(
              child: Text('No join room'),
            ),
          ],
        ),
      ),
    );
  }
}
