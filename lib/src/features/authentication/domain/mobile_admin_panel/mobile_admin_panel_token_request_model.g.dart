// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_admin_panel_token_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileAdminPanelTokenRequestModel _$MobileAdminPanelTokenRequestModelFromJson(
  Map<String, dynamic> json,
) => MobileAdminPanelTokenRequestModel(
  username: json['username'] as String?,
  password: json['password'] as String?,
  token: json['token'] as String?,
  succeeded: json['succeeded'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$MobileAdminPanelTokenRequestModelToJson(
  MobileAdminPanelTokenRequestModel instance,
) => <String, dynamic>{
  'token': instance.token,
  'succeeded': instance.succeeded,
  'message': instance.message,
  'username': instance.username,
  'password': instance.password,
};
