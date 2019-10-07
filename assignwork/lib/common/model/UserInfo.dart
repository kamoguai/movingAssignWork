import 'package:json_annotation/json_annotation.dart';

part 'UserInfo.g.dart';
///
///使用者信息model
///Date: 2019-06-04
///
@JsonSerializable()
class UserInfo {
  UserData userData;
  AuthorityData authorityData;
  UserInfo(
    this.userData,
    this.authorityData
  );
   // 反序列化, 因資料字首是大寫，所以要手動把小寫轉大寫
   factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
   // 序列化
   Map<String, dynamic> toJson() => _$UserInfoToJson(this);

   // 命名構造函數
   UserInfo.empty();
}
@JsonSerializable()
class UserData {
  String Account; // 帳號
  String UserID; // 使用者流水號
  String UserName; // 使用者名
  String DeptID; // 部門id
  String DeptName; // 部門名
  String Position; // 
  String DeviceType; // 使用裝置
  String DeviceID; // 裝置id
  UserData(
    this.Account,
    this.UserID,
    this.UserName,
    this.DeptID,
    this.DeptName,
    this.Position,
    this.DeviceType,
    this.DeviceID,
  );
  // 反序列化
  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  // 命名構造函數
  UserData.empty();
}
@JsonSerializable()
class AuthorityData {
  String CreateCase; // 建立case權限
  String AssignDept; // 指派部門權限
  String AssignEmpl; // 指派員工權限
  String Maint; // 
  String DPMaint; //
  String DeptClose; // 部門關閉權限
  String File; // 檔案權限
  String AreaBug; // 區障權限
  AuthorityData(
    this.CreateCase,
    this.AssignDept,
    this.AssignEmpl,
    this.Maint,
    this.DPMaint,
    this.DeptClose,
    this.File,
    this.AreaBug,
  );
  // 反序列化
  factory AuthorityData.fromJson(Map<String, dynamic> json) => _$AuthorityDataFromJson(json);
  // 序列化
  Map<String, dynamic> toJson() => _$AuthorityDataToJson(this);

  // 命名構造函數
  AuthorityData.empty();
}