// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_send_oob_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseSendOobCodeRequest _$FirebaseSendOobCodeRequestFromJson(
  Map<String, dynamic> json,
) => FirebaseSendOobCodeRequest(
  requestType: json['requestType'] as String,
  idToken: json['idToken'] as String,
);

Map<String, dynamic> _$FirebaseSendOobCodeRequestToJson(
  FirebaseSendOobCodeRequest instance,
) => <String, dynamic>{
  'requestType': instance.requestType,
  'idToken': instance.idToken,
};
