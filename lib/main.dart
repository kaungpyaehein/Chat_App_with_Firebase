import 'dart:convert';

import 'package:chat_app/data/vos/message_vo.dart';
import 'package:chat_app/pages/auth_page.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/persistence/hive_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'data/notification_service.dart';
import 'data/vos/user_vo.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received in background...");
  }
}

// to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize hive
  await Hive.initFlutter();

  /// REGISTER ADAPTER
  Hive.registerAdapter(UserVOAdapter());
  Hive.registerAdapter(MessageVOAdapter());

  /// OPEN BOX
  await Hive.openBox<UserVO>(kBoxNameUserVO);
  await Hive.openBox<UserVO>(kBoxNameMessageVO);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize firebase messaging
  await PushNotifications.init();

  // initialize local notifications
  // dont use local notifications for web platform

  await PushNotifications.localNotiInit();

  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification Tapped");
      navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => const MainPage(selectedIndex: 0),
      ));
    }
  });

// to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });

  final PushNotifications _pushNotifications = PushNotifications();
  _pushNotifications.getToken().then((token) {
    if (token != null) {
      print("TOKEN" +token.toString());
    }else {
      print("IT IS NULL");
    }
  });
  // for handling in terminated state
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => const MainPage(selectedIndex: 0),
      ));
    });
  }
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
        navigatorKey: navigatorKey,
        home: const AuthPage());
  }
}
