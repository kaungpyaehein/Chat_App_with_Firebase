import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../persistence/hive_constants.dart';
part 'user_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: kHiveTypeUserVO, adapterName: kAdapterNameUserVO)
class UserVO {
  @HiveField(0)
  @JsonKey(name: "name")
  String name;

  @HiveField(1)
  @JsonKey(name: "email")
  String email;

  @HiveField(2)
  @JsonKey(name: "id")
  String id;

  @HiveField(3)
  @JsonKey(name: "fcmToken")
  String? fcmToken;

  @HiveField(4)
  @JsonKey(name: "contacts")
  List<UserVO>? contacts;

  @HiveField(5)
  @JsonKey(name: "profile_image")
  String? profileImage;

  UserVO copyWith({
    String? name,
    String? email,
    String? id,
    String? fcmToken,
    List<UserVO>? contacts,
    String? profileImage,
  }) {
    return UserVO(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      fcmToken: fcmToken ?? this.fcmToken,
      contacts: contacts ?? this.contacts,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  String getInitialLetters() {
    List<String> names = name.split(" ");
    String initials = "";
    for (int i = 0; i < names.length; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }
    return initials;
  }

  //from json
  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  //to json
  Map<String, dynamic> toJson() => _$UserVOToJson(this);

  UserVO(
      {required this.name,
      required this.email,
      required this.id,
      this.fcmToken,
      this.contacts,
      this.profileImage});
}
