// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationResultModel<TModel> _$OperationResultModelFromJson<TModel>(
  Map<String, dynamic> json,
  TModel Function(Object? json) fromJsonTModel,
) => OperationResultModel<TModel>(json['success'] as bool)
  ..model = _$nullableGenericFromJson(json['model'], fromJsonTModel)
  ..name = json['name'] as String?
  ..issues = (json['issues'] as List<dynamic>?)
      ?.map((e) => IssueModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$OperationResultModelToJson<TModel>(
  OperationResultModel<TModel> instance,
  Object? Function(TModel value) toJsonTModel,
) => <String, dynamic>{
  'model': _$nullableGenericToJson(instance.model, toJsonTModel),
  'name': instance.name,
  'success': instance.success,
  'issues': instance.issues,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);
