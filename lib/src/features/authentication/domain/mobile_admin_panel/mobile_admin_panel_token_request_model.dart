import 'package:json_annotation/json_annotation.dart';
import 'mobile_admin_panel_response_model.dart';

part 'mobile_admin_panel_token_request_model.g.dart';

@JsonSerializable()
class MobileAdminPanelTokenRequestModel extends MobileAdminPanelResponseModel {
  final String? username;
  final String? password;

  MobileAdminPanelTokenRequestModel({
    this.username,
    this.password,
    super.token,
    super.succeeded,
    super.message,
  });

  factory MobileAdminPanelTokenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$MobileAdminPanelTokenRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MobileAdminPanelTokenRequestModelToJson(this);
}
