import 'dart:async';

import 'package:chat_app/data/vos/message_vo.dart';
import 'package:flutter/material.dart';

import '../data/models/chat_app_model.dart';
import '../data/vos/user_vo.dart';

class ChatListBloc extends ChangeNotifier {
  List<UserVO> chatListUsers = [];
  ChatAppModel model = ChatAppModel();

  ChatListBloc() {
    model.getChatContacts().then((contacts) {
      print(contacts.toList());
      chatListUsers = contacts;
      notifyListeners();
    });
  }
}
