import 'package:json_annotation/json_annotation.dart';

part 'bootstrap_user_request.g.dart';

/// Request body for Soil Report backend: POST /auth/bootstrap
@JsonSerializable()
class BootstrapUserRequest {
  final String fullName;
  final String phoneNumber;

  const BootstrapUserRequest({
    required this.fullName,
    required this.phoneNumber,
  });

  factory BootstrapUserRequest.fromJson(Map<String, dynamic> json) =>
      _$BootstrapUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BootstrapUserRequestToJson(this);
}
