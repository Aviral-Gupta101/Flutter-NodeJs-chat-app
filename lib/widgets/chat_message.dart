import 'package:chat_app/resources/socket_methods.dart';
import 'package:flutter/material.dart';

import '../util/colors.dart';

class ChatMessage extends StatelessWidget {
  final String id;
  final String text;
  final bool left;
  const ChatMessage(this.id, this.text, {this.left = false, super.key});

  @override
  Widget build(BuildContext context) {
    // final user = "${SocketMethods.socket!.id.toString().substring(0, 7)}...";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          left == false ? const Spacer() : Container(),
          Container(
            // width: MediaQuery.of(context).size.width / 2 - 20,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 2 - 20,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: left
                  ? colorScheme.onInverseSurface
                  : colorScheme.inversePrimary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${id.substring(0, 7)}..."),
                Text(
                  text,
                  style: TextStyle(
                    color: colorScheme.onBackground,
                    fontSize: 17.5,
                  ),
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          left == true ? const Spacer() : Container(),
        ],
      ),
    );
  }
}
