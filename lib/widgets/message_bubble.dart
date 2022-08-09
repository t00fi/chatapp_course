import 'package:flutter/material.dart';

///this widget is designed bubble message which will be called in message.dart file to look chant more interesting.
class MessageBubble extends StatelessWidget {
  const MessageBubble({Key? key, required this.sentMessage, required this.isMe})
      : super(key: key);
  final String sentMessage;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 140,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft:
                  !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          child: Text(
            sentMessage,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
