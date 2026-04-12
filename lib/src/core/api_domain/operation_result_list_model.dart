import 'dart:convert';
import 'issue_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_result_list_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class OperationResultListModel<TModel>{
  List<TModel>? model;
  String? name;
  final bool success;
  List<IssueModel>? issues;

  OperationResultListModel(this.success);


  Map<String, dynamic> toJson(Object Function(TModel value) toJsonT) => _$OperationResultListModelToJson(this, toJsonT);

  factory OperationResultListModel.fromJson(
      Map<String, dynamic> json,
      TModel Function(Object? json) fromJsonT,
      ) => _$OperationResultListModelFromJson(json, fromJsonT);

}