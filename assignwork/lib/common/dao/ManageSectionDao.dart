import 'dart:convert';

import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/dao/DaoResult.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/net/Api.dart';
import 'package:assignwork/common/utils/AesUtils.dart';
import 'package:dio/dio.dart';

///
///查詢區域，班別相關
///Date: 2019-12-06
class ManageSectionDao {
  ///
  ///查詢子管理區域
  ///
  static getQueryManageSection(Map<String, dynamic> jsonMap) async {

    List<dynamic> mainDataArray = [];
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("查詢子管理區域request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.queryManageSection(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("查詢子管理區域resp => " + res.data.toString());
      }
      if (res.data['RtnCD'] == "00") {
        mainDataArray = res.data['manageSectionInfos'];
      }
      if (mainDataArray.length > 0) {
        return new DataResult(mainDataArray, true);
      }
      else {
        return new DataResult(null, false);
      }
    }
  }
  ///
  ///查詢套餐訊息
  ///
  static getQueryProductInfo(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("查詢套餐訊息request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.queryProductInfo(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("查詢套餐訊息resp => " + res.data.toString());
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
  ///
  ///匹配地址
  ///
  static postMatchAddress(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("匹配地址request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.matchAddress(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("匹配地址resp => " + res.data.toString());
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

  ///
  ///查詢班次
  ///
  static getQueryBookService(Map<String, dynamic> jsonMap) async {
    Map<String, dynamic> mainDataArray = {};
    List<dynamic> mList = new List<dynamic>();
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("查詢班次request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.matchAddress(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("查詢班次resp => " + res.data.toString());
      }
      if (res.data['RtnCD'] == "00") {
        mList = res.data['bookingServiceInfos'];
      }
      if (mList.length > 0) {
        return new DataResult(mList, true);
      }
      else {
        return new DataResult(null, false);
      }
    }
  }

}