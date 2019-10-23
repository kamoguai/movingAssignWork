import 'dart:convert';

import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/dao/DaoResult.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/net/Api.dart';
import 'package:assignwork/common/utils/AesUtils.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///約裝狀態查詢相關
///Date: 2019-10-15
///
class BookingStatusDao {
  ///查詢派單信息
  static getQueryCustomerWorkOrderInfos(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("約裝查詢request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.queryCustomerWorkOrderInfos(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("約裝查詢resp => " + res.data.toString());
      }
      if (res.data['RtnCD'] == "00") {
        mainDataArray = res.data['data'];
      }
      if (mainDataArray.length > 0) {
        return new DataResult(mainDataArray, true);
      }
      else {
        return new DataResult(null, false);
      }
    }
  }

  ///取得約裝撤銷原因
  static getQueryCancelBaseInfo(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> resDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("取得撤銷原因request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.getQueryCancelBaseInfo(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("取得撤銷原因resp => " + res.data.toString());
      }
      if (res.data['RtnCD'] == "00") {
        resDataArray = res.data;
      }
      if (resDataArray.length > 0) {
        return new DataResult(resDataArray, true);
      }
      else {
        return new DataResult(null, false);
      }
    }
  }

  ///執行約裝撤銷
  static cancelWorkOrder(Map<String, dynamic> jsonMap) async {
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("約裝撤銷request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.getQueryCancelBaseInfo(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("約裝撤銷resp => " + res.data.toString());
      }
      if (res.data['RtnCD'] == "00") {
        Fluttertoast.showToast(msg: '撤銷成功');
        return new DataResult(null, true);
      }
      else {
        return new DataResult(null, false);
      }
    }
  }


}