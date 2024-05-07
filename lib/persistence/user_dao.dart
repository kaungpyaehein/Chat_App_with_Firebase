import 'package:hive_flutter/adapters.dart';

import '../data/vos/user_vo.dart';
import 'hive_constants.dart';

class UserDao {
  static final UserDao _singleton = UserDao._internal();

  factory UserDao() {
    return _singleton;
  }
  UserDao._internal();

  /// save user data

  void saveUserData(UserVO userVO) async {
    await getUserBox().clear();
    await getUserBox().put(kBoxKeyUser, userVO);
  }

  void clearUserData() async {
    await getUserBox().clear();
  }

  Stream watchUserBox() {
    return getUserBox().watch();
  }
  // String getToken() {
  //   return getUserBox().get(kBoxKeyUser)?.getToken().toString() ?? "";
  // }

  /// get user data
  UserVO? getUserData() {
    return getUserBox().get(kBoxKeyUser);
  }

  /// user box
  Box<UserVO> getUserBox() {
    return Hive.box<UserVO>(kBoxNameUserVO);
  }
}
