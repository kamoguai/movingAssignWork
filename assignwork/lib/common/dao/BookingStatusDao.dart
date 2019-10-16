import 'dart:convert';

import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/dao/DaoResult.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/net/Api.dart';
import 'package:assignwork/common/utils/AesUtils.dart';
import 'package:dio/dio.dart';

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


}