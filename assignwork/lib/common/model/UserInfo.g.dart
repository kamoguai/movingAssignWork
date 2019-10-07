// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
      json['UserData'] == null
          ? null
          : UserData.fromJson(json['UserData'] as Map<String, dynamic>),
      json['AuthorityData'] == null
          ? null
          : AuthorityData.fromJson(
              json['AuthorityData'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'UserData': instance.userData,
      'AuthorityData': instance.authorityData
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
      json['Account'] as String,
      json['UserID'] as String,
      json['UserName'] as String,
      json['DeptID'] as String,
      json['DeptName'] as String,
      json['Position'] as String,
      json['DeviceType'] as String,
      json['DeviceID'] as String);
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'Account': instance.Account,
      'UserID': instance.UserID,
      'UserName': instance.UserName,
      'DeptID': instance.DeptID,
      'DeptName': instance.DeptName,
      'Position': instance.Position,
      'DeviceType': instance.DeviceType,
      'DeviceID': instance.DeviceID
    };

AuthorityData _$AuthorityDataFromJson(Map<String, dynamic> json) {
  return AuthorityData(
      json['CreateCase'] as String,
      json['AssignDept'] as String,
      json['AssignEmpl'] as String,
      json['Maint'] as String,
      json['DPMaint'] as String,
      json['DeptClose'] as String,
      json['File'] as String,
      json['AreaBug'] as String);
}

Map<String, dynamic> _$AuthorityDataToJson(AuthorityData instance) =>
    <String, dynamic>{
      'CreateCase': instance.CreateCase,
      'AssignDept': instance.AssignDept,
      'AssignEmpl': instance.AssignEmpl,
      'Maint': instance.Maint,
      'DPMaint': instance.DPMaint,
      'DeptClose': instance.DeptClose,
      'File': instance.File,
      'AreaBug': instance.AreaBug
    };
