// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  json['name'] as String?,
  json['surname'] as String?,
  json['fatherName'] as String?,
  json['phoneNumber'] as String?,
  json['pin'] as String,
  json['fullName'] as String?,
  json['guid'] as String?,
  json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  json['email'] as String?,
  json['isNewClient'] as bool,
  $enumDecode(_$ClientTypeEnumMap, json['clientType']),
  json['idSeries'] as String?,
  json['idNumber'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'name': instance.name,
  'surname': instance.surname,
  'fatherName': instance.fatherName,
  'phoneNumber': instance.phoneNumber,
  'pin': instance.pin,
  'fullName': instance.fullName,
  'guid': instance.guid,
  'birthDate': instance.birthDate?.toIso8601String(),
  'email': instance.email,
  'isNewClient': instance.isNewClient,
  'clientType': _$ClientTypeEnumMap[instance.clientType]!,
  'idSeries': instance.idSeries,
  'idNumber': instance.idNumber,
};

const _$ClientTypeEnumMap = {
  ClientType.physicalPersonCode: 1,
  ClientType.legalPersonCode: 2,
};
