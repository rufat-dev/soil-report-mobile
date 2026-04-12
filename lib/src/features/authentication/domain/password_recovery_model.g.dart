// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_recovery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordRecoveryModel _$PasswordRecoveryModelFromJson(
  Map<String, dynamic> json,
) => PasswordRecoveryModel(
  pin: json['pin'] as String,
  password: json['password'] as String,
  rePassword: json['rePassword'] as String?,
  language: json['language'] as String?,
  referalCode: json['referalCode'] as String?,
);

Map<String, dynamic> _$PasswordRecoveryModelToJson(
  PasswordRecoveryModel instance,
) => <String, dynamic>{
  'pin': instance.pin,
  'password': instance.password,
  'rePassword': instance.rePassword,
  'referalCode': instance.referalCode,
  'language': instance.language,
};
