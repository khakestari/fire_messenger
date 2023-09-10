import 'dart:ui';

import 'package:flutter/material.dart';

// import '../../../main.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.username, this.profileImage, this.message, this.isMe,
      {required this.key});
  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final String profileImage;

  @override
  Widget build(BuildContext context) {
    // print(isMe);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        !isMe
            ? CircleAvatar(
                maxRadius: 16,
                backgroundImage: NetworkImage(profileImage),
              )
            : const SizedBox(),
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: isMe
              ? BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: const Color(0xFF2E7690).withOpacity(0.5), //FF00449B
                )
              : BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: const Color(0xFF1A333D).withOpacity(0.5),
                ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isMe
                  ? SizedBox()
                  : Text(
                      username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? Color(0xFFFFFFFF) : Color(0xFF34A3E3)),
                    ),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
        isMe
            ? CircleAvatar(
                maxRadius: 16,
                backgroundImage: NetworkImage(profileImage),
              )
            : SizedBox(),
      ],
    );
  }
}
