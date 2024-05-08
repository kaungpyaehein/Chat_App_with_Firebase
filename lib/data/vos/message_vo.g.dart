// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageVO _$MessageVOFromJson(Map<String, dynamic> json) => MessageVO(
      id: json['id'] as String?,
      text: json['text'] as String?,
      file: json['file'] as String?,
      type: json['type'] as String?,
      senderName: json['sender_name'] as String?,
      senderId: json['sender_id'] as String?,
    );

Map<String, dynamic> _$MessageVOToJson(MessageVO instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'file': instance.file,
      'type': instance.type,
      'sender_name': instance.senderName,
      'sender_id': instance.senderId,
    };
