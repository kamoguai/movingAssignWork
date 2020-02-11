
import 'dart:io';

import 'package:assignwork/common/dao/BookingSendDao.dart';
import 'package:assignwork/common/dao/BookingStatusDao.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/widget/dialog/CalendarSelectorDialog.dart';
import 'package:assignwork/widget/dialog/CustInfoListDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import 'package:assignwork/common/dao/MaintainDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:redux/redux.dart';
import 'package:assignwork/widget/HomeDrawer.dart';
///
/// 維修報修頁面
/// Date: 2020/01/27
class MaintainReportPage extends StatefulWidget {

  static final String sName = 'maintain';

  @override
  _MaintainReportPageState createState() => _MaintainReportPageState();
}

class _MaintainReportPageState extends State<MaintainReportPage> with BaseWidget{

  ///bottomNavigatorBar index
  int _bnbIndex = 0;
  ///類型type
  List<dynamic> dropTypeList = [];
  String selectedType = "";
  String selectedTypeName = "";
  ///類型code
  List<dynamic> dropCodeList = [];
  List<dynamic> originCodeList = [];
  String selectedCode = "";
  String selectedCodeName = "";
  ///日期選擇
  String bookingDateSelected = "";
   ///條件查詢字樣
  String custTypeStr = '姓名';
  String custTypeCode = '1';
  List<String> custTypeArr = ['姓名','客編','電話'];
  ///裝客戶資料
  List<dynamic> custInfosArr = [];
  ///送出回覆字串
  String sendResStr = "";
  ///檢核欄位
  bool isValid = false;
  ///call back 回來的model 資料
  CustPurchasedInfosModel cpModel;
  ///客編controller
  TextEditingController custController = TextEditingController();
  final custNode = FocusNode();
  TextInputType custInputType = TextInputType.text;
  ///備註controller
  TextEditingController descriptController = TextEditingController();
  final descriptNode = FocusNode();
  ScrollController _scrollController = ScrollController();


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

  ///取得維修下拉data
  _getDropDownList() async {

    var res = await MaintainDao.getBossPhenData();
    if (res.result) {
      originCodeList = res.data["codes"];
      dropTypeList = res.data["typeCodes"];
    }

  }
  //********* call api  s*/
  ///維修派單
  _postMaintainApi() async {
    CommonUtils.showLoadingDialog(context);
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap["customerCode"] = cpModel.customerIofo.code;
    jsonMap["operatorCode"] = _getStore().state.userInfo?.accNo;
    jsonMap["phenomenonTypeCode"] = this.selectedType;
    jsonMap["phenomenonCode"] = this.selectedCode;
    jsonMap["bookingDate"] = this.bookingDateSelected;
    jsonMap["description"] =  this.descriptController.text;
    var res = await BookingSendDao.postOrderReportFault(jsonMap, context);
    Navigator.pop(context);
    if (res.result) {
      if (res.data["rtnCD"] == "00") {
        CommonUtils.showToast(context, msg: '派單成功！');
        Future.delayed(const Duration(milliseconds: 500),() {
          NavigatorUtils.goHome(context);
          return true;
        });
      }
      else {
        CommonUtils.showToast(context, msg: res.data["rtnMsg"]);
        setState(() {
          this.sendResStr = res.data["rtnMsg"];
        });
        return;
      }
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
          this.cpModel = CustPurchasedInfosModel.forMap(this.custInfosArr[0]);
        }
      });
    }
  }
  //********* call api  e*/
  Store<SysState> _getStore() {
   return StoreProvider.of(context);
  }

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
      this.cpModel = data;
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
  _bodyView() {
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
    ///客戶資料container
    columnList2.add(
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.grey)),color: Colors.pink[50]),
        child: autoTextSize('客戶資料', TextStyle(color: Colors.black, fontWeight: FontWeight.bold), context),
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
        // decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
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
    ///問題回報container
    columnList2.add(
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.grey)),color: Colors.pink[50]),
        child: autoTextSize('問題回報', TextStyle(color: Colors.black, fontWeight: FontWeight.bold), context),
      ),
    );
    ///問題類別dropdown
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5,),
        width: double.infinity,
        height: _dropHeight(context),
        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid), bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Color(MyColors.hexFromStr('d0e1f3')),
                  child: Text('問題類別', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                ),
              ),
              Expanded(
                child: Text('${this.selectedTypeName == '' ? '請選擇▿' : this.selectedTypeName}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
              )
            ],
          ),
          onTap: () async {
            _showSelectorController(context, dataList: this.dropTypeList, title: '問題類型', dropStr: 'type');
          },
        ),
      ),
    );
    ///問題狀態dropdown
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        width: double.infinity,
        height: _dropHeight(context),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Color(MyColors.hexFromStr('d0e1f3')),
                  child: Text('問題狀態', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                )
              ),
              Expanded(
                child: Text('${this.selectedCodeName == '' ? '請選擇▿' : this.selectedCodeName}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
              )
            ],
          ),
          onTap: () async {
            _showSelectorController(context, dataList: this.dropCodeList, title: '問題狀態', dropStr: 'code');
          },
        ),
      ),
    );
    ///日期選擇器
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        width: double.infinity,
        height: _dropHeight(context),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Color(MyColors.hexFromStr('d0e1f3')),
                  child: Text('預約日期', style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),),
                )
              ),
              Expanded(
                child: Text('${bookingTime == '' ? '請選擇▿' : bookingTime}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
              )
            ],
          ),
          onTap: () {
            showDialog(
              context: context, 
              builder: (BuildContext context)=> _calendarSelectorDialog(context)
            );
          },
        ),
      ),
    );
    ///備註輸入框
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: TextFormField(
          controller: descriptController,
          textInputAction: TextInputAction.done,
          focusNode: descriptNode,
          maxLines: 4,
          style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: '備註',
            hintText: '請輸入備註',
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
            )
          ),
          onFieldSubmitted: (val) {
            
          },
          
        ),
      ),
    );
    if (this.sendResStr != "") {
      ///送出結果輸出
      columnList2.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: Center(
            child: autoTextSize(this.sendResStr, TextStyle(color: Colors.red), context)
          ),
        ),
      );
    }
    columnList2.add(
      ButtonTheme(
        height: titleHeight(context) * 1.3,
        minWidth: MediaQuery.of(context).size.width / 2,
        // buttonColor: Colors.blue,
        child: FlatButton(
          color: Colors.blue ,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text('送出', style: TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () async {
            _isValidParam();
            if(isValid)
            _postMaintainApi();
          },
        ),
      )
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
          body: CalendarSelectorDialog(bookingDate: this.bookingDateSelected, areaStr: CommonUtils.filterAreaCN('板橋區'), getBookingDate: _getBookingDateSelectFunc, fromFunc: 'maintain',)
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _getDropDownList();
  }

  @override
  void dispose() {
    this.dropCodeList.clear();
    this.dropTypeList.clear();
    this.originCodeList.clear();
    this.custController.dispose();
    this.descriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('維修派單', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
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
          for (var dic in dataList) {
            wList.add(
              CupertinoActionSheetAction(
                child: Text('${dic["name"]}', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
                onPressed: () {
                  setState(() {
                    switch (dropStr) {
                      case 'type':
                        this.selectedType = dic['bossCode'];
                        this.selectedTypeName = dic["name"];
                        this.dropCodeList.clear();
                        for (var dis in this.originCodeList) {
                          if (dis['typeCode'].contains(this.selectedType)) {
                            this.dropCodeList.add(dis);
                          }
                        }
                        break;
                      case 'code': 
                        this.selectedCode = dic["bossCode"];
                        this.selectedCodeName = dic["name"];
                        break;
                    } 
                    isLoading = true;
                    Navigator.pop(context);
                  });
                },
              )
            );
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

  _isValidParam() {
    bool v = false;
    if (this.custController.text.length == 0) {
      CommonUtils.showToast(context, msg: '尚未輸入查詢條件！');
      v = false;
    }
    else if (this.descriptController.text.length == 0) {
      CommonUtils.showToast(context, msg: '尚未輸入備註！');
      v = false;
    }
    else if (this.selectedType == "") {
      CommonUtils.showToast(context, msg: '問題類型尚未選擇！');
      v = false;
    }
    else if (this.selectedCode == "") {
      CommonUtils.showToast(context, msg: '問題狀態尚未選擇！');
      v = false;
    }
    else if (this.bookingDateSelected == "") {
       CommonUtils.showToast(context, msg: '預約日期尚未選擇！');
      v = false;
    }
    else {
      v = true;
    }
    setState(() {
      this.isValid = v;
    });
  }
}