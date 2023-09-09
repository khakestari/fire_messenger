import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMessage = '';
  final _controller = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instanceFor(app: app).currentUser;
    final userData = await FirebaseFirestore.instanceFor(app: app)
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instanceFor(app: app).collection('chat').add({
      'text': _enteredMessage,
      'timeStamp': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : null,
              icon: Icon(
                Icons.attachment_sharp,
                color: Theme.of(context).colorScheme.primary,
              )),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: 'Write a message...', border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : null,
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: Theme.of(context).colorScheme.primary,
              )),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
