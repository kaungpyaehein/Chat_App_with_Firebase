import 'package:chat_app/data/vos/message_vo.dart';
import 'package:flutter/material.dart';

import '../data/models/chat_app_model.dart';
import '../data/vos/user_vo.dart';

class ChatListBloc extends ChangeNotifier {
  List<UserVO> chatListUsers = [];
  List<MessageVO> lastMessageList = [];
  ChatAppModel model = ChatAppModel();

  ChatListBloc() {
    model.getChatContacts().then((contacts) {
      chatListUsers = contacts;

      for (var userVO in chatListUsers) {
        model.getLastMessage(userVO.id).then((message) {
          if (message != null) {
            lastMessageList.add(message);
          }
        });
      }
      notifyListeners();
    });
  }
}
