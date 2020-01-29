
import 'dart:io';

import 'package:assignwork/common/dao/BookingSendDao.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/widget/dialog/CalendarSelectorDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../common/dao/MaintainDao.dart';
import '../common/redux/SysState.dart';
import '../common/style/MyStyle.dart';
import '../common/style/MyStyle.dart';
import '../common/utils/NavigatorUtils.dart';
import '../widget/BaseWidget.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../widget/HomeDrawer.dart';
///
/// 維修報修頁面
/// Date: 2020/01/27
class MaintainReportPage extends StatefulWidget {

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
  ///檢核欄位
  bool isValid = false;
  ///客編controller
  TextEditingController custCodeController = TextEditingController();
  final custNode = FocusNode();
  ///備註controller
  TextEditingController descriptController = TextEditingController();
  final descriptNode = FocusNode();
  ScrollController _scrollController = ScrollController();


  ///鍵盤config
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: custNode,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(child: autoTextSize('完成', TextStyle(color: Colors.black), context))
          ),
        ),
        KeyboardAction(
          focusNode: descriptNode,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(child: autoTextSize('完成', TextStyle(color: Colors.black), context))
          ),
        ),
      ]
    );
  }

  ///下拉選單高度
  double _dropHeight(context) {
    var deviceHieght = titleHeight(context) * 1.3;
    if (Platform.isAndroid) {
      deviceHieght = titleHeight(context) * 1.5;
    }
    return deviceHieght;
  }

  ///取得維修下拉data
  _getDropDownList() async {

    var res = await MaintainDao.getBossPhenData();
    if (res.result) {
      originCodeList = res.data["codes"];
      dropTypeList = res.data["typeCodes"];
    }

  }

  ///維修派單
  _postMaintainApi() async {
    CommonUtils.showLoadingDialog(context);
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap["customerCode"] = this.custCodeController.text;
    jsonMap["operatorCode"] = _getStore().state.userInfo?.accNo;
    jsonMap["phenomenonTypeCode"] = this.selectedType;
    jsonMap["phenomenonCode"] = this.selectedCode;
    jsonMap["bookingDate"] = this.bookingDateSelected;
    jsonMap["description"] =  this.descriptController.text;
    var res = await BookingSendDao.postOrderReportFault(jsonMap);
    Navigator.pop(context);
    if (res.result) {
      if (res.data["rtnCD"] == "00") {
        Fluttertoast.showToast(msg: '派單成功！');
        Future.delayed(const Duration(milliseconds: 500),() {
          NavigatorUtils.goHome(context);
          return true;
        });
      }
      else {
        Fluttertoast.showToast(msg: res.data["rtnMsg"]);
        return;
      }
    }
    
  }

  Store<SysState> _getStore() {
   return StoreProvider.of(context);
  }

   ///給calendar用function
  void _getBookingDateSelectFunc(String date) {
    setState(() {
      this.bookingDateSelected = date;
      print('新約日期 -> ${this.bookingDateSelected}');
    });
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
    this.custCodeController.dispose();
    this.descriptController.dispose();
    super.dispose();
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
        child: KeyboardActions(
          config: _buildConfig(context),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            child: Column(
              children: columnList2,
            ),
          ),
        )
      ),
    );

    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: TextFormField(
          controller: custCodeController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          focusNode: custNode,
          maxLines: 1,
          style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: '客編',
            hintText: '請輸入客編',
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
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
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
                child: Text('${this.bookingDateSelected == '' ? '請選擇▿' : this.bookingDateSelected}', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
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
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: TextFormField(
          controller: descriptController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
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
          body: CalendarSelectorDialog(bookingDate: this.bookingDateSelected, areaStr: CommonUtils.filterAreaCN('板橋區'), getBookingDate: _getBookingDateSelectFunc,)
        ),
      )
    );
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
    return wList;
  }

  _isValidParam() {
    bool v = false;
    if (this.custCodeController.text.length == 0) {
      Fluttertoast.showToast(msg: '尚未輸入客編！');
      v = false;
    }
    else if (this.descriptController.text.length == 0) {
      Fluttertoast.showToast(msg: '尚未輸入備註！');
      v = false;
    }
    else if (this.selectedType == "") {
      Fluttertoast.showToast(msg: '問題類型尚未選擇！');
      v = false;
    }
    else if (this.selectedCode == "") {
      Fluttertoast.showToast(msg: '問題狀態尚未選擇！');
      v = false;
    }
    else if (this.bookingDateSelected == "") {
       Fluttertoast.showToast(msg: '預約日期尚未選擇！');
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