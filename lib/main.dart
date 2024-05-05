import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/splash_page.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Mulish",
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,

        ),

      ),
      home: const SplashPage(),
    );
  }
}
