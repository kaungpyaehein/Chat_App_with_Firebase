import 'package:chat_app/data/vos/chat_vo.dart';

import '../../data/vos/message_vo.dart';
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

  Future<List<UserVO>> getChatListById(String currentUserId);

  Future<MessageVO?> getLastMessageByIds(String chatId, String currentUserId);
}
