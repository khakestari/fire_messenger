import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart' as f;
import './firebase_options.dart';
// import './screens/chat_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await f.Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Messenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFFB6334)),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          primary: const Color(0xFFFB6334),
          secondary: const Color(0xFF1A73E8),
          seedColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFB6334), // Color(0xFF363636),
            elevation: 10,
            side: const BorderSide(color: Colors.transparent),
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
            // textStyle: TextStyle(),
          ),
        ),
        useMaterial3: true,
      ),
      home: AuthScreen(),
    );
  }
}
