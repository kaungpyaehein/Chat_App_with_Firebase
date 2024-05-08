import 'package:json_annotation/json_annotation.dart';

part 'message_vo.g.dart';

@JsonSerializable()
class MessageVO {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "text")
  String? text;

  @JsonKey(name: "file")
  String? file;

  @JsonKey(name: "type")
  String? type;

  @JsonKey(name: "sender_name")
  String? senderName;

  @JsonKey(name: "sender_id")
  String? senderId;

  //from json
  factory MessageVO.fromJson(Map<String, dynamic> json) =>
      _$MessageVOFromJson(json);

  //to json
  Map<String, dynamic> toJson() => _$MessageVOToJson(this);

  MessageVO({
    this.id,
    this.text,
    this.file,
    this.type,
    this.senderName,
    this.senderId
  });
}
