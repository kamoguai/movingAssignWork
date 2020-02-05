import 'dart:convert';
import 'dart:io';

import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/dao/DaoResult.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/net/Api.dart';
import 'package:assignwork/common/utils/AesUtils.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///處理約裝送出相關
///Date: 2020-01-02
class BookingSendDao {

  ///試算
  static postTrail(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("試算request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.postTrial(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("試算resp => " + res.data.toString());
      }
      mainDataArray = res.data;
      return new DataResult(mainDataArray, true);
    }
  }

  ///約裝
  static postOpenPurchase(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("約裝request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.openPurchase(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("約裝resp => " + res.data.toString());
      }
      mainDataArray = res.data;
      return new DataResult(mainDataArray, true);
    }
  }

  ///加裝
  static postAddPurchase(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("加裝request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.addPurchase(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("加裝resp => " + res.data.toString());
      }
      mainDataArray = res.data;
      return new DataResult(mainDataArray, true);
    }
  }
  
  ///維修派單
  static postOrderReportFault(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("維修派單request => " + str);
    }

    String customerCode = jsonMap["customerCode"];
    String operatorCode = jsonMap["operatorCode"];
    String phenomenonTypeCode = jsonMap["phenomenonTypeCode"];
    String phenomenonCode = jsonMap["phenomenonCode"];
    String bookingDate = jsonMap["bookingDate"];
    String description = jsonMap["description"];
    var res = await HttpManager.netFetch(Address.postOrderReportFault(customerCode: customerCode, operatorCode: operatorCode, phenomenonTypeCode: phenomenonTypeCode, phenomenonCode: phenomenonCode, bookingDate: bookingDate, description: description), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("維修派單resp => " + res.data.toString());
      }
      if (res.data["retCode"] == "00") {
        mainDataArray = res.data["data"];
        return new DataResult(mainDataArray, true);
      }
      else {
        Fluttertoast.showToast(msg: res.data["retName"]);
        return new DataResult(null, false);
      }
    }
  }

   ///競業save
  static postIndustryData(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("競業request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.addPurchase(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("競業resp => " + res.data.toString());
      }
      mainDataArray = res.data;
      return new DataResult(mainDataArray, true);
    }
  }
 
}