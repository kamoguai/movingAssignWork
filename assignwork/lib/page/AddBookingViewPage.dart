import 'dart:io';

import 'package:assignwork/common/dao/BookingStatusDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/HomeDrawer.dart';
import 'package:assignwork/widget/dialog/CustInfoListDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

///
///加裝頁面
///Date: 2020-01-30
class AddBookingViewPage extends StatefulWidget {
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
  ///裝客戶資料
  List<dynamic> custInfosArr = [];
  ///輸入框，客編，姓名，電話
  TextEditingController custController = TextEditingController();
  FocusNode custNode = FocusNode();
  TextInputType custInputType = TextInputType.text;
  ///記錄有線產品下拉
  List<dynamic> dtvArr = [];
  String dtvSelected = "";
  String dtvNameSelected = "";
  ///記錄有線繳別下拉
  List<dynamic> dtvPayArr = [];
  String dtvPaySelected = "";
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

  _getCustDetailApi() async {
    CommonUtils.showLoadingDialog(context);
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = 'queryAddPurchaseCustomerInfos';
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["type"] = this.custTypeCode;
    paramMap["value"] = this.custController.text;
    var res = await BookingStatusDao.queryAddPurchaseCustomerInfos(paramMap);
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
          cpModel = CustPurchasedInfosModel.forMap(this.custInfosArr[0]);
        }
      });
    }
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

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

  Widget _bodyView() {

    Widget body;
    List<Widget> columnList = [];
    List<Widget> columnList2 = [];

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
                focusNode: custNode,
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
                Fluttertoast.showToast(msg: '尚未輸入欲查詢資料');
                return;
              }
            },
          ),
        ),
      ),
    );

    columnList2.add(
      Container(
        color: Colors.grey,
        width: double.infinity,
        height: 1,
      )
    );
    
    columnList2.add(
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.grey)),color: Colors.pink[50]),
        child: autoTextSize('加裝', TextStyle(color: Colors.black, fontWeight: FontWeight.bold), context),
      ),
    );

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
                        text: cpModel == null ? '' : cpModel.customerIofo.code,
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
                text: cpModel == null ? '' : cpModel.customerIofo.installAddress,
                style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)), 
              )
            ]
          ),
        ),
      )
    );

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
                      if(this.logMatchArr.length > 0)
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        for (var dic in dataList) {
          wList.add(
            CupertinoActionSheetAction(
              child: Text('${dic["name"]}', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
              onPressed: () {
                setState(() {
                  switch (dropStr) {
                    case 'custType':
                      
                      
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
}