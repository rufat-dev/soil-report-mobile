import 'package:json_annotation/json_annotation.dart';

enum PhoneVerificationStatus {
  @JsonValue(0)
  incorrectNumber,
  @JsonValue(1)
  validNumber,
  @JsonValue(2)
  apiSuccess,
  @JsonValue(3)
  apiError
}