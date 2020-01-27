
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
  ///客編controller
  TextEditingController custCodeController = TextEditingController();
  final custNode = FocusNode();
  ///備註controller
  TextEditingController descriptController = TextEditingController();
  final descriptNode = FocusNode();


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

    Store<SysState> _getStore() {
    return StoreProvider.of(context);
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
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          height: _dropHeight(context) * 1.5,
          child: KeyboardActions(
            config: _buildConfig(context),
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
        ),
        Container(
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
        Container(
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
        Container(
          height: _dropHeight(context) * 3,
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: KeyboardActions(
            config: _buildConfig(context),
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
        ),
        
        Container(
          child: FlatButton(
            color: Colors.blue,
            child: Text('送出', style: TextStyle(fontSize: MyScreen.defaultTableCellFontSize(context)),),
            onPressed: () {
              print('custCode: ${custCodeController.text}, typeCode: $selectedType, code: $selectedCode, descript: ${descriptController.text}');
            },
          ),
        ),
      ],
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
}