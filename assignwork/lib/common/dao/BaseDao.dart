import 'dart:convert';

import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/dao/DaoResult.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/net/Api.dart';
import 'package:assignwork/common/utils/AesUtils.dart';
import 'package:dio/dio.dart';

///
///基本信息dao
///Date: 2019-10-08
///
class BaseDao {

  ///取得贈送月份
  static getGiftMonth(Map jsonMap,) async {
    Map<String, dynamic> resDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("取得贈送月份request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.getIndustryWithWkno(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("取得贈送月份resp => " + res.data.toString());
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

  ///取得競業
  static getIndustryWithWkno(Map jsonMap) async {
    Map<String, dynamic> resDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("取得競業request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.getIndustryWithWkno(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("取得競業resp => " + res.data.toString());
      }
      if (res.data['retCode'] == "00") {
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
  ///取得全部廠商列表
  static getIndustryList(Map jsonMap) async {
    Map<String, dynamic> resDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("取得全部廠商列表request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.getIndustryList(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("取得全部廠商列表resp => " + res.data.toString());
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

  ///取得基本下拉選單列表
  static getBaseListInfo(Map jsonMap) async {
    Map<String, dynamic> resDataArray = {};
    ///map轉json
    String str = json.encode(jsonMap);
    if (Config.DEBUG) {
      print("取得基本下拉request => " + str);
    }
    ///aesEncode
    var aesData = AesUtils.aes128Encrypt(str);
    Map paramsData = {"data": aesData};
    var res = await HttpManager.netFetch(Address.getBaseListInfo(), paramsData, null, new Options(method: "post"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("取得基本下拉resp => " + res.data.toString());
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
}