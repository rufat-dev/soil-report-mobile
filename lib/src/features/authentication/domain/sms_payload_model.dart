import 'package:json_annotation/json_annotation.dart';

part 'sms_payload_model.g.dart';

@JsonSerializable()
class SmsPayloadModel {
  String? code;
  String phoneNumber;

  SmsPayloadModel(this.code, this.phoneNumber);

  factory SmsPayloadModel.fromJson(Map<String,dynamic> json ) => _$SmsPayloadModelFromJson(json);

  Map<String,dynamic> toJson() => _$SmsPayloadModelToJson(this);
}