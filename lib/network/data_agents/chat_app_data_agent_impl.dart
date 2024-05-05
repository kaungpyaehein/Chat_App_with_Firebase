import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api/firebase_api_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/vos/error_vo.dart';
import '../../exception/custom_exception.dart';
import 'chat_app_data_agent.dart';

class ChatAppDataAgentImpl implements ChatAppDataAgent {
  late FirebaseApi firebaseApi = FirebaseApiImpl();
  //setup singleton
  static ChatAppDataAgentImpl? _singleton;

  factory ChatAppDataAgentImpl() {
    _singleton ??= ChatAppDataAgentImpl._internal();
    return _singleton!;
  }
  ChatAppDataAgentImpl._internal();

  @override
  Future<UserVO?> login(String email, String password) {
    return firebaseApi.login(email, password).then((uid) async {
      if (uid != null) {
        /// GET DATA FROM FIRESTORE
        return await firebaseApi.getUserDatFromFirestore(uid);
      }
      return null;
    }).catchError((error) {
      throw _createException(error);
    });
  }

  @override
  Future<UserVO?> register(String email, String password, String name) async {
    try {
      final uid = await firebaseApi.registerAccount(email, password, name);
      if (uid != null) {
        final UserVO userVO = UserVO(
          name: name,
          id: uid,
          contacts: [],
          email: email,
          fcmToken: "",
        );

        /// WRITE DATA TO FIRESTORE
        final isSuccess = await firebaseApi.addUserDataToFirestore(userVO);
        if (isSuccess) {
          return userVO; // Return userVO if Firestore operation is successful
        }
      }
      return null;
    } catch (error) {
      throw _createException(error);
    }
  }
}

CustomException _createException(dynamic error) {
  ErrorVO errorVO;
  if (error is FirebaseAuthException) {
    errorVO = _parseFirebaseAuthException(error);
  } else {
    errorVO = ErrorVO(
        statusCode: 0, statusMessage: "Unexpected Error", success: false);
  }
  return CustomException(errorVO);
}

ErrorVO _parseFirebaseAuthException(FirebaseAuthException error) {
  try {
    if (error.message != null) {
      // You can customize the error message here if needed
      return ErrorVO(
        statusCode: 0,
        statusMessage: error.message!,
        success: false,
      );
    } else {
      return ErrorVO(
        statusCode: 0,
        statusMessage: "No response data",
        success: false,
      );
    }
  } catch (e) {
    return ErrorVO(
      statusCode: 0,
      statusMessage: "Invalid FirebaseAuthException Format: $e",
      success: false,
    );
  }
}
