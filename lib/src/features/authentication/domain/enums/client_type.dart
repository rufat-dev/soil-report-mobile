import 'package:json_annotation/json_annotation.dart';

enum ClientType {
  @JsonValue(1)
  physicalPersonCode,
  @JsonValue(2)
  legalPersonCode }