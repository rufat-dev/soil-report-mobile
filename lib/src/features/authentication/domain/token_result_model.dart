import 'package:json_annotation/json_annotation.dart';

part 'token_result_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class TokenResultModel {
  String accessToken;

  TokenResultModel(
      this.accessToken,);

  factory TokenResultModel.fromJson(Map<String,dynamic> json ) => _$TokenResultModelFromJson(json);

  Map<String,dynamic> toJson() => _$TokenResultModelToJson(this);

}