// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueModel _$IssueModelFromJson(Map<String, dynamic> json) => IssueModel()
  ..Severity = (json['Severity'] as num?)?.toInt()
  ..code = json['code'] as String?
  ..exception = json['exception']
  ..message = json['message'] == null
      ? null
      : MessageModel.fromJson(json['message'] as Map<String, dynamic>);

Map<String, dynamic> _$IssueModelToJson(IssueModel instance) =>
    <String, dynamic>{
      'Severity': instance.Severity,
      'code': instance.code,
      'exception': instance.exception,
      'message': instance.message,
    };
