import 'package:json_annotation/json_annotation.dart';

part 'firebase_error_response.g.dart';

/// Error response shape returned by Firebase REST APIs.
@JsonSerializable()
class FirebaseErrorResponse {
  final FirebaseError? error;

  const FirebaseErrorResponse({this.error});

  factory FirebaseErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseErrorResponseFromJson(json);

  String get message => error?.message ?? 'Unknown Firebase error';
}

@JsonSerializable()
class FirebaseError {
  final int? code;
  final String? message;

  const FirebaseError({this.code, this.message});

  factory FirebaseError.fromJson(Map<String, dynamic> json) =>
      _$FirebaseErrorFromJson(json);
}
