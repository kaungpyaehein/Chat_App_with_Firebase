// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatVO _$ChatVOFromJson(Map<String, dynamic> json) => ChatVO(
      chatId: json['chatId'] as String?,
      chatUsers: (json['chatUsers'] as List<dynamic>?)
          ?.map((e) => UserVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] as String?,
      lastMessageTime: json['lastMessageTime'] as String?,
    );

Map<String, dynamic> _$ChatVOToJson(ChatVO instance) => <String, dynamic>{
      'chatId': instance.chatId,
      'chatUsers': instance.chatUsers,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime,
    };
