import 'dart:convert';
import 'package:assignwork/common/utils/AesUtils.dart';
import 'package:redux/redux.dart';
import 'package:assignwork/common/local/LocalStorage.dart';
import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/net/Api.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:dio/dio.dart';
import 'package:assignwork/common/redux/UserInfoRedux.dart';
import 'package:assignwork/common/dao/DaoResult.dart';
import 'package:assignwork/common/model/UserInfo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/common/model/SsoLogin.dart';
///
///使用者信息dao
///Date: 2019-07-23
///
class UserInfoDao {

  static login(account, password, tokenId, context) async {
    // 先儲存account至手機內存
    await LocalStorage.save(Config.USER_NAME_KEY, account);
    var res = await HttpManager.netFetch(Address.ssoLoginAPI(account, password), null, null, null);
    
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("sso登入resp => " + res.data.toString());
      } 
      Sso ssoInfo = Sso.fromJson(res.data);
      await LocalStorage.save(Config.USER_ACCNAME_KEY, ssoInfo.accName);
      await LocalStorage.save(Config.USER_SSO_KEY, json.encode(ssoInfo.toJson()));
      return new DataResult(ssoInfo, true);
    }
  }

  ///初始化用戶信息
  static initUserInfo(Store store) async {
    var res = await getUserInfoLocal();
    if (res != null && res.result) {
      store.dispatch(UpdateUserAction(res.data));
    }
    return new DataResult(res.data, (res.result));
  }

   ///獲取本地登入用戶信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      UserInfo user = UserInfo.fromJson(userMap);
      return new DataResult(user, true);
    } else {
      return new DataResult(null, false);
    }
  }

  ///獲取本地sso登入用戶信息
  static getUserSSOInfoLocal() async {
    var ssoText = await LocalStorage.get(Config.USER_SSO_KEY);
    if (ssoText != null) {
      var ssoMap = json.decode(ssoText);
      Sso sso = Sso.fromJson(ssoMap);
      return new DataResult(sso, true);
    } else {
      return new DataResult(null, false);
    }
  }

  ///獲取用戶詳細信息
  // static getUserInfo(serverURL, ssoKey, account, password, deptName, accName, store) async {
    static getUserInfo(Map jsonMap, store) async {
     await LocalStorage.save(Config.PW_KEY, jsonMap["password"]);
     Map<String, dynamic> mainDataArray = {};
     Map<String, String> header = {};
     Map<String, dynamic> paramsJson = {};
     String str = jsonEncode(jsonMap);
     print("json request -> $str");
     var aesData = AesUtils.aes128Encrypt(str);
     print("aes encode => $aesData");
     var decode = AesUtils.aes128Decrypt(aesData);
     print("aes decode => $decode");
     paramsJson["data"] = aesData;
     var serverUrl = jsonMap["serverURL"];
     var reqUrl = "$serverUrl?data=$aesData";
    //  header["content-type"] = "application/x-www-form-urlencoded";
    // header = null;
     var res = await HttpManager.netFetch(reqUrl, null, null, null);
     if (res != null && res.result) {
        if (Config.DEBUG) {
          print("派裝系統使用者信息resp => "+ res.data.toString());
        }
        if (res.data['retCode'] == "00") {
          mainDataArray = res.data;
          ///dart在map添加key,value寫法，如果不存在就添加key,如果存在就給key值
          mainDataArray.putIfAbsent("accNo", () => jsonMap["account"]);
          mainDataArray.putIfAbsent("deptName", () => jsonMap["deptName"]);
          mainDataArray.putIfAbsent("accName", () => jsonMap["accName"]);
        }
        if (mainDataArray.length > 0 ) {
          print("使用者資訊-> $mainDataArray");
          UserInfo userInfo = UserInfo.fromJson(mainDataArray);
          LocalStorage.save(Config.USER_INFO, json.encode(userInfo.toJson()));
          
          store.dispatch(new UpdateUserAction(userInfo));
          return new DataResult(userInfo, true);
        }
        else {
          return new DataResult(null, true);
        }
     }
  }
  
  ///登入者被註銷更新APP
  static updateDummyApp(context, blankURL) async {
    next() async {
  
      if (blankURL != null && blankURL != "") {
        CommonUtils.showDummuAppDialog(context, '此登入者信息已註銷', blankURL);
      }  
      else {
        print("is android device dummy");
        
      }
    }
    return await next();
  }

  ///檢查更新app版本
  static validNewVersion(context) async {
    var res = await HttpManager.netFetch(Address.getValidateVersionAPI(), null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      if (res.data['ReturnCode'] == "00") {
        CommonUtils.showUpdateAppDialog(context, res.data['MSG'], res.data['UpdateUrl']);
      }
      else {
        Fluttertoast.showToast(msg: res.data['MSG']);
      }
    }
  }

  ///是否要更新app
  static isUpdateApp(context) async {
    var res = await HttpManager.netFetch(Address.getValidateVersionAPI(), null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      if (res.data['ReturnCode'] == "00") {
        return true;
      }
      else {
        return false;
      }
    }
  }
}