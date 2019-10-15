// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    json['accNo'] as String,
    json['deptCD'] as String,
    json['deptName'] as String,
    json['empName'] as String,
    json['caseDeptCD'] as String,
    json['showPerformanceAllDept'] as bool,
    json['emp'] as bool,
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'accNo': instance.accNo,
      'deptCD': instance.deptCD,
      'deptName': instance.deptName,
      'empName': instance.empName,
      'caseDeptCD': instance.caseDeptCD,
      'showPerformanceAllDept': instance.showPerformanceAllDept,
      'emp': instance.emp,
    };
