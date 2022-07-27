import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zuras_chat/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zuras_chat/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zura\'s Chat',
      theme: ThemeData(
          colorScheme: const ColorScheme(
            primary: Colors.green,
            background: Colors.pink,
            secondary: Colors.deepPurple,
            onSecondary: Colors.white,
            onPrimary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            onBackground: Colors.white,
            brightness: Brightness.light,
            surface: Colors.red,
            onSurface: Colors.white,
          ),
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
