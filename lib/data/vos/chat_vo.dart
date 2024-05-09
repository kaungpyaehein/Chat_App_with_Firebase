import 'package:chat_app/data/vos/user_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_vo.g.dart';

@JsonSerializable()
class ChatVO {
  @JsonKey(name: "chatId")
  String? chatId;

  @JsonKey(name: "chatUsers")
  List<UserVO>? chatUsers;

  @JsonKey(name: "lastMessage")
  String? lastMessage;

  @JsonKey(name: "lastMessageTime")
  String? lastMessageTime;

  factory ChatVO.fromJson(Map<String, dynamic> json) => _$ChatVOFromJson(json);
  Map<String, dynamic> toJson() => _$ChatVOToJson(this);

  ChatVO({
    this.chatId,
    this.chatUsers,
    this.lastMessage,
    this.lastMessageTime,
  });
}
