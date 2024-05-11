import 'package:chat_app/data/vos/message_vo.dart';
import 'package:hive_flutter/adapters.dart';

import '../data/vos/user_vo.dart';
import 'hive_constants.dart';

class MessageDao {
  static final MessageDao _singleton = MessageDao._internal();

  factory MessageDao() {
    return _singleton;
  }
  MessageDao._internal();

  /// save user data

  void saveMessageData(List<MessageVO> messages) async {
    await getMessageBox().clear();
    await getMessageBox().put(kBoxNameMessageVO, messages);
  }

  void clearUserData() async {
    await getMessageBox().clear();
  }

  Stream watchUserBox() {
    return getMessageBox().watch();
  }
  // String getToken() {
  //   return getUserBox().get(kBoxKeyUser)?.getToken().toString() ?? "";
  // }

  /// get user data
  List<MessageVO>? getMessageVo() {
    return getMessageBox().get(kBoxKeyMessage);
  }

  /// user box
  Box<List<MessageVO>> getMessageBox() {
    return Hive.box<List<MessageVO>>(kBoxNameMessageVO);
  }
}
