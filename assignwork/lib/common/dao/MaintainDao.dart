import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/dao/DaoResult.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/net/Api.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';


///
///報修相關dao
///Date: 2020-01-20
class MaintainDao {

  ///取得派修下拉選單，無傳入參數
  static getBossPhenData() async {
    Map<String, dynamic> mainDataArray = {};
    var res = await HttpManager.netFetch(Address.getBossPhenData(), null, null, null);
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("派修下拉選單resp => " + res.data.toString());
      }
      if (res.data['retCode'] == "00") {
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

  ///報修派單
  static postOrderReportFault(Map<String, dynamic> jsonMap, context) async {
    var res = await HttpManager.netFetch(Address.postOrderReportFault(), jsonMap, null, new Options(method: "get"));
    if (res != null && res.result) {
      if (Config.DEBUG) {
        print("報修派單resp => " + res.data.toString());
      }
      if (res.data['retCode'] == "00") {
        CommonUtils.showToast(context, msg: res.data['retCode'], align: 'center');
        return new DataResult(null, true);
      }
      else {
        CommonUtils.showToast(context, msg: res.data['retMSG'], align: 'center');
        return new DataResult(null, false);
      }
    }
  }
}