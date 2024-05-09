import '../../data/vos/chat_vo.dart';
import '../../data/vos/message_vo.dart';
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

  Future<UserVO> getUserDataFromFirestore(
    String userId,
  );

  Future<bool> exchangeContactsWithUids(String senderUid, String receiverUid);

  Stream<List<UserVO>> getContactsStream(String uid);

  void sendMessage(MessageVO message, String senderId, String receiverId);

  Stream<List<MessageVO>> getMessageStream(
      String senderUid, String receiverUid);

  Future<List<String>> getChatIdList(String currentUserId);

  Future<MessageVO?> getLastMessageByChatId(
      String chatId, String currentUserId);

  Future<List<UserVO>> getChatByIds(String currentUserId, List<String> chatListId);
}
