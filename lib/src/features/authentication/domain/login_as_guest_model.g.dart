// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_as_guest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginAsGuestModel _$LoginAsGuestModelFromJson(Map<String, dynamic> json) =>
    LoginAsGuestModel(
      parameters: json['parameters'] as Map<String, dynamic>,
      reason: $enumDecode(_$LoginAsGuestTypeEnumMap, json['reason']),
      source: $enumDecode(_$RequestSourceTypeEnumMap, json['source']),
    );

Map<String, dynamic> _$LoginAsGuestModelToJson(LoginAsGuestModel instance) =>
    <String, dynamic>{
      'parameters': instance.parameters,
      'reason': _$LoginAsGuestTypeEnumMap[instance.reason]!,
      'source': _$RequestSourceTypeEnumMap[instance.source]!,
    };

const _$LoginAsGuestTypeEnumMap = {
  LoginAsGuestType.claimPictureUpload: 1001,
  LoginAsGuestType.surveyPictureUpload: 1002,
};

const _$RequestSourceTypeEnumMap = {RequestSourceType.mobile: 101};
