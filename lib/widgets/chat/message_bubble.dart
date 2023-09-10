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
      children: [
        !isMe
            ? CircleAvatar(
                maxRadius: 16,
                backgroundImage: NetworkImage(profileImage),
              )
            : SizedBox(),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: isMe
                  ? BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      color:
                          const Color(0xFFcccccc).withOpacity(0.5), //FF00449B
                    )
                  : BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: const Color(0xFFD70240).withOpacity(0.5),
                    ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
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
