import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback joinRoom;
  // final bool copy;
  const CustomTextField(this.controller, this.joinRoom, {super.key});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isCopied = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.onBackground.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                style: const TextStyle(
                  letterSpacing: 5,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.numbers),
                  border: InputBorder.none,
                  hintText: "Join a room",
                  hintStyle: TextStyle(fontSize: 16.5, letterSpacing: 1),
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
                Clipboard.setData(
                    ClipboardData(text: widget.controller.text.trim()));
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
            TextButton(
              onPressed: widget.joinRoom,
              // icon: const Icon(Icons.),
              child: const Text(
                "Join",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
