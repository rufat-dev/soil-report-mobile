import 'package:json_annotation/json_annotation.dart';

import 'message_model.dart';

part 'issue_model.g.dart';

@JsonSerializable()
class IssueModel {
  int? Severity;
  String? code;
  Object? exception;
  MessageModel? message;

  IssueModel(){
  }


  factory IssueModel.fromJson(Map<String,dynamic> json ) => _$IssueModelFromJson(json);

  Map<String,dynamic> toJson() => _$IssueModelToJson(this);
}