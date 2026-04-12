import 'package:json_annotation/json_annotation.dart';

part 'firebase_lookup_response.g.dart';

/// Response from Firebase Identity Toolkit:
/// POST accounts:lookup
@JsonSerializable()
class FirebaseLookupResponse {
  final List<FirebaseUserRecord>? users;

  const FirebaseLookupResponse({this.users});

  factory FirebaseLookupResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseLookupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseLookupResponseToJson(this);
}

@JsonSerializable()
class FirebaseUserRecord {
  final String? localId;
  final String? email;
  final bool? emailVerified;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final String? lastLoginAt;
  final String? createdAt;
  final String? lastRefreshAt;
  final bool? disabled;

  const FirebaseUserRecord({
    this.localId,
    this.email,
    this.emailVerified,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.lastLoginAt,
    this.createdAt,
    this.lastRefreshAt,
    this.disabled,
  });

  factory FirebaseUserRecord.fromJson(Map<String, dynamic> json) =>
      _$FirebaseUserRecordFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseUserRecordToJson(this);
}
