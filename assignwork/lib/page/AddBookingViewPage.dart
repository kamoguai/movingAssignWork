import 'dart:io';

import 'package:assignwork/common/dao/BaseDao.dart';
import 'package:assignwork/common/dao/BookingSendDao.dart';
import 'package:assignwork/common/dao/BookingStatusDao.dart';
import 'package:assignwork/common/dao/ManageSectionDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/HomeDrawer.dart';
import 'package:assignwork/widget/dialog/CalendarSelectorDialog.dart';
import 'package:assignwork/widget/dialog/CustInfoListDialog.dart';
import 'package:assignwork/widget/dialog/SelectorDialog.dart';
import 'package:assignwork/widget/item/TrialResWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

///
///加裝頁面
///Date: 2020-01-30
class AddBookingViewPage extends StatefulWidget {

  static final String sName = 'addBooking';

  @override
  _AddBookingViewPageState createState() => _AddBookingViewPageState();
}

class _AddBookingViewPageState extends State<AddBookingViewPage> with BaseWidget{

  ///bottomNavigatorBar index
  int _bnbIndex = 0;
  ///條件查詢字樣
  String custTypeStr = '姓名';
  String custTypeCode = '1';
  List<String> custTypeArr = ['姓名','客編','電話'];
  ///記錄匹配完資料
  Map<String, dynamic> logMatchArr = {};
  ///裝客戶資料
  List<dynamic> custInfosArr = [];
  ///輸入框，客編，姓名，電話
  TextEditingController custController = TextEditingController();
  FocusNode custNode = FocusNode();
  TextEditingController descriptController = TextEditingController();
  FocusNode descriptNode = FocusNode();
  TextInputType custInputType = TextInputType.text;
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
  ///記錄所選約裝時間
  String bookingDateSelected = "";
  ///記錄試算結果金額
  Map<String, dynamic> logTrialArr = {"dtvMoney": "", "cmMoney": "", "installMoney": "", "buildMoney": "", "foregiftMoney": "", "additionalMoney": "", "networkCableMoney": "", "sumMoney": ""};
  ///判斷檢核完成後才能送出
  bool _isPkSend = false;
  ///判斷檢核試算欄位
  bool _isTrial = false;
  ///試算結果字串
  String resTrialStr = "";
  ///記錄套餐資料
  Map<String, dynamic> logProdInfo = {};
  ///scrollController
  ScrollController _scrollController = ScrollController();
  ///call back 回來的model 資料
  CustPurchasedInfosModel cpModel;


  ///下拉選單高度
   double _dropHeight(context) {
     var deviceHieght = titleHeight(context) * 1.3;
     if (Platform.isAndroid) {
       deviceHieght = titleHeight(context) * 1.5;
     }
     return deviceHieght;
   }

  ///變換條件查詢
  _changeSearchType(String str) {
    this.custController.text = "";
    switch(str) {
      case '姓名':
        setState(() {
          custInputType = TextInputType.text;
        });
        break;
      default:
        setState(() {
          custInputType = TextInputType.number;
        });
        break;
    }
  }
  ///******* call api s********/
  ///取得基本資料
  _getBaseData() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "getBaseListInfo";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    var res = await BaseDao.getBaseListInfo(paramMap,);
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
    }
    else {
      setState(() {
        this.isCalledSales = true;
      });
    }

  }
  ///取得地區產品資料
  _getProdInfoData() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "queryProductInfo";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["areaCode"] = this.logMatchArr["areaCode"];
    var res = await ManageSectionDao.getQueryProductInfo(paramMap);
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
  ///客戶列表
  _getCustDetailApi() async {
    CommonUtils.showLoadingDialog(context);
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = 'queryAddPurchaseCustomerInfos';
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["type"] = this.custTypeCode;
    paramMap["value"] = this.custController.text;
    var res = await BookingStatusDao.queryAddPurchaseCustomerInfos(paramMap, context);
    Navigator.pop(context);
    if (res.result) {
      setState(() {
        this.custInfosArr = res.data;
        ///如果資料是多筆，跳出dialog提供選擇
        if (this.custInfosArr.length > 1) {
          showDialog(
            context: context, 
            builder: (BuildContext context)=> _custInfoListSelectorDialog(context)
          );
        }
        else {
          this._isTrial = true;
          cpModel = CustPurchasedInfosModel.forMap(this.custInfosArr[0]);
          String address = cpModel.customerIofo.installAddress;
          String areaCode = CommonUtils.filterAreaCN(address.substring(3,6));
          Map<String, dynamic> map = Map<String, dynamic>();
          map["areaCode"] = areaCode;
          this.logMatchArr.addAll(map);
          _getProdInfoData();
        }
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
          this.dtvGiftArr.insert(0, {"month":"0"});
        }
        else {
          this.cmGiftArr = res.data;
          this.cmGiftArr.insert(0, {"month":"0"});
        }
      });
    }
  }
  ///試算
  _postTrailData() async {
    print(this.logMatchArr);
    bool isOk = validTrialParam();
    if (!isOk) { return;}  
    CommonUtils.showLoadingDialog(context);
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "trial";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["trialType"] = "2";
    paramMap["customerCode"] = cpModel.customerIofo.code;
    paramMap["bookingDate"] = this.bookingDateSelected;
    paramMap["dtvCode"] = this.dtvSelected;
    paramMap["dtvMonth"] = CommonUtils.filterMonthNm(this.dtvPaySelected);
    paramMap["cmCode"] = this.cmSelected;
    paramMap["cmMonth"] = CommonUtils.filterMonthNm(this.cmPaySelected);
    paramMap["allowanceMonth"] = "0";
    paramMap["isAlign"] = "N";
    paramMap["manageSectionCode"] = this.logMatchArr["areaCode"];
    paramMap["slaveNumber"] = this.slaveSelected == "" ? "0" : this.slaveSelected;
    paramMap["crossFloorNumber"] = this.crossFloorSelected == "" ? "0" : this.crossFloorSelected;
    paramMap["networkCableNumber"] = this.netCableSelected == "" ? "0" : this.netCableSelected;
    paramMap["additionalInfos"] = [];
    var res = await BookingSendDao.postTrail(paramMap);
    if(res.result) {
      if (res.data["RtnCD"] == "00") {
        Navigator.pop(context);
        CommonUtils.showToast(context, msg: '試算成功!');
        setState(() {
          this.resTrialStr = '試算成功!';
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
      }
      else {
        Navigator.pop(context);
          CommonUtils.showToast(context, msg: res.data["RtnMsg"]);
          setState(() {
            this.resTrialStr = res.data["RtnMsg"];
        });
        return;
      }
    }
  }
  ///加裝
  _postAddPurchase() async {
    CommonUtils.showLoadingDialog(context);
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    
    paramMap["dtvCode"] = this.dtvSelected;
    paramMap["dtvMonth"] = CommonUtils.filterMonthNm(this.dtvPaySelected);
    paramMap["cmCode"] = this.cmSelected;
    paramMap["cmMonth"] = CommonUtils.filterMonthNm(this.cmPaySelected);
    paramMap["isAlign"] = "N";
    paramMap["slaveNumber"] = this.slaveSelected == "" ? "0" : this.slaveSelected;
    paramMap["crossFloorNumber"] = this.crossFloorSelected == "" ? "0" : this.crossFloorSelected;
    paramMap["sumMoney"] = this.logTrialArr["sumMoney"];
    ///purchaseProductInfo:
    jsonMap["purchaseProductInfo"] = paramMap;

    paramMap = new Map<String, dynamic>();
    paramMap["bookingDate"] = this.bookingDateSelected;
    if (this.salesNameSelected == '') {
      paramMap["saleManCode"] = _getStore().state.userInfo.accNo;
    }
    else {
      paramMap["saleManCode"] = this.salesSelected;
    }
    paramMap["operator"] = _getStore().state.userInfo.accNo;
    paramMap["description"] = descriptController.text;
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
    }
    else {
      if (this.dtvGiftSelected != "") {
        paramMap["classification"] = "DTV";
        paramMap["type"] = "D";
        paramMap["month"] = CommonUtils.filterGiftMonthNm(this.dtvGiftSelected);
        saleGiftArr.add(paramMap);
      }
      else if (this.cmGiftSelected != "") {
        paramMap["classification"] = "CM";
        paramMap["type"] = "D";
        paramMap["month"] = CommonUtils.filterGiftMonthNm(this.cmGiftSelected);
        saleGiftArr.add(paramMap);
      }
    }
    paramMap = new Map<String, dynamic>();
    ///giftsInfo:
    paramMap["giftsInfo"] = saleGiftArr;

    paramMap["function"] = "addPurchase";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    jsonMap["customerCode"] = cpModel.customerIofo.code;

    paramMap["addPurchaseInfo"] = jsonMap;
    
    var res = await BookingSendDao.postAddPurchase(paramMap);
    Navigator.pop(context);
    if(res.result) {
      if (res.data["RtnCD"] == "00") {
        CommonUtils.showToast(context, msg: '立案成功！');
        Future.delayed(const Duration(milliseconds: 500),() {
          NavigatorUtils.goHome(context);
          return true;
        });
      }
      else {
        CommonUtils.showToast(context, msg: res.data["RtnMsg"]);
        return;
      }
    }
  }
  ///******* call api e********/
  ///多筆客戶選擇器
  _custInfoListSelectorDialog(BuildContext context) {
     return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Scaffold(
          body: CustInoListDialog(dataArray: this.custInfosArr, callBackFunc: _callBackFunc,)
        ),
      )
    );
  }
  ///callback
  void _callBackFunc(data) {
    setState(() {
      this._isTrial = true;
      this.logMatchArr.clear();
      this.cpModel = data;
      String address = cpModel.customerIofo.installAddress;
      String areaCode = CommonUtils.filterAreaCN(address.substring(3,6));
      Map<String, dynamic> map = Map<String, dynamic>();
      map["areaCode"] = areaCode;
      this.logMatchArr.addAll(map);
      _getProdInfoData();

    });
  }


  ///給calendar用function
  void _getBookingDateSelectFunc(String date) {
    setState(() {
      this.bookingDateSelected = date;
      print('加裝日期 -> ${this.bookingDateSelected}');
    });
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
        child: SelectorDialog(dataList: salesData, selectFunc: _selectFunc, findItemName: 'empName', labelTxt: '發展人', titleTxt: '選擇發展人', errTxt: '尚未選則發展人！', modelName: 'empName', modelVal: 'empNo',),
      )
    );
  }

  void _selectFunc(Map<String, dynamic> map) {
    setState(() {
      this.salesSelected = map["empNo"];
      this.salesNameSelected = map["empName"];
      
    });
  }

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

  Widget _bodyView() {

    Widget body;
    List<Widget> columnList = [];
    List<Widget> columnList2 = [];
    var bookingTime = "";
    if (this.bookingDateSelected != "") {
      DateFormat df = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime d = df.parse(this.bookingDateSelected);
      df = DateFormat("yy-MM-dd HH:mm");
      bookingTime = df.format(d);
    }
    if (cpModel != null) {
      ///如果是cm用戶
      if (cpModel.purchaseInfos.isPurchasedCm == 'Y') {
        this.cmNameSelected = '----';
        this.cmPaySelected = '----';
      }
      ///如果是dtv用戶
      if (cpModel.purchaseInfos.isPurchasedDtv == 'Y') {
        this.dtvNameSelected = '----';
        this.dtvPaySelected = '----';
      }
      
    }
    ///主要view包在scrollview裡面
    columnList.add(
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            child: Column(
              children: columnList2,
            ),
          ),
        ),
      ),
    );
    ///下拉選擇查詢類別
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: autoTextSize('▽' + custTypeStr, TextStyle(color: Colors.blue), context),
                onTap: () {
                  _showSelectorController(context, dataList: this.custTypeArr, title: '選擇查詢項目', dropStr: 'custType' );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                controller: custController,
                textInputAction: TextInputAction.done,
                keyboardType: this.custInputType,
                maxLength: 10,
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: this.custTypeStr,
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                  ),
                ),
                onChanged: (val) {

                },
              ),
            )
          ],
        )
        
      ),
    );
    ///查詢按鈕
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child:  ButtonTheme(
          height: titleHeight(context) * 1.2,
          minWidth: MediaQuery.of(context).size.width / 3,
          // buttonColor: Colors.blue,
          child: FlatButton(
            color: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text('查詢', style: TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              
              if (this.custController.text.length > 0) {
                _getCustDetailApi();
              }
              else {
                CommonUtils.showToast(context, msg: '尚未輸入欲查詢資料');
                return;
              }
            },
          ),
        ),
      ),
    );
    ///下底線
    columnList2.add(
      Container(
        color: Colors.grey,
        width: double.infinity,
        height: 1,
      )
    );
    ///加裝container
    columnList2.add(
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.grey)),color: Colors.pink[50]),
        child: autoTextSize('加裝', TextStyle(color: Colors.black, fontWeight: FontWeight.bold), context),
      ),
    );
    ///姓名,客編lable
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                      text: '姓名：',
                      style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
                      ),
                      TextSpan(
                        text: cpModel == null ? '' : cpModel.customerIofo.name,
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
                      )
                    ]
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                      text: '客編：',
                      style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
                      ),
                      TextSpan(
                        text: cpModel == null ? '' : custCodeEncode(cpModel.customerIofo.code),
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
                      )
                    ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ///地址label
    columnList2.add(
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
              text: '地址：',
              style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
              ),
              TextSpan(
                text: cpModel == null ? '' : addressEncode(cpModel.customerIofo.installAddress),
                style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
              )
            ]
          ),
        ),
      )
    );
    ///大樓label
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                      text: '大樓：',
                      style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
                      ),
                      TextSpan(
                        text: cpModel == null ? '' : cpModel.customerIofo.building,
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
                      )
                    ]
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                      text: '類別：',
                      style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
                      ),
                      TextSpan(
                        text: cpModel == null ? '' : cpModel.customerIofo.customerLevel,
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
                      )
                    ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ///有線,繳別下拉
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Colors.green[50]),
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
                        child: Text('有線', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                      ),
                      Expanded(
                        child: Text('${this.dtvNameSelected == '' ? '請選擇▿' : this.dtvNameSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                      ),
                    ],
                  ),
                    onTap: () async {
                      if(this.logMatchArr.length > 0) {
                        if(this.dtvNameSelected != '----')
                          _showSelectorController(context, dataList: this.dtvArr, title: '頻道類別', dropStr: 'dtv');
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
                        child: Text('繳別', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                      ),
                      Expanded(
                        child: Text('${this.dtvPaySelected == '' ? '請選擇▿' : this.dtvPaySelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                      ),
                    ],
                  ),
                  onTap: () async {
                    if (this.dtvSelected != "") {
                      if(this.dtvNameSelected != '----')
                       _showSelectorController(context, dataList: this.dtvPayArr, title: '繳費類型', dropStr: 'dtvPay');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ///cm,繳別下拉
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Colors.green[50]),
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
                        child: Text('CM', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                      ),
                      Expanded(
                        child: Text('${this.cmNameSelected == '' ? '請選擇▿' : this.cmNameSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                      ),
                    ],
                  ),
                    onTap: () async {
                      if(this.logMatchArr.length > 0) {
                        if(this.cmNameSelected != '----')
                         _showSelectorController(context, dataList: this.cmArr, title: 'CM類別', dropStr: 'cm');
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
                        child: Text('繳別', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                      ),
                      Expanded(
                        child: Text('${this.cmPaySelected == '' ? '請選擇▿' : this.cmPaySelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                      ),
                    ],
                  ),
                  onTap: () async {
                    if (this.cmNameSelected != "") {
                      if(this.cmNameSelected != '----')
                        _showSelectorController(context, dataList: this.cmPayArr, title: '繳費類型', dropStr: 'cmPay');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ///跨樓層,分機下拉
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Colors.green[50]),
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
                        child: Text('跨樓層', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                      ),
                      Expanded(
                        child: Text('${this.crossFloorSelected == '' ? '請選擇▿' : this.crossFloorSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                      ),
                    ],
                  ),
                    onTap: () async {
                      if(this.logMatchArr.length > 0)
                        _showSelectorController(context, dataList: this.crossFloorArr, title: '跨樓層', dropStr: 'crossFloor');
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
                        child: Text('分機', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                      ),
                      Expanded(
                        child: Text('${this.slaveSelected == '' ? '請選擇▿' : this.slaveSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                      ),
                    ],
                  ),
                  onTap: () async {
                    if(this.logMatchArr.length > 0) 
                      _showSelectorController(context, dataList: this.slaveArr, title: '分機', dropStr: 'slave');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ///日期,發展人下拉
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: _dropHeight(context),
                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: InkWell(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Text('裝機日期', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                      ),
                      Expanded(
                        child: Text('${bookingTime == '' ? '請選擇▿' : bookingTime }', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                      ),
                    ],
                  ),
                  onTap: () {
                    //  if (this.logMatchArr.length > 0)
                      showDialog(
                      context: context, 
                      builder: (BuildContext context)=> _calendarSelectorDialog(context)
                      );
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
                        child: Text('發展人', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                      ),
                      Expanded(
                        child: Text('${this.salesNameSelected == '' ? '請選擇▿' : this.salesNameSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (this.logMatchArr.length > 0)
                      showDialog(
                      context: context, 
                      builder: (BuildContext context)=> salesSelectorDialot(context)
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ///業務贈送
   /* columnList2.add(
      Container(
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
      ),
    );*/
    ///備註
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: TextField(
          controller: descriptController,
          textInputAction: TextInputAction.done,
          maxLines: 4,
          style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: '備註',
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
            ),
          ),
          onChanged: (val) {

          },
        ),
      ),
    );
    ///sizebox
    columnList2.add(
      SizedBox(height: 10,),
    );
    ///試算按鈕
    columnList2.add(
      ButtonTheme(
        height: titleHeight(context) * 1.3,
        minWidth: MediaQuery.of(context).size.width / 2,
        // buttonColor: Colors.blue,
        child: FlatButton(
          color: this._isTrial == true ? Colors.blue : Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text('試算', style: TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () async {
            if (_isTrial)
              _postTrailData();
          },
        ),
      ),
    );
    ///試算結果輸出
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: Center(
          child: autoTextSize(this.resTrialStr, TextStyle(color: Colors.red), context)
        ),
      ),
    );
    ///sizebox
    columnList2.add(
      SizedBox(height: 10,),
    );
    ///試算結果輸出
    columnList2.add(
      TrialResWidget(logTrialArr: this.logTrialArr, fromFunc: 'add',)
    );
    ///sizebox
    columnList2.add(
      SizedBox(height: 10,),
    );
    ///送出按鈕
    columnList2.add(
      ButtonTheme(
        height: titleHeight(context) * 1.3,
        minWidth: MediaQuery.of(context).size.width / 2,
        // buttonColor: Colors.blue,
        child: FlatButton(
          color: this._isPkSend == true ? Colors.blue : Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text('送出', style: TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () async {
            if(this._isPkSend)
            _postAddPurchase();
          },
        ),
      ),
    );
    body = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: columnList
      ),
    );
    
    return body;
  }

  ///Scaffold bottomBar
  Widget _bottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: autoTextSize('首頁', TextStyle(color: Colors.white), context)
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.search),
        //   title: autoTextSize('查詢', TextStyle(color: Colors.white), context)
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          title: autoTextSize('登出', TextStyle(color: Colors.white), context)
        ),
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
      if(mounted) {
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

   ///show日期選擇器
  Widget _calendarSelectorDialog(BuildContext context,) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Scaffold(
          body: CalendarSelectorDialog(bookingDate: this.bookingDateSelected, areaStr: CommonUtils.filterAreaCN('板橋區'), getBookingDate: _getBookingDateSelectFunc, fromFunc: 'book',)
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    this.custController.dispose();
    this.custNode.dispose();
    this.descriptController.dispose();
    this.descriptNode.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
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
        title: Text('加裝設備立案', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
      ),
      body: _bodyView(),
      bottomNavigationBar: _bottomNavBar()
    );
  }
  
  ///下拉選擇器
  _showSelectorController(BuildContext context, { List<dynamic> dataList, String title, String valName, String dropStr}) {
    FocusScope.of(context).unfocus();
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('選擇$title', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: _selectorActions(dataList: dataList, valName: valName, dropStr: dropStr)
        );
        return dialog;
      }
    );
  }

  ///選擇器Actions
  List<Widget> _selectorActions({List<dynamic> dataList, String valName, String dropStr}) {
    List<Widget> wList = [];
    if (dropStr != 'custType') {
      if (dataList != null && dataList.length > 0) {
        if (dropStr == "dtv" || dropStr == "cm") {
          for (var dic in dataList) {
            wList.add(
              CupertinoActionSheetAction(
                child: Text('${dic["name"]}', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
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
                        }
                        else {
                          this.dtvPaySelected = CommonUtils.filterMonthCN2('${this.dtvPayArr[0]}');
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
                        }
                        else {
                          this.cmPaySelected = CommonUtils.filterMonthCN2('${this.cmPayArr[0]}');
                        } 
                        this._getSalesGiftData('CM', cmSelected);
                        break;
                    }
                    Navigator.pop(context);
                  });
                },
              )
            );
          }
        }
        else if (dropStr == 'giftDTV' || dropStr == 'giftCM') {
          for (var dic in dataList) {
            dic = CommonUtils.filterGiftMonthCN('${dic["month"]}');
            wList.add(
              CupertinoActionSheetAction(
                child: Text('$dic', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
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
              )
            );
          }
        }
        else {
          for (var dic in dataList) {
            if (dropStr == "dtvPay" || dropStr == "cmPay") {
              dic = CommonUtils.filterMonthCN2('$dic');
            }
            wList.add(
              CupertinoActionSheetAction(
                child: Text('$dic', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
                onPressed: () {
                  setState(() {
                    switch (dropStr) {
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
              )
            );
          }
        }
      }
    }
    else {
      if (dataList != null && dataList.length > 0) {
        for (var dic in dataList) {
          wList.add(
            CupertinoActionSheetAction(
              child: Text(dic, style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
              onPressed: () {
                setState(() {
                  this.custTypeStr = dic;
                  switch(dic) {
                    case '姓名':
                      this.custTypeCode = "1";
                      break;
                    case '客編':
                      this.custTypeCode = "2";
                      break;
                    case '電話':
                      this.custTypeCode = "3";
                      break;
                  }
                  _changeSearchType(dic);
                  Navigator.pop(context);
                });
              },
            )
          );
        }
      }
    }
    return wList;
  }

  ///檢核欄位- 試算(trial)
  validTrialParam() {
   
    if (this.bookingDateSelected == "") {
      CommonUtils.showToast(context, msg: "尚未選擇裝機日期！");
      return false;
    }
    return true;

  }
}