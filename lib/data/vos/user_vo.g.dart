// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      name: json['name'] as String?,
      email: json['email'] as String?,
      id: json['id'] as String?,
      fcmToken: json['fcmToken'] as String?,
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => UserVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'id': instance.id,
      'fcmToken': instance.fcmToken,
      'contacts': instance.contacts,
    };
