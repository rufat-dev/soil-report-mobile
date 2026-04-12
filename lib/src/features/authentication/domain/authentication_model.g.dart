// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationModel _$AuthenticationModelFromJson(Map<String, dynamic> json) =>
    AuthenticationModel()
      ..pin = json['pin'] as String?
      ..tin = json['tin'] as String?
      ..isNewClient = json['isNewClient'] as bool?
      ..clientType = json['clientType'] as bool?
      ..isValidPin = json['isValidPin'] as bool?;

Map<String, dynamic> _$AuthenticationModelToJson(
  AuthenticationModel instance,
) => <String, dynamic>{
  'pin': instance.pin,
  'tin': instance.tin,
  'isNewClient': instance.isNewClient,
  'clientType': instance.clientType,
  'isValidPin': instance.isValidPin,
};
