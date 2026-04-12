// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationModel _$VerificationModelFromJson(Map<String, dynamic> json) =>
    VerificationModel(
      code: json['code'] as String,
      verificationType: $enumDecode(
        _$VerificationTypeEnumMap,
        json['verificationType'],
      ),
      phoneNumber: json['phoneNumber'] as String?,
      smsVerificationCode: json['smsVerificationCode'] as String?,
      emailVerificationCode: json['emailVerificationCode'] as String?,
    );

Map<String, dynamic> _$VerificationModelToJson(VerificationModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'phoneNumber': instance.phoneNumber,
      'smsVerificationCode': instance.smsVerificationCode,
      'emailVerificationCode': instance.emailVerificationCode,
      'verificationType': _$VerificationTypeEnumMap[instance.verificationType]!,
    };

const _$VerificationTypeEnumMap = {
  VerificationType.sms: 1,
  VerificationType.email: 2,
  VerificationType.both: 3,
};
