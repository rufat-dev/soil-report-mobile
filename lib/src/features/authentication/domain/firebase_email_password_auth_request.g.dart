// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_email_password_auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseEmailPasswordAuthRequest _$FirebaseEmailPasswordAuthRequestFromJson(
  Map<String, dynamic> json,
) => FirebaseEmailPasswordAuthRequest(
  email: json['email'] as String,
  password: json['password'] as String,
  returnSecureToken: json['returnSecureToken'] as bool? ?? true,
);

Map<String, dynamic> _$FirebaseEmailPasswordAuthRequestToJson(
  FirebaseEmailPasswordAuthRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'returnSecureToken': instance.returnSecureToken,
};
