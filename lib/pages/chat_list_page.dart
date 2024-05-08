import 'package:chat_app/data/vos/message_vo.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api/firebase_api_impl.dart';
import 'package:chat_app/pages/chat_details_page.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/dimensions.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:chat_app/utils/utils_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/vos/user_vo.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  FirebaseApi firebaseApi = FirebaseApiImpl();
  @override
  void initState() {
    // firebaseApi.sendMessage(
    //     MessageVO(
    //         id: DateTime.now().millisecondsSinceEpoch.toString(),
    //         text: "67890",
    //         file: "",
    //         senderName: "KP",
    //         senderId: "12345",
    //         type: "text"),
    //     "67890",
    //     "12345");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildDefaultAppBar(kTextChats, false),
        body: const ChatListView());
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const ChatListItemView();
        },
      ),
    );
  }
}

class ChatListItemView extends StatelessWidget {
  const ChatListItemView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push(ChatDetailsPage(
          user: UserVO(name: "KP", email: "kp@gmail.com", id: "testing"),
        ));
      },
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        height: 56,
        width: 56,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: kAvatarBackgroundColor,
                  borderRadius: BorderRadius.circular(kMarginMedium3)),
              child: const Center(
                child: Text(
                  "KP",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: kTextRegular2X),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Container(
                  height: kMargin12,
                  width: kMargin12,
                  decoration: const BoxDecoration(
                      color: kActiveNowBubbleColor, shape: BoxShape.circle),
                ),
              ),
            )
          ],
        ),
      ),
      title: const Text(
        "Kaung Pyae Hein",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: const Text(
        "Good morning, did you sleep well?",
        style: TextStyle(color: kHintTextColor),
      ),
      trailing: const Text(
        "Today",
        style: TextStyle(color: kHintTextColor),
      ),
    );
  }
}
