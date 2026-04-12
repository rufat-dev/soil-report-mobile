import 'package:json_annotation/json_annotation.dart';

part 'firebase_email_password_auth_request.g.dart';

/// Request body for Firebase Identity Toolkit:
/// - POST accounts:signInWithPassword
/// - POST accounts:signUp
@JsonSerializable()
class FirebaseEmailPasswordAuthRequest {
  final String email;
  final String password;
  final bool returnSecureToken;

  const FirebaseEmailPasswordAuthRequest({
    required this.email,
    required this.password,
    this.returnSecureToken = true,
  });

  factory FirebaseEmailPasswordAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$FirebaseEmailPasswordAuthRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseEmailPasswordAuthRequestToJson(this);
}
