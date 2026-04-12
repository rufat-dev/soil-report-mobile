// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) => LoginModel(
  pin: json['pin'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  password: json['password'] as String?,
  language: json['language'] as String? ?? DefaultValues.defaultLanguage,
  isAsanLogin: json['isAsanLogin'] as String?,
);

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'pin': instance.pin,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'language': instance.language,
      'isAsanLogin': instance.isAsanLogin,
    };
