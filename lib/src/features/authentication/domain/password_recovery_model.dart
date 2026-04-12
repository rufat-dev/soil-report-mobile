import 'package:json_annotation/json_annotation.dart';

part 'password_recovery_model.g.dart';

@JsonSerializable()
class PasswordRecoveryModel {
  String pin;
  String password;
  String? rePassword;
  String? referalCode;
  String? language;

  PasswordRecoveryModel({
      required this.pin,
      required this.password,
      required this.rePassword,
      this.language,
      this.referalCode});

  factory PasswordRecoveryModel.fromJson(Map<String,dynamic> json ) => _$PasswordRecoveryModelFromJson(json);

  Map<String,dynamic> toJson() => _$PasswordRecoveryModelToJson(this);
}