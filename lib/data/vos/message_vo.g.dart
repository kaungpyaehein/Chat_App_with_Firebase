// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageVOAdapter extends TypeAdapter<MessageVO> {
  @override
  final int typeId = 1;

  @override
  MessageVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageVO();
  }

  @override
  void write(BinaryWriter writer, MessageVO obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
