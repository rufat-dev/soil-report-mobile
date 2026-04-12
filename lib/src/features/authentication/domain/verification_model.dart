import 'package:json_annotation/json_annotation.dart';

import 'enums/verification_type.dart';

part 'verification_model.g.dart';

@JsonSerializable()
class VerificationModel {
  String code;
  String? phoneNumber;
  String? smsVerificationCode;
  String? emailVerificationCode;
  VerificationType verificationType;

  VerificationModel({
      required this.code,
      required this.verificationType,
      this.phoneNumber,
      this.smsVerificationCode,
      this.emailVerificationCode
      });

  factory VerificationModel.fromJson(Map<String,dynamic> json ) => _$VerificationModelFromJson(json);

  Map<String,dynamic> toJson() => _$VerificationModelToJson(this);
}