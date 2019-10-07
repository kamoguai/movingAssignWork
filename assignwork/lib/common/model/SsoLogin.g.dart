// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SsoLogin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sso _$SsoFromJson(Map<String, dynamic> json) {
  return Sso(
      json['retCode'] as String,
      json['retMSG'] as String,
      json['ssoKey'] as String,
      json['serverURL'] as String,
      json['blankURL'] as String,
      json['deptName'] as String,
      json['accName'] as String);
}

Map<String, dynamic> _$SsoToJson(Sso instance) => <String, dynamic>{
      'retCode': instance.retCode,
      'retMSG': instance.retMSG,
      'ssoKey': instance.ssoKey,
      'serverURL': instance.serverURL,
      'blankURL': instance.blankURL,
      'deptName': instance.deptName,
      'accName': instance.accName
    };
