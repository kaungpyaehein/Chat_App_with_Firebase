import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/data/notification_service.dart';
import 'package:flutter/foundation.dart';

import '../data/vos/user_vo.dart';

class AuthBloc extends ChangeNotifier {
  final ChatAppModel _model = ChatAppModel();
  final PushNotifications _pushNotifications = PushNotifications();
  late String fcmToken;

  UserVO? currentUser;

  AuthBloc() {
    currentUser = _model.getUserDataFromDatabase();
    _pushNotifications.getToken().then((token) {
      if (token != null) {
        fcmToken = token;
      }
    });
  }

  Future<void> login(String email, String password) async {
    await _model.loginWithEmailAndPassword(email, password).then((userVO) {
      currentUser = userVO.copyWith(fcmToken: fcmToken);
      notifyListeners();
    });
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    await _model.registerNewUser(name, email, password).then((userVO) {
      currentUser = userVO.copyWith(fcmToken: fcmToken);

      notifyListeners();
    });
  }
}
