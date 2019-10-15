import 'package:json_annotation/json_annotation.dart';

part 'UserInfo.g.dart';
///
///使用者信息model
///Date: 2019-10-04
///
@JsonSerializable()
class UserInfo {
  
  String accNo;
  String deptCD;
  String deptName;
  String empName;
  String caseDeptCD;
  bool showPerformanceAllDept;
  bool emp;

  UserInfo(
    this.accNo,
    this.deptCD,
    this.deptName,
    this.empName,
    this.caseDeptCD,
    this.showPerformanceAllDept,
    this.emp
  );

  // 反序列化, 因資料字首是大寫，所以要手動把小寫轉大寫
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  // 命名構造函數
  UserInfo.empty();
}
