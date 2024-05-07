// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserVOAdapter extends TypeAdapter<UserVO> {
  @override
  final int typeId = 6;

  @override
  UserVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserVO(
      name: fields[0] as String,
      email: fields[1] as String,
      id: fields[2] as String,
      fcmToken: fields[3] as String?,
      contacts: (fields[4] as List?)?.cast<UserVO>(),
      profileImage: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserVO obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.fcmToken)
      ..writeByte(4)
      ..write(obj.contacts)
      ..writeByte(5)
      ..write(obj.profileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      name: json['name'] as String,
      email: json['email'] as String,
      id: json['id'] as String,
      fcmToken: json['fcmToken'] as String?,
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => UserVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      profileImage: json['profile_image'] as String?,
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'id': instance.id,
      'fcmToken': instance.fcmToken,
      'contacts': instance.contacts,
      'profile_image': instance.profileImage,
    };
