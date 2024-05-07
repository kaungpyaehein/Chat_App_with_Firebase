import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../data/models/chat_app_model.dart';
import '../data/vos/user_vo.dart';

class UserInfoBloc extends ChangeNotifier {
  final ChatAppModel _model = ChatAppModel();

  UserVO? currentUser;

  List<UserVO> contactList = [];

  StreamSubscription? _contactsSubscription;

  UserInfoBloc() {
    currentUser = _model.getUserDataFromDatabase();
    _contactsSubscription =
        _model.getContactsStream().listen((contactsFromNetwork) {
      if (contactsFromNetwork != currentUser?.contacts) {
        currentUser = currentUser?.copyWith(contacts: contactsFromNetwork);
      }
      notifyListeners();
    });
  }

  Future logOut() async {
    await _model.logOut();
  }

  Future exchangeContactsUsingUids(String senderUid, String receiverUid) async {
    _model.exchangeContactsUsingUid(senderUid, receiverUid);
  }

  @override
  void dispose() {
    _contactsSubscription!.cancel();
    super.dispose();
  }
}
