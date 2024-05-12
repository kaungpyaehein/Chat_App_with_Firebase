import 'package:chat_app/persistence/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: kHiveTypeMessageVO, adapterName: kAdapterNameMessageVO)
class MessageVO {
  @JsonKey(name: "id")
  @HiveType(typeId: 0)
  String? id;

  @JsonKey(name: "text")
  @HiveType(typeId: 1)
  String? text;

  @JsonKey(name: "file")
  @HiveType(typeId: 2)
  String? file;

  @JsonKey(name: "type")
  @HiveType(typeId: 3)
  String? type;

  @JsonKey(name: "sender_name")
  @HiveType(typeId: 4)
  String? senderName;

  @JsonKey(name: "sender_id")
  @HiveType(typeId: 5)
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

  String getFormattedTime() {
    DateTime lastMessageDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(id ?? "0"));
    return DateFormat("hh:mm a").format(lastMessageDateTime);
  }

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
