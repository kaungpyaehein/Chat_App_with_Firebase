import 'package:intl/intl.dart';
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

  MessageVO(
      {this.id,
      this.text,
      this.file,
      this.type,
      this.senderName,
      this.senderId});

  String getLastMessageTime() {
    DateTime lastMessageDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(id ?? "0"));
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (lastMessageDateTime.year == now.year &&
        lastMessageDateTime.month == now.month &&
        lastMessageDateTime.day == now.day) {
      // If it's today, show time
      return DateFormat("hh:mm a").format(lastMessageDateTime);
    } else if (lastMessageDateTime.year == yesterday.year &&
        lastMessageDateTime.month == yesterday.month &&
        lastMessageDateTime.day == yesterday.day) {
      // If it's yesterday, show "yesterday"
      return "Yesterday";
    } else {
      // If it's neither today nor yesterday, show the date
      return DateFormat("dd.M.yy").format(lastMessageDateTime);
    }
  }
}
