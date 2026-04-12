// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_payload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmsPayloadModel _$SmsPayloadModelFromJson(Map<String, dynamic> json) =>
    SmsPayloadModel(json['code'] as String?, json['phoneNumber'] as String);

Map<String, dynamic> _$SmsPayloadModelToJson(SmsPayloadModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'phoneNumber': instance.phoneNumber,
    };
