// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_lookup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseLookupResponse _$FirebaseLookupResponseFromJson(
  Map<String, dynamic> json,
) => FirebaseLookupResponse(
  users: (json['users'] as List<dynamic>?)
      ?.map((e) => FirebaseUserRecord.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FirebaseLookupResponseToJson(
  FirebaseLookupResponse instance,
) => <String, dynamic>{'users': instance.users};

FirebaseUserRecord _$FirebaseUserRecordFromJson(Map<String, dynamic> json) =>
    FirebaseUserRecord(
      localId: json['localId'] as String?,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      displayName: json['displayName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      lastLoginAt: json['lastLoginAt'] as String?,
      createdAt: json['createdAt'] as String?,
      lastRefreshAt: json['lastRefreshAt'] as String?,
      disabled: json['disabled'] as bool?,
    );

Map<String, dynamic> _$FirebaseUserRecordToJson(FirebaseUserRecord instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'displayName': instance.displayName,
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
      'lastLoginAt': instance.lastLoginAt,
      'createdAt': instance.createdAt,
      'lastRefreshAt': instance.lastRefreshAt,
      'disabled': instance.disabled,
    };
