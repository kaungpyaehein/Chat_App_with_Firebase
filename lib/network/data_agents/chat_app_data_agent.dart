import '../../data/vos/user_vo.dart';

abstract class ChatAppDataAgent {
  Future<UserVO?> register(
    String email,
    String password,
    String name,
  );
  Future<UserVO?> login(
    String email,
    String password,
  );
}
