// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseAuthResponse _$FirebaseAuthResponseFromJson(
  Map<String, dynamic> json,
) => FirebaseAuthResponse(
  kind: json['kind'] as String?,
  localId: json['localId'] as String?,
  email: json['email'] as String?,
  displayName: json['displayName'] as String?,
  idToken: json['idToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
  expiresIn: json['expiresIn'] as String?,
  registered: json['registered'] as bool?,
);

Map<String, dynamic> _$FirebaseAuthResponseToJson(
  FirebaseAuthResponse instance,
) => <String, dynamic>{
  'kind': instance.kind,
  'localId': instance.localId,
  'email': instance.email,
  'displayName': instance.displayName,
  'idToken': instance.idToken,
  'refreshToken': instance.refreshToken,
  'expiresIn': instance.expiresIn,
  'registered': instance.registered,
};
