import 'package:json_annotation/json_annotation.dart';

part 'firebase_send_oob_code_request.g.dart';

/// Request body for Firebase Identity Toolkit: POST accounts:sendOobCode
@JsonSerializable()
class FirebaseSendOobCodeRequest {
  final String requestType;
  final String idToken;

  const FirebaseSendOobCodeRequest({
    required this.requestType,
    required this.idToken,
  });

  factory FirebaseSendOobCodeRequest.verifyEmail(String idToken) =>
      FirebaseSendOobCodeRequest(requestType: 'VERIFY_EMAIL', idToken: idToken);

  factory FirebaseSendOobCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$FirebaseSendOobCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseSendOobCodeRequestToJson(this);
}
