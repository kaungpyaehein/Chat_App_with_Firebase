import 'package:json_annotation/json_annotation.dart';

part 'error_vo.g.dart';

@JsonSerializable()
class ErrorVO {
  @JsonKey(name: "status_code")
  final int statusCode;

  @JsonKey(name: "status_message")
  final String statusMessage;

  @JsonKey(name: "success")
  final bool success;

  ErrorVO(
      {required this.statusCode,
      required this.statusMessage,
      required this.success});

  factory ErrorVO.fromJson(Map<String, dynamic> json) =>
      _$ErrorVOFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorVOToJson(this);
}
