import 'dart:io';

import 'package:assignwork/common/dao/BaseDao.dart';
import 'package:assignwork/common/dao/BookingSendDao.dart';
import 'package:assignwork/common/dao/ManageSectionDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/HomeDrawer.dart';
import 'package:assignwork/widget/dialog/CalendarSelectorDialog.dart';
import 'package:assignwork/widget/dialog/CustDetailSelectDialog.dart';
import 'package:assignwork/widget/dialog/ProductSelectDialog.dart';
import 'package:assignwork/widget/dialog/SelectorDialog.dart';
import 'package:assignwork/widget/item/TrialResWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

///
///新戶約裝頁面
///Date: 2019-12-12
class BookingViewPage extends StatefulWidget {
  static final String sName = 'booking';

  @override
  _BookingViewPageState createState() => _BookingViewPageState();
}

class _BookingViewPageState extends State<BookingViewPage> with BaseWidget {
  ScrollController _scrollController = new ScrollController();
  TextEditingController _editingController = new TextEditingController();

  ///bottomNavigatorBar index
  int _bnbIndex = 0;

  ///記錄競業arr
  List<dynamic> industyArr = [];
  String industySelected = "";

  ///記錄營銷活動下拉
  List<dynamic> marketArr = [];
  String marketSelected = "";
  String marketNameSelected = "";

  ///記錄有線產品下拉
  List<dynamic> dtvArr = [];
  String dtvSelected = "";
  String dtvNameSelected = "";

  ///記錄有線繳別下拉
  List<dynamic> dtvPayArr = [];
  String dtvPaySelected = "";

  ///記錄加購產品下拉
  List<dynamic> dtvAddProdArr = [];
  Map<String, dynamic> dtvAddProdSelected = {};

  ///記錄分機數量下拉
  List<dynamic> slaveArr = [];
  String slaveSelected = "";

  ///記錄cm產品下拉
  List<dynamic> cmArr = [];
  String cmSelected = "";
  String cmNameSelected = "";

  ///記錄cm繳別下拉
  List<dynamic> cmPayArr = [];
  String cmPaySelected = "";

  ///記錄跨樓層下拉
  List<dynamic> crossFloorArr = [];
  String crossFloorSelected = "";

  ///記錄網路線下拉
  List<dynamic> netCableArr = [];
  String netCableSelected = "";

  ///有線業贈下拉
  List<dynamic> dtvGiftArr = [];
  String dtvGiftSelected = "";

  ///寬頻業贈下拉
  List<dynamic> cmGiftArr = [];
  String cmGiftSelected = "";

  ///發展人下拉
  List<dynamic> salesArr = [];
  String salesSelected = "";
  String salesNameSelected = "";
  bool isCalledSales = false;

  ///記錄匹配完資料
  Map<String, dynamic> logMatchArr = {};

  ///記錄套餐資料
  Map<String, dynamic> logProdInfo = {};

  ///記錄所選約裝時間
  String bookingDateSelected = "";

  ///記錄試算結果金額
  Map<String, dynamic> logTrialArr = {
    "dtvMoney": "",
    "cmMoney": "",
    "installMoney": "",
    "buildMoney": "",
    "foregiftMoney": "",
    "additionalMoney": "",
    "networkCableMoney": "",
    "sumMoney": ""
  };

  ///判斷檢核完成後才能送出
  bool _isPkSend = false;

  ///判斷檢核試算欄位
  bool _isTrial = false;

  ///試算結果字串
  String resTrialStr = "";

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

  ///下拉選單高度
  double _dropHeight(context) {
    var deviceHieght = titleHeight(context) * 1.3;
    if (Platform.isAndroid) {
      deviceHieght = titleHeight(context) * 1.5;
    }
    return deviceHieght;
  }

  //********** call api  s*/
  ///取得競業資料
  _getIndustryData() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "getIndustryList";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["areaCode"] = "220/ROOT";
    var res = await BaseDao.getIndustryList(paramMap);
    if (res.result) {
      var data = res.data["industryList"];
      data.insert(0, '');
      setState(() {
        this.industyArr = data;
      });
    }
  }

  ///取得基本資料
  _getBaseData() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "getBaseListInfo";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    var res = await BaseDao.getBaseListInfo(paramMap);
    if (res.result) {
      final data1 = res.data["networkCableNumberList"];
      final data2 = res.data["crossFloorNumberList"];
      final data3 = res.data["slaveNumberList"];

      setState(() {
        this.netCableArr = data1;
        this.crossFloorArr = data2;
        this.slaveArr = data3;
      });
    }
  }

  ///取得發展人資料
  _getSalesData() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "queryemplyeelist";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["deptCD"] = _getStore().state.userInfo?.deptCD;
    var res = await BaseDao.getSalesListInfo(paramMap);
    if (res.result) {
      setState(() {
        this.isCalledSales = true;
        this.salesArr = res.data;
      });
    } else {
      setState(() {
        this.isCalledSales = true;
      });
    }
  }

  ///取得業贈資料
  _getSalesGiftData(type, bossCode) async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["type"] = type;
    paramMap["bossCode"] = bossCode;
    var res = await BaseDao.getGiftMonth(paramMap);
    if (res.result) {
      setState(() {
        if (type == 'DTV') {
          this.dtvGiftArr = res.data;
          this.dtvGiftArr.insert(0, {"month": "0"});
        } else {
          this.cmGiftArr = res.data;
          this.cmGiftArr.insert(0, {"month": "0"});
        }
      });
    }
  }

  ///取得地區產品資料
  _getProdInfoData(Map<String, dynamic> map) async {
    var res = await ManageSectionDao.getQueryProductInfo(map);
    if (res.result) {
      this.logProdInfo = res.data;
      this.dtvArr = this.logProdInfo["dtvInfos"];
      this.dtvPayArr = this.dtvArr[0]["payMonths"];
      this.dtvArr.insert(0, {"code": "", "name": "", "payMonths": []});
      this.cmArr = this.logProdInfo["broadbandSpeedInfos"];
      this.cmArr.insert(0, {"code": "", "name": "", "payMonths": []});
      this.dtvAddProdArr = this.logProdInfo["additionalProductInfos"];
    }
  }

  ///試算
  _postTrailData() async {
    print(this.logMatchArr);
    bool isOk = validTrialParam();
    if (!isOk) {
      return;
    }
    CommonUtils.showLoadingDialog(context);
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "trial";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["trialType"] = "1";
    paramMap["manageSectionCode"] = this.logMatchArr["areaCode"];
    paramMap["bookingDate"] = this.bookingDateSelected;
    paramMap["dtvCode"] = this.dtvSelected;
    paramMap["dtvMonth"] = CommonUtils.filterMonthNm(this.dtvPaySelected);
    paramMap["cmCode"] = this.cmSelected;
    paramMap["cmMonth"] = CommonUtils.filterMonthNm(this.cmPaySelected);
    paramMap["allowanceMonth"] = "0";
    paramMap["slaveNumber"] =
        this.slaveSelected == "" ? "0" : this.slaveSelected;
    paramMap["crossFloorNumber"] =
        this.crossFloorSelected == "" ? "0" : this.crossFloorSelected;
    paramMap["networkCableNumber"] =
        this.netCableSelected == "" ? "0" : this.netCableSelected;

    ///加購頻道不為0時
    if (this.dtvAddProdSelected.length > 0) {
      List<dynamic> prodDatas = [];
      for (var indx in this.dtvAddProdSelected.values) {
        for (var dic in indx) {
          prodDatas.add(dic);
        }
      }
      paramMap["additionalInfos"] = prodDatas;
    } else {
      paramMap["additionalInfos"] = [];
    }
    var res = await BookingSendDao.postTrail(paramMap);
    if (res.result) {
      if (res.data["RtnCD"] == "00") {
        Navigator.pop(context);
        CommonUtils.showToast(context, msg: '試算成功!');
        setState(() {
          if (this.dtvGiftSelected != "" || this.cmGiftSelected != "") {
            this.resTrialStr = '試算成功，業務贈送需要自行繳費！';
          } else {
            this.resTrialStr = '試算成功!';
          }
          this.logTrialArr["dtvMoney"] = res.data["dtvMoney"];
          this.logTrialArr["cmMoney"] = res.data["cmMoney"];
          this.logTrialArr["installMoney"] = res.data["installMoney"];
          this.logTrialArr["buildMoney"] = res.data["buildMoney"];
          this.logTrialArr["foregiftMoney"] = res.data["foregiftMoney"];
          this.logTrialArr["additionalMoney"] = res.data["additionalMoney"];
          this.logTrialArr["networkCableMoney"] = res.data["networkCableMoney"];
          this.logTrialArr["sumMoney"] = res.data["sumMoney"];
          this._isPkSend = true;
        });
      } else {
        Navigator.pop(context);
        CommonUtils.showToast(context, msg: res.data["RtnMsg"]);
        setState(() {
          this.resTrialStr = res.data["RtnMsg"];
        });
        return;
      }
    }
  }

  ///約裝
  _postOpenPurchase() async {
    CommonUtils.showLoadingDialog(context);
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    paramMap["name"] = this.logMatchArr["custName"];
    paramMap["mobile"] = this.logMatchArr["mobile"];
    paramMap["telphone"] = this.logMatchArr["telPhone"];
    paramMap["installAddress"] = this.logMatchArr["fullAddressCode"];
    paramMap["postAddress"] = this.logMatchArr["fullAddressCode"];
    paramMap["partyIdentification"] = "A123456789";
    paramMap["gender"] = "201";
    paramMap["customerType"] = "1";

    ///customerInfo:
    jsonMap["customerInfo"] = paramMap;
    paramMap = new Map<String, dynamic>();
    paramMap["dtvCode"] = this.dtvSelected;
    paramMap["dtvMonth"] = CommonUtils.filterMonthNm(this.dtvPaySelected);
    paramMap["cmCode"] = this.cmSelected;
    paramMap["cmMonth"] = CommonUtils.filterMonthNm(this.cmPaySelected);
    paramMap["allowanceMonth"] = "0";
    paramMap["slaveNumber"] =
        this.slaveSelected == "" ? "0" : this.slaveSelected;
    paramMap["crossFloorNumber"] =
        this.crossFloorSelected == "" ? "0" : this.crossFloorSelected;
    paramMap["networkCableNumber"] =
        this.netCableSelected == "" ? "0" : this.netCableSelected;

    ///加購頻道不為0時
    if (this.dtvAddProdSelected.length > 0) {
      List<dynamic> prodDatas = [];
      for (var indx in this.dtvAddProdSelected.values) {
        for (var dic in indx) {
          prodDatas.add(dic);
        }
      }
      paramMap["additionalInfos"] = prodDatas;
    } else {
      paramMap["additionalInfos"] = [];
    }
    paramMap["sumMoney"] = this.logTrialArr["sumMoney"];

    ///purchaseInfo:
    jsonMap["purchaseInfo"] = paramMap;
    paramMap = new Map<String, dynamic>();
    paramMap["bookingDate"] = this.bookingDateSelected;
    if (this.salesNameSelected == '') {
      paramMap["saleManCode"] = _getStore().state.userInfo.accNo;
    } else {
      paramMap["saleManCode"] = this.salesSelected;
    }
    paramMap["operator"] = _getStore().state.userInfo.accNo;
    paramMap["description"] = _editingController.text;

    ///orderInfo:
    jsonMap["orderInfo"] = paramMap;
    paramMap = new Map<String, dynamic>();
    List<dynamic> saleGiftArr = [];

    ///業務贈送
    if (this.dtvGiftSelected != "" && this.cmGiftSelected != "") {
      paramMap["classification"] = "DTV";
      paramMap["type"] = "D";
      paramMap["month"] = CommonUtils.filterGiftMonthNm(this.dtvGiftSelected);
      saleGiftArr.add(paramMap);
      paramMap = new Map<String, dynamic>();
      paramMap["classification"] = "CM";
      paramMap["type"] = "D";
      paramMap["month"] = CommonUtils.filterGiftMonthNm(this.cmGiftSelected);
      saleGiftArr.add(paramMap);
    } else {
      if (this.dtvGiftSelected != "") {
        paramMap["classification"] = "DTV";
        paramMap["type"] = "D";
        paramMap["month"] = CommonUtils.filterGiftMonthNm(this.dtvGiftSelected);
        saleGiftArr.add(paramMap);
      } else if (this.cmGiftSelected != "") {
        paramMap["classification"] = "CM";
        paramMap["type"] = "D";
        paramMap["month"] = CommonUtils.filterGiftMonthNm(this.cmGiftSelected);
        saleGiftArr.add(paramMap);
      }
    }
    jsonMap["giftsInfo"] = saleGiftArr;
    jsonMap["function"] = "openPurchase";
    jsonMap["accNo"] = _getStore().state.userInfo?.accNo;
    var res = await BookingSendDao.postOpenPurchase(jsonMap);
    Navigator.pop(context);
    if (res.result) {
      if (res.data["RtnCD"] == "00") {
        CommonUtils.showToast(context, msg: '立案成功！');

        ///呼叫save競業api
        _postIndustryData(res.data["workorderCode"]);
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigatorUtils.goHome(context);
          return true;
        });
      } else {
        CommonUtils.showToast(context, msg: res.data["RtnMsg"]);
        return;
      }
      // res.data["customerCode"];
      // res.data["workorderCode"];
    }
  }

  ///post競業api
  _postIndustryData(wkNo) async {
    Map<String, dynamic> paramMap = Map<String, dynamic>();
    paramMap["function"] = "insertindustry";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["wkNo"] = wkNo;
    paramMap["Industry"] = this.industySelected;
    var res = await BookingSendDao.postIndustryData(paramMap);
  }

  //********** call api  e*/
  ///給客戶詳情輸入用function
  void _getMatchDataFunc(Map<String, dynamic> map) async {
    setState(() {
      ///匹配完後試算按鈕可按
      this._isTrial = true;
      this.logMatchArr = map;
      Map<String, dynamic> jsonMap = Map<String, dynamic>();
      jsonMap["function"] = "queryProductInfo";
      jsonMap["accNo"] = _getStore().state.userInfo?.accNo;
      jsonMap["areaCode"] = this.logMatchArr["areaCode"];
      _getProdInfoData(jsonMap);
    });
  }

  ///給calendar用function
  void _getBookingDateSelectFunc(String date) {
    setState(() {
      this.bookingDateSelected = date;
      print('新約日期 -> ${this.bookingDateSelected}');
    });
  }

  ///加購產品用function
  void _getAddProductSelectFunc(pickData) {
    print('callback -> $pickData');
    print('callback -> ${pickData.length}');
    setState(() {
      this.dtvAddProdSelected = pickData;
    });
  }

  ///Scaffold body
  Widget _bodyView() {
    var telphone = "";
    var bookingTime = "";
    if (this.logMatchArr["mobile"] != null) {
      telphone += this.logMatchArr["mobile"];
    }
    if (this.logMatchArr["telPhone"] != null &&
        this.logMatchArr["telPhone"] != "") {
      if (this.logMatchArr["mobile"] != null) {
        telphone += " , ";
      }
      telphone +=
          this.logMatchArr["telAreaCode"] + this.logMatchArr["telPhone"];
    }
    if (this.bookingDateSelected != "") {
      DateFormat df = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime d = df.parse(this.bookingDateSelected);
      df = DateFormat("yy-MM-dd HH:mm");
      bookingTime = df.format(d);
    }
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          ///點擊跳出可輸入pop
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _custDetailSelectorDialog(context));
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                      style: BorderStyle.solid))),
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: '姓名：',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: MyScreen.homePageFontSize_span(
                                        context)),
                              ),
                              TextSpan(
                                text: this.logMatchArr["custName"] == null
                                    ? ''
                                    : this.logMatchArr["custName"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: MyScreen.homePageFontSize_span(
                                        context)),
                              )
                            ]),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: '客編：',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: MyScreen.homePageFontSize_span(
                                        context)),
                              ),
                              TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: MyScreen.homePageFontSize_span(
                                        context)),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid))),
                  child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '電話：',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MyScreen.homePageFontSize_span(context)),
                      ),
                      TextSpan(
                        text: telphone,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MyScreen.homePageFontSize_span(context)),
                      ),
                    ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid))),
                  child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '地址：',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MyScreen.homePageFontSize_span(context)),
                      ),
                      TextSpan(
                        text: this.logMatchArr["fullAddress"] == null
                            ? ""
                            : this.logMatchArr["fullAddress"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MyScreen.homePageFontSize_span(context)),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          ///其他下拉選單
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          // decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: '大樓：',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: MyScreen.homePageFontSize_span(
                                        context)),
                              ),
                              TextSpan(
                                text: this.logMatchArr["buildingName"] == null
                                    ? ""
                                    : this.logMatchArr["buildingName"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: MyScreen.homePageFontSize_span(
                                        context)),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: _dropHeight(context),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                      style: BorderStyle.solid))),
                          padding: EdgeInsets.only(left: 5.0),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '競業',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${this.industySelected == '' ? '請選擇▿' : this.industySelected}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                )
                              ],
                            ),
                            onTap: () async {
                              _showSelectorController(context,
                                  dataList: this.industyArr,
                                  title: '競業',
                                  dropStr: 'industy');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid)),
                      color: Colors.green[50]),
                  child: Container(
                    width: double.infinity,
                    height: _dropHeight(context),
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              '營銷活動',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MyScreen.defaultTableCellFontSize(
                                      context)),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${this.marketNameSelected == '' ? '請選擇▿' : this.marketNameSelected}',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: MyScreen.homePageFontSize(context)),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        // if (this.logMatchArr.length > 0)
                        _showSelectorController(context,
                            dataList: this.marketArr,
                            title: '營銷活動',
                            dropStr: 'market');
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid)),
                      color: Colors.green[50]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                      style: BorderStyle.solid))),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '有線',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${this.dtvNameSelected == '' ? '請選擇▿' : this.dtvNameSelected}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              if (this.logMatchArr.length > 0)
                                _showSelectorController(context,
                                    dataList: this.dtvArr,
                                    title: '頻道類別',
                                    dropStr: 'dtv');
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          padding: EdgeInsets.only(left: 5.0),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '繳別',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${this.dtvPaySelected == '' ? '請選擇▿' : this.dtvPaySelected}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              if (this.dtvSelected != "") {
                                _showSelectorController(context,
                                    dataList: this.dtvPayArr,
                                    title: '繳費類型',
                                    dropStr: 'dtvPay');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid)),
                      color: Colors.green[50]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                      style: BorderStyle.solid))),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '加購',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    this.dtvAddProdSelected.length == 0
                                        ? '請選擇▿'
                                        : '${this.dtvAddProdSelected.length}種',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.dtvSelected != "")
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _productSelectorDialog(context));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          padding: EdgeInsets.only(left: 5.0),
                          child: InkWell(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '分機',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    this.slaveSelected == ''
                                        ? '請選擇▿'
                                        : this.slaveSelected + ' 台',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.dtvSelected != "") {
                                _showSelectorController(context,
                                    dataList: this.slaveArr,
                                    title: '分機',
                                    dropStr: 'slave');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid)),
                      color: Colors.cyan[50]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                      style: BorderStyle.solid))),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'CM',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${this.cmNameSelected == "" ? '請選擇▿' : this.cmNameSelected}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              if (this.logMatchArr.length > 0)
                                _showSelectorController(context,
                                    dataList: this.cmArr,
                                    title: '寬頻服務類別',
                                    dropStr: 'cm');
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          padding: EdgeInsets.only(left: 5.0),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '繳別',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${this.cmPaySelected == "" ? '請選擇▿' : this.cmPaySelected}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              if (this.cmSelected != "") {
                                _showSelectorController(context,
                                    dataList: this.cmPayArr,
                                    title: '繳費類型',
                                    dropStr: 'cmPay');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                      style: BorderStyle.solid))),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '跨樓層',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    this.crossFloorSelected == ''
                                        ? '請選擇▿'
                                        : this.crossFloorSelected + ' 層',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.dtvSelected != "" &&
                                  this.slaveSelected != "") {
                                _showSelectorController(context,
                                    dataList: this.crossFloorArr,
                                    title: '跨樓層',
                                    dropStr: 'crossFloor');
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          padding: EdgeInsets.only(left: 5.0),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '網路線',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    this.netCableSelected == ''
                                        ? '請選擇▿'
                                        : this.netCableSelected + ' 條',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.cmSelected != "") {
                                _showSelectorController(context,
                                    dataList: this.netCableArr,
                                    title: '網路線',
                                    dropStr: 'netCable');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                      style: BorderStyle.solid))),
                          child: InkWell(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '裝機日期',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${bookingTime == '' ? '請選擇▿' : bookingTime}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.logMatchArr.length > 0)
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _calendarSelectorDialog(context));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          padding: EdgeInsets.only(left: 5.0),
                          child: InkWell(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '發展人',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MyScreen.defaultTableCellFontSize(
                                                context)),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${this.salesNameSelected == '' ? '請選擇▿' : this.salesNameSelected}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            MyScreen.homePageFontSize(context)),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.logMatchArr.length > 0)
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        salesSelectorDialot(context));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Colors.amber[100]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text('有線業贈', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                                ),
                                Expanded(
                                  child: Text('${this.dtvGiftSelected == '' ? '請選擇▿' : this.dtvGiftSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.dtvSelected != "") {
                                _showSelectorController(context, dataList: this.dtvGiftArr, title: '有線贈送月數', dropStr: 'giftDTV');
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: _dropHeight(context),
                          padding: EdgeInsets.only(left: 5.0),
                          child: InkWell(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Text('寬頻業贈', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                                ),
                                Expanded(
                                  child: Text('${this.cmGiftSelected == '' ? '請選擇▿' : this.cmGiftSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.cmSelected != "") {
                                _showSelectorController(context, dataList: this.cmGiftArr, title: '寬頻贈送月數', dropStr: 'giftCM');
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),*/
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid))),
                  child: TextField(
                    controller: _editingController,
                    textInputAction: TextInputAction.done,
                    maxLines: 4,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MyScreen.defaultTableCellFontSize(context)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: '備註',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                              style: BorderStyle.solid)),
                    ),
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ButtonTheme(
            height: titleHeight(context) * 1.3,
            minWidth: MediaQuery.of(context).size.width / 2,
            // buttonColor: Colors.blue,
            child: FlatButton(
              color: this._isTrial == true ? Colors.blue : Colors.grey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(
                '試算',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MyScreen.homePageFontSize(context)),
              ),
              onPressed: () async {
                if (_isTrial) _postTrailData();
              },
            ),
          ),

          ///todo: 試算結果
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            child: Center(
                child: autoTextSize(
                    this.resTrialStr, TextStyle(color: Colors.red), context)),
          ),

          SizedBox(
            height: 10,
          ),
          TrialResWidget(
            logTrialArr: this.logTrialArr,
            fromFunc: 'book',
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '送出後不能更改，請確認資料完整性。',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: MyScreen.defaultTableCellFontSize(context)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ButtonTheme(
            height: titleHeight(context) * 1.3,
            minWidth: MediaQuery.of(context).size.width / 2,
            // buttonColor: Colors.blue,
            child: FlatButton(
              color: this._isPkSend == true ? Colors.blue : Colors.grey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(
                '送出',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MyScreen.homePageFontSize(context)),
              ),
              onPressed: () async {
                if (this._isPkSend) _postOpenPurchase();
              },
            ),
          ),
        ],
      ),
    );
  }

  ///Scaffold bottomBar
  Widget _bottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: autoTextSize('首頁', TextStyle(color: Colors.white), context)),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.search),
        //   title: autoTextSize('查詢', TextStyle(color: Colors.white), context)
        // ),
        BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            title: autoTextSize('登出', TextStyle(color: Colors.white), context)),
      ],
      backgroundColor: Color(MyColors.hexFromStr('#f4bf5f')),
      currentIndex: _bnbIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      onTap: _bottomNavBarAction,
    );
  }

  ///bottomNavigationBar action
  void _bottomNavBarAction(int index) {
    setState(() {
      _bnbIndex = index;
      if (mounted) {
        switch (index) {
          case 0:
            NavigatorUtils.goHome(context);
            break;
          case 1:
            NavigatorUtils.goLogin(context);
            break;
          case 2:
            NavigatorUtils.goLogin(context);
            break;
        }
      }
    });
  }

  ///show客戶資料輸入popup
  Widget _custDetailSelectorDialog(
    BuildContext context,
  ) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Scaffold(
              body: CustDetailSelectDialog(
            getMatchDataFunc: _getMatchDataFunc,
            logMatchAddr: this.logMatchArr,
          )),
        ));
  }

  ///show日期選擇器
  Widget _calendarSelectorDialog(
    BuildContext context,
  ) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Scaffold(
              body: CalendarSelectorDialog(
            bookingDate: this.bookingDateSelected,
            areaStr: CommonUtils.filterAreaCN('板橋區'),
            getBookingDate: _getBookingDateSelectFunc,
            fromFunc: 'book',
          )),
        ));
  }

  ///show加購頻道選擇器
  Widget _productSelectorDialog(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Scaffold(
              body: ProductSelectDialog(
            dataList: this.dtvAddProdArr,
            selectFunc: this._getAddProductSelectFunc,
            callBackData: this.dtvAddProdSelected,
          )),
        ));
  }

  ///發展人dialog
  Widget salesSelectorDialot(BuildContext context) {
    var salesData = this.salesArr;
    return Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          // child: RoadSelectDialog(dataList: roadData, selectFunc: _selectFunc,),
          child: SelectorDialog(
            dataList: salesData,
            selectFunc: _selectFunc,
            findItemName: 'empName',
            labelTxt: '發展人',
            titleTxt: '選擇發展人',
            errTxt: '尚未選則發展人！',
            modelName: 'empName',
            modelVal: 'empNo',
          ),
        ));
  }

  void _selectFunc(Map<String, dynamic> map) {
    setState(() {});
  }

  _initMarketData() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["code"] = "onlyCM";
    map["name"] = "10908-單辦CM(綁約)";
    this.marketArr.add(map);
    map = new Map<String, dynamic>();
    map["code"] = "onlyDtv";
    map["name"] = "10908-有線(板城)(非綁約)";
    this.marketArr.add(map);
    map["code"] = "twoWay";
    map["name"] = "10908-雙辦(板城)(綁約)";
    this.marketArr.add(map);
    map["code"] = "twoWay100";
    map["name"] = "10908-雙辦(板城100M)(綁約)";
    this.marketArr.add(map);
    map["code"] = "twoWay30";
    map["name"] = "10908-雙辦(板城30M)(綁約)";
    this.marketArr.add(map);
  }

  @override
  void initState() {
    _initMarketData();
    super.initState();
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    this._editingController.dispose();
    this.dtvAddProdSelected.clear();
    this.dtvArr.clear();
    this.dtvPayArr.clear();
    this.industyArr.clear();
    this.logMatchArr.clear();
    this.logProdInfo.clear();
    this.logTrialArr.clear();
    this.netCableArr.clear();
    this.salesArr.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (this.industyArr.length == 0) {
      _getIndustryData();
    }
    if (this.netCableArr.length == 0) {
      _getBaseData();
    }
    if (this.salesArr.length == 0 && !this.isCalledSales) {
      _getSalesData();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            '新戶約裝',
            style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),
          ),
        ),
        body: _bodyView(),
        bottomNavigationBar: _bottomNavBar());
  }

  ///下拉選擇器
  _showSelectorController(BuildContext context,
      {List<dynamic> dataList, String title, String valName, String dropStr}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (context) {
          var dialog = CupertinoActionSheet(
              title: Text(
                '選擇$title',
                style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),
              ),
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  '取消',
                  style:
                      TextStyle(fontSize: MyScreen.homePageFontSize(context)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: _selectorActions(
                  dataList: dataList, valName: valName, dropStr: dropStr));
          return dialog;
        });
  }

  ///選擇器Actions
  List<Widget> _selectorActions(
      {List<dynamic> dataList, String valName, String dropStr}) {
    List<Widget> wList = [];
    if (dataList != null && dataList.length > 0) {
      if (dropStr == "dtv" || dropStr == "cm" || dropStr == "market") {
        for (var dic in dataList) {
          wList.add(CupertinoActionSheetAction(
            child: Text(
              '${dic["name"]}',
              style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),
            ),
            onPressed: () {
              setState(() {
                switch (dropStr) {
                  case "dtv":
                    this.dtvSelected = dic["code"];
                    this.dtvNameSelected = dic["name"];
                    if (this.dtvSelected == "") {
                      this.dtvPaySelected = "";
                      this.dtvAddProdSelected.clear();
                      this.slaveSelected = "";
                      this.crossFloorSelected = "";
                    } else {
                      this.dtvPaySelected =
                          CommonUtils.filterMonthCN2('${this.dtvPayArr[0]}');
                    }
                    this._getSalesGiftData('DTV', "TWBaseAdded");
                    break;
                  case "cm":
                    this.cmSelected = dic["code"];
                    this.cmNameSelected = dic["name"];
                    this.cmPayArr = dic["payMonths"];
                    if (this.cmSelected == "") {
                      this.cmPaySelected = "";
                      this.netCableSelected = "";
                    } else {
                      this.cmPaySelected =
                          CommonUtils.filterMonthCN2('${this.cmPayArr[0]}');
                    }
                    this._getSalesGiftData('CM', cmSelected);
                    break;
                  case "market":
                    this.marketSelected = dic["code"];
                    this.marketNameSelected = dic["name"];
                    break;
                }
                Navigator.pop(context);
              });
            },
          ));
        }
      } else if (dropStr == 'giftDTV' || dropStr == 'giftCM') {
        for (var dic in dataList) {
          dic = CommonUtils.filterGiftMonthCN('${dic["month"]}');
          wList.add(CupertinoActionSheetAction(
            child: Text(
              '$dic',
              style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),
            ),
            onPressed: () {
              setState(() {
                switch (dropStr) {
                  case 'giftDTV':
                    this.dtvGiftSelected = '$dic';
                    break;
                  case 'giftCM':
                    this.cmGiftSelected = '$dic';
                    break;
                }
                Navigator.pop(context);
              });
            },
          ));
        }
      } else {
        for (var dic in dataList) {
          if (dropStr == "dtvPay" || dropStr == "cmPay") {
            dic = CommonUtils.filterMonthCN2('$dic');
          }
          wList.add(CupertinoActionSheetAction(
            child: Text(
              '$dic',
              style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),
            ),
            onPressed: () {
              setState(() {
                switch (dropStr) {
                  case 'industy':
                    this.industySelected = '$dic';
                    break;
                  case 'dtvPay':
                    this.dtvPaySelected = '$dic';
                    break;
                  case 'slave':
                    this.slaveSelected = '$dic';
                    break;
                  case 'cmPay':
                    this.cmPaySelected = '$dic';
                    break;
                  case 'crossFloor':
                    this.crossFloorSelected = '$dic';
                    break;
                  case 'netCable':
                    this.netCableSelected = '$dic';
                    break;
                  case 'dtvGift':
                    this.dtvGiftSelected = '$dic';
                    break;
                  case 'cmGift':
                    this.cmGiftSelected = '$dic';
                    break;
                }
                Navigator.pop(context);
              });
            },
          ));
        }
      }
    }
    return wList;
  }

  ///檢核欄位- 試算(trial)
  validTrialParam() {
    if (this.dtvSelected == "" && this.cmSelected == "") {
      CommonUtils.showToast(context, msg: "請選擇欲約裝之產品！");
      return false;
    }
    if (this.dtvSelected != "") {
      if (this.dtvPaySelected == "") {
        CommonUtils.showToast(context, msg: "請選擇基本頻道繳別！");
        return false;
      }
    }
    if (this.cmSelected != "") {
      if (this.cmPaySelected == "") {
        CommonUtils.showToast(context, msg: "請選擇寬頻繳別！");
        return false;
      }
    }
    if (this.bookingDateSelected == "") {
      CommonUtils.showToast(context, msg: "尚未選擇裝機日期！");
      return false;
    }
    return true;
  }
}
