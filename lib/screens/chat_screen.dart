import 'package:flutter/material.dart';
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/Up120tnS7gHBeSxcDL3t/messages')
            .snapshots(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(8),
              child: Text(documents[index]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFB6334),
        onPressed: () async {
          //     .listen((event) {
          //   for (var document in event.docs) {
          //     print(document['text']);
          //   }
          // }
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
