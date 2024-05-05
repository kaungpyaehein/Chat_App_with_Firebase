import 'package:chat_app/pages/splash_page.dart';
import 'package:chat_app/persistence/hive_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'data/vos/user_vo.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize hive
  await Hive.initFlutter();

  /// REGISTER ADAPTER
  Hive.registerAdapter(UserVOAdapter());

  /// OPEN BOX
  await Hive.openBox<UserVO>(kBoxNameUserVO);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
