import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FireMessenger',
        ),
        actions: [
          DropdownButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            items: const [
              DropdownMenuItem(
                value: 'Log out',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text('Log out')
                  ],
                ),
              )
            ],
            onChanged: (itemIdenifier) {
              if (itemIdenifier == 'Log out') {
                FirebaseAuth.instanceFor(app: app).signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(
          children: [Expanded(child: Messages()), NewMessage()],
        ),
      ),
    );
  }
}
