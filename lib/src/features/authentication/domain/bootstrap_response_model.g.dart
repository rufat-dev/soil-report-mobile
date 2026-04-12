// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bootstrap_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BootstrapResponseModel _$BootstrapResponseModelFromJson(
  Map<String, dynamic> json,
) => BootstrapResponseModel(
  isNewUser: json['is_new_user'] as bool,
  user: json['user'] == null
      ? null
      : BootstrapUserModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BootstrapResponseModelToJson(
  BootstrapResponseModel instance,
) => <String, dynamic>{
  'is_new_user': instance.isNewUser,
  'user': instance.user?.toJson(),
};

BootstrapUserModel _$BootstrapUserModelFromJson(Map<String, dynamic> json) =>
    BootstrapUserModel(
      userId: json['user_id'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      fullName: json['full_name'] as String?,
      role: (json['role'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BootstrapUserModelToJson(BootstrapUserModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'full_name': instance.fullName,
      'role': instance.role,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
