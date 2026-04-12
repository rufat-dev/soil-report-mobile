import 'package:json_annotation/json_annotation.dart';

enum VerificationType {
  @JsonValue(1)
  sms,
  @JsonValue(2)
  email,
  @JsonValue(3)
  both
}