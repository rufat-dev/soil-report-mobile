// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_admin_panel_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileAdminPanelResponseModel _$MobileAdminPanelResponseModelFromJson(
  Map<String, dynamic> json,
) => MobileAdminPanelResponseModel(
  token: json['token'] as String?,
  succeeded: json['succeeded'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$MobileAdminPanelResponseModelToJson(
  MobileAdminPanelResponseModel instance,
) => <String, dynamic>{
  'token': instance.token,
  'succeeded': instance.succeeded,
  'message': instance.message,
};
