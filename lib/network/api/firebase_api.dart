import '../../data/vos/user_vo.dart';

abstract class FirebaseApi {
  Future<String?> registerAccount(
    String email,
    String password,
    String name,
  );

  Future<String?> login(
    String email,
    String password,
  );

  Future<bool> addUserDataToFirestore(
    UserVO userVO,
  );

  Future<UserVO?> getUserDatFromFirestore(
    String userId,
  );

  Future<bool> addContactWithUid(String senderUid, String receiverUid);
}
