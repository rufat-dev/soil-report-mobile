import 'package:json_annotation/json_annotation.dart';

part 'mobile_admin_panel_response_model.g.dart';

@JsonSerializable()
class MobileAdminPanelResponseModel {
  final String? token;
  final bool? succeeded;
  final String? message;

  MobileAdminPanelResponseModel({
    this.token,
    this.succeeded,
    this.message,
  });

  factory MobileAdminPanelResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MobileAdminPanelResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MobileAdminPanelResponseModelToJson(this);
}
