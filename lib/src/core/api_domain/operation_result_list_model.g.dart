// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_result_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationResultListModel<TModel> _$OperationResultListModelFromJson<TModel>(
  Map<String, dynamic> json,
  TModel Function(Object? json) fromJsonTModel,
) => OperationResultListModel<TModel>(json['success'] as bool)
  ..model = (json['model'] as List<dynamic>?)?.map(fromJsonTModel).toList()
  ..name = json['name'] as String?
  ..issues = (json['issues'] as List<dynamic>?)
      ?.map((e) => IssueModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$OperationResultListModelToJson<TModel>(
  OperationResultListModel<TModel> instance,
  Object? Function(TModel value) toJsonTModel,
) => <String, dynamic>{
  'model': instance.model?.map(toJsonTModel).toList(),
  'name': instance.name,
  'success': instance.success,
  'issues': instance.issues,
};
