import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../widgets/custom_dropdown.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: const Text(
          'FireMessenger',
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (ctx) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          DropdownButtonHideUnderline(
              child: DropdownButton(
            alignment: AlignmentDirectional.topCenter,
            elevation: 0,
            icon: const Icon(Icons.more_vert, color: Colors.black),
            items: const [
              DropdownMenuItem(
                value: 'Log out',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text(
                      'Log out',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              )
            ],
            onChanged: (itemIdenifier) {
              if (itemIdenifier == 'Log out') {
                FirebaseAuth.instance.signOut();
              }
            },
          )),
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

class Constants {
  static const String FirstItem = 'Mute notification';
  static const String SecondItem = 'View profile';
  static const String ThirdItem = 'Log out';
  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
  ];
}

void choiceAction(String choice) {
  if (choice == Constants.FirstItem) {
    print('I First Item');
  } else if (choice == Constants.SecondItem) {
    print('I Second Item');
  } else if (choice == Constants.ThirdItem) {
    FirebaseAuth.instance.signOut();
  }
}
