import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'enums/client_type.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {

  final String? name;
  final String? surname;
  final String? fatherName;
  final String? phoneNumber;
  final String pin;
  final String? fullName;
  final String? guid;
  final DateTime? birthDate;
  final String? email;
  final bool isNewClient;
  final ClientType clientType;
  final String? idSeries;
  final String? idNumber;
  @override
  List<Object> get props => [pin];

  const UserModel(
      this.name,
      this.surname,
      this.fatherName,
      this.phoneNumber,
      this.pin,
      this.fullName,
      this.guid,
      this.birthDate,
      this.email,
      this.isNewClient,
      this.clientType,
      this.idSeries,
      this.idNumber,
      );

  factory UserModel.fromJson(Map<String,dynamic> json ) => _$UserModelFromJson(json);

  Map<String,dynamic> toJson() => _$UserModelToJson(this);

  static const empty = UserModel("","", "","","","","", null ,"", true, ClientType.physicalPersonCode, "", "");

}