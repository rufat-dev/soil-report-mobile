import 'package:json_annotation/json_annotation.dart';

import '../../../constants/default_values.dart';

part 'login_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class LoginModel{
  String pin;
  String? phoneNumber;
  String? password;
  String language;
  String? isAsanLogin;

  LoginModel({
      required this.pin,
      this.phoneNumber,
      this.password,
      this.language = DefaultValues.defaultLanguage,
      this.isAsanLogin});

  factory LoginModel.fromJson(Map<String,dynamic> json ) => _$LoginModelFromJson(json);
  Map<String,dynamic> toJson() => _$LoginModelToJson(this);

}
