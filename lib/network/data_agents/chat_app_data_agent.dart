import '../../data/vos/user_vo.dart';

abstract class ChatAppDataAgent {
  Future<UserVO> register(
    String email,
    String password,
    String name,
  );
  Future<UserVO> login(
    String email,
    String password,
  );
  Stream<List<UserVO>> getContactsDataStream(String uid);

  Future exchangeContactsWithUids(
    String senderUid,
    String receiverUid,
  );

  Future<UserVO> getUserDataAndContactsFromFirestore(String uid);


}
