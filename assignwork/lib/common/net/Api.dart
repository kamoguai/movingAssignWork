import 'package:dio/dio.dart';
import 'package:assignwork/common/net/Code.dart';

import 'dart:collection';
import 'dart:convert';
import 'package:assignwork/common/local/LocalStorage.dart';
import 'package:assignwork/common/net/ResultData.dart';
import 'package:assignwork/common/config/Config.dart';
import 'package:connectivity/connectivity.dart';
import 'package:assignwork/common/utils/AesUtils.dart';

///http請求
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Map optionParams = {
    "timeoutMs": 15000,
    "token": null,
    "authorizationCode": null,
  };

  static netFetch(url, params, Map<String, String> header, Options option, {noTip = false}) async {
    //沒有網路時
    var conntectivityResult = await (new Connectivity().checkConnectivity());
    if (conntectivityResult ==ConnectivityResult.none) {
      return new ResultData(Code.errorHandleFunction(Code.NETWORK_ERROR, "", noTip), false, Code.NETWORK_ERROR);
    }

    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (option != null) {
      option = new Options(method: "post", responseType: ResponseType.plain);
      option.headers = headers;
    } else{
      option = new Options(method: "get", responseType: ResponseType.plain);
      option.headers = headers;
    }

    ///超時
    option.connectTimeout = 15000;

    Dio dio = new Dio();
    Response response;
    try {
      response = await dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      Response errorResponse;
      if (e.response != null) {
        //如果有錯誤信息回填
        errorResponse = e.response;
      }
      else {
        //沒有錯誤信息帶666
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type ==DioErrorType.CONNECT_TIMEOUT) {
        //如果是timeout
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (Config.DEBUG) {// debug模式才會進入
        print("請求異常 => "+e.toString());
        print("請求異常url => "+ url);
      }
      return new ResultData(Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip), false, errorResponse.statusCode);
    }

    if (Config.DEBUG) {
      print("請求 url => "+ url);
      print("請求頭 => "+ option.toString().toString());
      if (params != null) {
        print("請求參數 => "+ params.toString());
      }
      if (response != null) {
        print("返回參數 => "+ response.toString());
      }
      if (optionParams["authorizationCode"] != null) {
        print("authorizationCode => "+ optionParams["authorizationCode"]);
      }
    }
    try {
     
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (option.method == "post") {
          var result = AesUtils.aes128Decrypt(response.toString());
          var jsonStr = jsonDecode(result);
          Map<String, dynamic> map = jsonStr;
          return new ResultData(map, true, Code.SUCCESS, headers: response.headers);
        }
        var jsonStr = jsonDecode(response.toString());
        Map<String, dynamic> map = jsonStr;
        return new ResultData(map, true, Code.SUCCESS, headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + url);
      String respData = response.data.toString().replaceAll("\r", "").replaceAll("\n", "");
      if (respData.length < 1) {
        return new ResultData(null, false, response.statusCode, headers: response.headers);
      }
      Map<String, dynamic> jsonStr = jsonDecode(response.data);
      return new ResultData(jsonStr, false, response.statusCode, headers: response.headers);
    }
    return new ResultData(Code.errorHandleFunction(response.statusCode, "", noTip), false, response.statusCode);
  }

  ///清除授權
  static clearAuthorization() {
    optionParams["authorizationCode"] = null;
    LocalStorage.remove(Config.TOKEN_KEY);
  }

  ///获取授权token
  static getAuthorization() async {
    String token = await LocalStorage.get(Config.TOKEN_KEY);
    if (token == null) {
      String basic = await LocalStorage.get(Config.USER_BASIC_CODE);
      if (basic == null) {
        //提示輸入帳號密碼
      } else {
        //通過 basic 去獲取token，獲取到設置，返回token
        return "Basic $basic";
      }
    } else {
      optionParams["authorizationCode"] = token;
      return token;
    }
  }

}