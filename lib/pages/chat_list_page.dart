import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/data/vos/message_vo.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api/firebase_api_impl.dart';
import 'package:chat_app/pages/chat_details_page.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/dimensions.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:chat_app/utils/utils_functions.dart';
import 'package:flutter/material.dart';

import '../data/vos/user_vo.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildDefaultAppBar(kTextChats, false),
        body: const ChatListView());
  }
}

class ChatListView extends StatefulWidget {
  const ChatListView({
    super.key,
  });

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  FirebaseApi firebaseApi = FirebaseApiImpl();
  ChatAppModel model = ChatAppModel();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
      child: FutureBuilder<List<UserVO>>(
          future: model.getChatContacts(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData) {
              List<UserVO> users = userSnapshot.data!;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ChatListItemView(
                    chatUser: users[index],
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class ChatListItemView extends StatefulWidget {
  const ChatListItemView({
    super.key,
    required this.chatUser,
  });

  final UserVO chatUser;

  @override
  State<ChatListItemView> createState() => _ChatListItemViewState();
}

class _ChatListItemViewState extends State<ChatListItemView> {
  FirebaseApi firebaseApi = FirebaseApiImpl();
  ChatAppModel model = ChatAppModel();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MessageVO?>(
        future: firebaseApi.getLastMessageByChatId(
            widget.chatUser.id, model.getUserDataFromDatabase()?.id ?? ""),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState != ConnectionState.waiting) {
            final MessageVO lastMessage = snapshot.data!;

            return ListTile(
              onTap: () {
                context.push(ChatDetailsPage(
                  user: widget.chatUser,
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
                      child: Center(
                        child: Text(
                          widget.chatUser.getInitialLetters(),
                          style: const TextStyle(
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
                              color: kActiveNowBubbleColor,
                              shape: BoxShape.circle),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              title: Text(
                widget.chatUser.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                lastMessage.text ?? "",
                style: const TextStyle(color: kHintTextColor),
              ),
              trailing: Text(
                lastMessage.getLastMessageTime(),
                style: const TextStyle(color: kHintTextColor),
              ),
            );
          }
          return const Center(
            child: Text("No Active Chat"),
          );
        });
  }
}
