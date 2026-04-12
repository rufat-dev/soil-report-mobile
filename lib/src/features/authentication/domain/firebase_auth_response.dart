import 'package:json_annotation/json_annotation.dart';

part 'firebase_auth_response.g.dart';

/// Response from Firebase Identity Toolkit:
/// - POST accounts:signInWithPassword → `identitytoolkit#VerifyPasswordResponse`
/// - POST accounts:signUp → `identitytoolkit#SignupNewUserResponse`
@JsonSerializable()
class FirebaseAuthResponse {
  /// e.g. `identitytoolkit#VerifyPasswordResponse` or `identitytoolkit#SignupNewUserResponse`
  final String? kind;
  final String? localId;
  final String? email;
  final String? displayName;
  final String? idToken;
  final String? refreshToken;
  final String? expiresIn;
  final bool? registered;

  const FirebaseAuthResponse({
    this.kind,
    this.localId,
    this.email,
    this.displayName,
    this.idToken,
    this.refreshToken,
    this.expiresIn,
    this.registered,
  });

  factory FirebaseAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseAuthResponseToJson(this);
}
