import 'package:json_annotation/json_annotation.dart';

part 'firebase_lookup_request.g.dart';

/// Request body for Firebase Identity Toolkit: POST accounts:lookup
@JsonSerializable()
class FirebaseLookupRequest {
  final String idToken;

  const FirebaseLookupRequest({required this.idToken});

  factory FirebaseLookupRequest.fromJson(Map<String, dynamic> json) =>
      _$FirebaseLookupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseLookupRequestToJson(this);
}
