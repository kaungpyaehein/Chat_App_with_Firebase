import 'dart:async';

import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api/firebase_api_impl.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter/material.dart';

import '../data/vos/message_vo.dart';
import '../data/vos/user_vo.dart';

class ChatDetailsBloc extends ChangeNotifier {
  late types.User currentMessageSender;
  late UserVO currentUser;
  List<types.Message> messages = [];
  ChatAppModel model = ChatAppModel();

  FirebaseApi firebaseApi = FirebaseApiImpl();

  StreamSubscription? messagesSubscription;

  String? messageReceiverId;

  ChatDetailsBloc(String receiverId) {
    messageReceiverId = receiverId;
    messagesSubscription =
        model.getMessageStream(receiverId).listen((messageList) {
      List<types.Message> newMessages = messageList
          .map(
            (messageVo) => types.TextMessage(
              id: messageVo.id ?? "",
              text: messageVo.text ?? "",
              author: types.User(
                  id: messageVo.senderId ?? "",
                  firstName: messageVo.senderName),
              createdAt: int.parse(messageVo.id ?? ""),
            ),
          )
          .toList();
      newMessages.sort((b, a) => a.id.compareTo(b.id));
      messages = newMessages;
      notifyListeners();
    });

    currentUser = model.getUserDataFromDatabase()!;
    currentMessageSender = types.User(
      id: currentUser.id,
      firstName: currentUser.name,
    );
  }

  void handleSendPressed(types.PartialText message) {
    firebaseApi.sendMessage(
      MessageVO(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: message.text,
          file: "",
          senderName: currentUser.name,
          senderId: currentUser.id,
          type: "text"),
      currentUser.id,
      messageReceiverId ?? "",
    );
    // _addMessage(textMessage);
  }

  @override
  void dispose() {
    messagesSubscription!.cancel();
    super.dispose();
  }
}
