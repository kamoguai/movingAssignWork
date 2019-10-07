import 'package:json_annotation/json_annotation.dart';

part 'SsoLogin.g.dart';

@JsonSerializable()
class Sso {
  String retCode; // 回傳code
  String retMSG; // 回傳msg
  String ssoKey; // 取得ssokey
  String serverURL; // 回傳系統url
  String blankURL; // 回傳無效app
  String deptName; // 使用單位
  String accName; // 使用者名

  Sso(
    this.retCode,
    this.retMSG,
    this.ssoKey,
    this.serverURL,
    this.blankURL,
    this.deptName,
    this.accName
  );
   // 反序列化
   factory Sso.fromJson(Map<String, dynamic> json) => _$SsoFromJson(json);
   // 序列化
   Map<String, dynamic> toJson() => _$SsoToJson(this);

   // 命名構造函數
   Sso.empty();
}

