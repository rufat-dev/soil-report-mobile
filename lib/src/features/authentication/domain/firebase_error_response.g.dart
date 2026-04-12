// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseErrorResponse _$FirebaseErrorResponseFromJson(
  Map<String, dynamic> json,
) => FirebaseErrorResponse(
  error: json['error'] == null
      ? null
      : FirebaseError.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FirebaseErrorResponseToJson(
  FirebaseErrorResponse instance,
) => <String, dynamic>{'error': instance.error};

FirebaseError _$FirebaseErrorFromJson(Map<String, dynamic> json) =>
    FirebaseError(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$FirebaseErrorToJson(FirebaseError instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
