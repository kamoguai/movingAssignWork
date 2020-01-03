import 'dart:convert';

import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/dao/DaoResult.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/net/Api.dart';
import 'package:assignwork/common/utils/AesUtils.dart';
import 'package:dio/dio.dart';

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

}