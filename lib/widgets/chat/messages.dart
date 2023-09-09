import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../main.dart';
import '/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() => FirebaseAuth.instanceFor(app: app).currentUser!.uid),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instanceFor(app: app)
              .collection('chat')
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            final chatDocs = chatSnapshot.data!.docs;
            print(futureSnapshot.data);
            print('mewo');
            // print(chatDocs[1]['userId']);
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['username'],
                chatDocs[index]['text'],
                chatDocs[index]['userId'] == futureSnapshot.data,
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
