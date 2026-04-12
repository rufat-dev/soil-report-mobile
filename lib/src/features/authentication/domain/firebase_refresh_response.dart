import 'package:json_annotation/json_annotation.dart';

part 'firebase_refresh_response.g.dart';

/// Response from Firebase Secure Token API:
/// POST securetoken.googleapis.com/v1/token
@JsonSerializable(fieldRename: FieldRename.snake)
class FirebaseRefreshResponse {
  final String? accessToken;
  final String? expiresIn;
  final String? tokenType;
  final String? refreshToken;
  final String? idToken;
  final String? userId;
  final String? projectId;

  const FirebaseRefreshResponse({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.refreshToken,
    this.idToken,
    this.userId,
    this.projectId,
  });

  factory FirebaseRefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseRefreshResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseRefreshResponseToJson(this);
}
