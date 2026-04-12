import 'package:json_annotation/json_annotation.dart';

part 'bootstrap_response_model.g.dart';

/// Response from Soil Report backend: POST /auth/bootstrap
@JsonSerializable(explicitToJson: true)
class BootstrapResponseModel {
  @JsonKey(name: 'is_new_user')
  final bool isNewUser;
  final BootstrapUserModel? user;

  const BootstrapResponseModel({
    required this.isNewUser,
    this.user,
  });

  factory BootstrapResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BootstrapResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BootstrapResponseModelToJson(this);
}

@JsonSerializable()
class BootstrapUserModel {
  @JsonKey(name: 'user_id')
  final String? userId;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'full_name')
  final String? fullName;
  final int? role;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const BootstrapUserModel({
    this.userId,
    this.email,
    this.phoneNumber,
    this.fullName,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory BootstrapUserModel.fromJson(Map<String, dynamic> json) =>
      _$BootstrapUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$BootstrapUserModelToJson(this);
}
