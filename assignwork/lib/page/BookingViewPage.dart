
import 'package:assignwork/common/dao/BaseDao.dart';
import 'package:assignwork/common/dao/ManageSectionDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/HomeDrawer.dart';
import 'package:assignwork/widget/dialog/CalendarSelectorDialog.dart';
import 'package:assignwork/widget/dialog/CustDetailSelectDialog.dart';
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

class _BookingViewPageState extends State<BookingViewPage> with BaseWidget{
  ScrollController _scrollController = new ScrollController();
  TextEditingController _editingController = new TextEditingController();

  ///bottomNavigatorBar index
  int _bnbIndex = 0;
  ///記錄競業arr
  List<dynamic> industyArr = [];
  String industySelected = "";
  ///記錄有線產品下拉
  List<dynamic> dtvArr = [];
  String dtvSelected = "";
  String dtvNameSelected = "";
  ///記錄有線繳別下拉
  List<dynamic> dtvPayArr = [];
  String dtvPaySelected = "";
  ///記錄加購產品下拉
  List<dynamic> dtvAddProdArr = [];
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
  ///記錄匹配完資料
  Map<String, dynamic> logMatchArr = {};
  ///記錄套餐資料
  Map<String, dynamic> logProdInfo = {};
  ///記錄所選約裝時間
  String bookingDateSelected = "";
  ///判斷檢核完成後才能送出
  bool _isPkSend = false;

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

   ///下拉選單高度
   double _dropHeight(context) {
     return titleHeight(context) * 1.3;
   }
  
  ///取得競業資料
  _getIndustryData() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "getIndustryList";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["areaCode"] = "220/ROOT";
    var res = await BaseDao.getIndustryList(paramMap);
    if (res.result) {

      var data = res.data["industryList"];
      data.insert(0,'');
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
  
  ///給客戶詳情輸入用function
  void _getMatchDataFunc(Map<String, dynamic> map) async {
    setState(() {
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
  

  ///Scaffold body
  Widget _bodyView() {
    var telphone = "";
    var bookingTime = "";
    if (this.logMatchArr["mobile"] != null) {
      telphone += this.logMatchArr["mobile"];
    }
    if (this.logMatchArr["telPhone"] != null && this.logMatchArr["telPhone"] != "") {
      if (this.logMatchArr["mobile"] != null) {
        telphone += " , ";  
      }
      telphone += this.logMatchArr["telAreaCode"] + this.logMatchArr["telPhone"];
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
                builder: (BuildContext context)=> _custDetailSelectorDialog(context)
              );
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
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
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                                ),
                                TextSpan(
                                  text: this.logMatchArr["custName"] == null ? '' : this.logMatchArr["custName"],
                                  style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
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
                              children: <TextSpan>[
                                TextSpan(
                                text: '客編：',
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                                ),
                                TextSpan(
                                  text: '',
                                  style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '電話：',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                        ),
                        TextSpan(
                          text: telphone,
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                        ),
                      ]
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '地址：',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                        ),
                        TextSpan(
                          text: this.logMatchArr["fullAddress"] == null ? "" : this.logMatchArr["fullAddress"],
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                        ),
                      ]
                    ),
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
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          // decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                text: '大樓：',
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                                ),
                                TextSpan(
                                  text: this.logMatchArr["buildingName"] == null ? "" : this.logMatchArr["buildingName"] ,
                                  style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context)), 
                                ),
                              ]
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: _dropHeight(context),
                          decoration: BoxDecoration(border: Border(left: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          padding: EdgeInsets.only(left: 5.0),
                          child: InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Text('競業', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                                ),
                                Expanded(
                                  child: Text('${this.industySelected == '' ? '請選擇▿' : this.industySelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                )
                              ],
                            ),
                            onTap: () async {
                              _showSelectorController(context, dataList: this.industyArr, title: '競業', dropStr: 'industy');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                _showSelectorController(context, dataList: this.dtvArr, title: '頻道類別', dropStr: 'dtv');
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
                                _showSelectorController(context, dataList: this.dtvPayArr, title: '繳費類型', dropStr: 'dtvPay');
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
                                  child: Text('加購', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                                ),
                                Expanded(
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {},
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
                                  child: Text('分機', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                                ),
                                Expanded(
                                  child: Text(this.slaveSelected == '' ? '請選擇▿' : this.slaveSelected + ' 台', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.dtvSelected != "") {
                                _showSelectorController(context, dataList: this.slaveArr, title: '分機', dropStr: 'slave');
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
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Colors.cyan[50]),
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
                                  child: Text('${this.cmNameSelected == "" ?  '請選擇▿' : this.cmNameSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () async{ 
                              _showSelectorController(context, dataList: this.cmArr, title: '寬頻服務類別', dropStr: 'cm');
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
                                  child: Text('${this.cmPaySelected == "" ? '請選擇▿' : this.cmPaySelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () async {  
                              if (this.cmSelected != "") {
                                _showSelectorController(context, dataList: this.cmPayArr, title: '繳費類型', dropStr: 'cmPay');
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
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
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
                                  child: Text(this.crossFloorSelected == '' ? '請選擇▿' : this.crossFloorSelected + ' 層', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.dtvSelected != "" && this.slaveSelected != "") {
                                _showSelectorController(context, dataList: this.crossFloorArr, title: '跨樓層', dropStr: 'crossFloor');
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
                                  child: Text('網路線', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                                ),
                                Expanded(
                                  child: Text(this.netCableSelected == '' ? '請選擇▿' : this.netCableSelected + ' 條', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (this.cmSelected != "") {
                                _showSelectorController(context, dataList: this.netCableArr, title: '網路線', dropStr: 'netCable');
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
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {},
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
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: TextField(
                    controller: _editingController,
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
              ],
            ),
          ),
          SizedBox(height: 10,),
          ButtonTheme(
            height: titleHeight(context) * 1.3,
            minWidth: MediaQuery.of(context).size.width / 2,
            // buttonColor: Colors.blue,
            child: FlatButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('試算', style: TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),),
              onPressed: () async {

              },
            ),
          ),
                    
          ///todo: 試算結果
          
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid), top: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                   decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child:  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '有線：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '寬頻：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                   decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child:  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '加購：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '押金：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                   decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child:  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '裝機費：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '跨樓層：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                   decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child:  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '網路線：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.yellow[100],
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '合計：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            alignment: Alignment.center,
            child: Text('送出後不能更改，請確認資料完整性。', style: TextStyle(color: Colors.red, fontSize: MyScreen.defaultTableCellFontSize(context)),),
          ),
          SizedBox(height: 10,),
          ButtonTheme(
            height: titleHeight(context) * 1.3,
            minWidth: MediaQuery.of(context).size.width / 2,
            // buttonColor: Colors.blue,
            child: FlatButton(
              color: this._isPkSend == true ? Colors.blue : Colors.grey[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('送出', style: TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),),
              onPressed: () async {

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
  Widget _custDetailSelectorDialog(BuildContext context,) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Scaffold(
          body: CustDetailSelectDialog(getMatchDataFunc: _getMatchDataFunc, logMatchAddr: this.logMatchArr,)
        ),
      )
    );
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
          body: CalendarSelectorDialog(bookingDate: this.bookingDateSelected, areaStr: CommonUtils.filterAreaCN('板橋區'), getBookingDate: _getBookingDateSelectFunc,)
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
    this._editingController.dispose();
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
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('新戶約裝', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
      ),
      body: _bodyView(),
      bottomNavigationBar: _bottomNavBar()
    );
  }

  ///下拉選擇器
  _showSelectorController(BuildContext context, { List<dynamic> dataList, String title, String valName, String dropStr}) {
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
                        this.slaveSelected = "";
                        this.crossFloorSelected = "";
                      }
                      else {
                        this.dtvPaySelected = CommonUtils.filterMonthCN2('${this.dtvPayArr[0]}');
                      }
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
            )
          );
        }
      }
    }
    return wList;
  }
}