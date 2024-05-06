import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/network/data_agents/chat_app_data_agent.dart';
import 'package:chat_app/network/data_agents/chat_app_data_agent_impl.dart';
import 'package:chat_app/persistence/user_dao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ChatAppModel {
  static ChatAppModel? _singleton;

  factory ChatAppModel() {
    _singleton ??= ChatAppModel._internal();
    return _singleton!;
  }
  ChatAppModel._internal();

  final ChatAppDataAgent chatAppDataAgent = ChatAppDataAgentImpl();

  final UserDao userDao = UserDao();

  Future<UserVO> loginWithEmailAndPassword(String email, String password) {
    return chatAppDataAgent.login(email, password).then((userVO) {
      print(userVO.id.toString());
      userDao.saveUserData(userVO);
      return userVO;
    });
  }

  Future<UserVO> registerNewUser(String name, String email, String password) {
    return chatAppDataAgent.register(email, password, name).then((userVO) {
      userDao.saveUserData(userVO);
      return userVO;
    });
  }

  /// Get Contact Stream
  Stream<List<UserVO>> getContactsStream(String uid) {
    return chatAppDataAgent.getContactsDataStream(uid);
  }

  /// Get User data from hive
  UserVO? getUserDataFromDatabase() {
    return userDao.getUserData();
  }

  Future exchangeContactsUsingUid(String senderUid, String receiverUid) {
    return chatAppDataAgent.exchangeContactsWithUids(senderUid, receiverUid);
  }

  Future<void> logOut() async {
    userDao.clearUserData();
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString()); // TODO: show dialog with error
    }
  }
}
