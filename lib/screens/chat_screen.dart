import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as F;
import 'package:cloud_firestore/cloud_firestore.dart';

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
      ),
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(8),
          child: const Text('this works!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('chats/Up120tnS7gHBeSxcDL3t/messages')
              .snapshots()
              .listen((event) {
            event.docs.forEach((document) {
              print(document['text']);
            });
          });
          // print(temp);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
