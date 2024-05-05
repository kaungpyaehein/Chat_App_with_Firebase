import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_vo.g.dart';
@JsonSerializable()
class UserVO {

  @HiveField(0)
  @JsonKey(name: "name")
  String? name;

  @HiveField(1)
  @JsonKey(name: "email")
  String? email;

  @HiveField(2)
  @JsonKey(name: "id")
  String? id;

  @HiveField(3)
  @JsonKey(name: "fcmToken")
  String? fcmToken;

  @HiveField(4)
  @JsonKey(name: "contacts")
  List<UserVO>? contacts;

  UserVO({
    this.name,
    this.email,
    this.id,
    this.fcmToken,
    this.contacts,
  });

  //from json
  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  //to json
  Map<String, dynamic> toJson() => _$UserVOToJson(this);


}
