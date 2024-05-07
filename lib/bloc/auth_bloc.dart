import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:flutter/foundation.dart';

import '../data/vos/user_vo.dart';

class AuthBloc extends ChangeNotifier {
  final ChatAppModel _model = ChatAppModel();

  UserVO? currentUser;

  AuthBloc() {
    currentUser = _model.getUserDataFromDatabase();
  }

  Future<void> login(String email, String password) async {
    await _model.loginWithEmailAndPassword(email, password).then((userVO) {
      currentUser = userVO;
      notifyListeners();
    });
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    await _model.registerNewUser(name, email, password).then((userVO) {
      currentUser = userVO;
      notifyListeners();
    });
  }
}
