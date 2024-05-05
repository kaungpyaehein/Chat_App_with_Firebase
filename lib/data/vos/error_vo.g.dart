// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorVO _$ErrorVOFromJson(Map<String, dynamic> json) => ErrorVO(
      statusCode: (json['status_code'] as num).toInt(),
      statusMessage: json['status_message'] as String,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$ErrorVOToJson(ErrorVO instance) => <String, dynamic>{
      'status_code': instance.statusCode,
      'status_message': instance.statusMessage,
      'success': instance.success,
    };
