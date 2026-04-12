import 'package:json_annotation/json_annotation.dart';

part 'login_as_guest_model.g.dart';

@JsonSerializable()
class LoginAsGuestModel {
  LoginAsGuestModel({
    required this.parameters,
    required this.reason,
    required this.source,
  });
  final Map<String, dynamic> parameters;
  final LoginAsGuestType reason;
  final RequestSourceType source;

  factory LoginAsGuestModel.fromJson(Map<String,dynamic> json) => _$LoginAsGuestModelFromJson(json);
  Map<String,dynamic> toJson() => _$LoginAsGuestModelToJson(this);
}
  
enum LoginAsGuestType {
  @JsonValue(1001)
  claimPictureUpload,
  @JsonValue(1002)
  surveyPictureUpload,
}

enum RequestSourceType {
  @JsonValue(101)
  mobile,
}