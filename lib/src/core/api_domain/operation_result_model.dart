import 'issue_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_result_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class OperationResultModel<TModel> {
  TModel? model;
  String? name;
  final bool success;
  List<IssueModel>? issues;

  OperationResultModel( this.success);

  factory OperationResultModel.fromJson(
      Map<String, dynamic> json,
      TModel Function(Object? json) fromJsonT,
      ) => _$OperationResultModelFromJson(json, fromJsonT);


  Map<String, dynamic> toJson(Object Function(TModel value) toJsonT) => _$OperationResultModelToJson(this, toJsonT);
}