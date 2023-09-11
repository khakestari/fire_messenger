import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../widgets/custom_dropdown.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Future<void> setupInteractedMessage() async {
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }

  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }

  // void _handleMessage(RemoteMessage message) {
  //   if (message.data['type'] == 'chat') {
  //     Navigator.pushNamed(
  //       context,
  //       '/chat',
  //       arguments: ChatArguments(message),
  //     );
  //   }
  // }
  Future<void> setupInteractedMessage() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print(message);
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

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
