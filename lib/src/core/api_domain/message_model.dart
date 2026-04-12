import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String? text;
  Object? objectMap;

  MessageModel(){
  }

  factory MessageModel.fromJson(Map<String,dynamic> json ) => _$MessageModelFromJson(json);

  Map<String,dynamic> toJson() => _$MessageModelToJson(this);
}