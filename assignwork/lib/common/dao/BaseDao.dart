import 'dart:convert';

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
    Map<String, dynamic> resData = {};
    Map<String,dynamic> head = {};
    Map<String, dynamic> paramsData = {};
    head["content-type"] = HttpManager.CONTENT_TYPE_FORM;
    var json = jsonEncode(jsonMap);
    var aesEncode = AesUtils.aes128Encrypt(json);
    paramsData["data"] = aesEncode;
    var res = await HttpManager.netFetch(Address.getGiftsMonth(), paramsData, head, new Options(method: "post"));
  }
}