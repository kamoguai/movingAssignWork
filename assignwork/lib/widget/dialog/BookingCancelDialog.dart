import 'package:assignwork/common/dao/BookingStatusDao.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
///
///約裝撤銷popup
///Date: 2019-10-22
class BookingCancelDialog extends StatefulWidget {

  ///由前頁傳入-使用者帳號
  final String accNo;
  ///由前頁傳入-工單號
  final String wkNo;

  BookingCancelDialog({this.accNo, this.wkNo});

  @override
  _BookingCancelDialogState createState() => _BookingCancelDialogState();
}

class _BookingCancelDialogState extends State<BookingCancelDialog> with BaseWidget{
  ///裝api回傳data供下拉選單使用
  List<dynamic> reasonType = [];
  ///原始資料
  List<dynamic> oringinInfo = [];
  ///裝api回傳data供下拉選單使用
  List<dynamic> reasonInfo = [];

  String reasonTypeCode = "";
  String reasonTypeName = "";
  String reasonInfoCode = "";
  String reasonInfoName = "";
  ///輸入內文
  String inputText = "";

  @override
  void initState() {
    super.initState();
    initParam();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///初始化資料
  initParam() {
    _getCancelData();
  }

  ///取得撤銷原因
  _getCancelData() async {
    this.reasonType = [];
    Map<String,dynamic> paramMap = new Map<String,dynamic>();
    paramMap["function"] = "queryCancelBaseInfo";
    paramMap["accNo"] = widget.accNo;
    var res = await BookingStatusDao.getQueryCancelBaseInfo(paramMap);
    if (res != null && res.result) {
      var resData = res.data["cancelBaseInfo"];
      // cim = CancelInfoModel.forMap(resData);
      this.oringinInfo = resData;
      for (var dic in resData) {
        this.reasonType.add(dic["reasonType"]);
      }
      print('撤銷頁面res -> ${this.reasonType}');
    }
  }

  ///送出撤銷action
  _sendAction(inputField, reasonCode) async {
    if (inputField == '') {
      Fluttertoast.showToast(msg: '撤銷原因必填！');
      return ;
    }
    if (reasonCode == "" || reasonCode == "原因▼") {
      Fluttertoast.showToast(msg: '尚未選擇原因！');
      return ;
    }
    Map<String, dynamic> paramsMap = new Map<String, dynamic>();
    paramsMap["function"] = "cancelWorkOrder";
    paramsMap["accNo"] = widget.accNo;
    paramsMap["operator"] = widget.accNo;
    paramsMap["workorderCode"] = widget.wkNo;
    paramsMap["description"] = inputField;
    paramsMap["reasonCode"] = reasonCode;
    var res = await BookingStatusDao.cancelWorkOrder(paramsMap);
    if (res.result) {
      Future.delayed(const Duration(seconds: 1),() {
        NavigatorUtils.goHome(context);
      });
      // Navigator.pop(context);
    }

  }

  ///原因類型選擇器
  _showSelectorReasonTypeController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('選擇原因類型', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: reasonTypeActions(),
        );
        return dialog;
      }
    );
  }

  ///原因類型選擇Actions
  List<Widget> reasonTypeActions() {
    List<Widget> wList = [];
    for (var dic in this.reasonType) {
      wList.add(
        CupertinoActionSheetAction(
          child: Text(dic["name"], style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () {
            setState(() {
              this.reasonTypeCode = dic["code"];
              this.reasonTypeName = dic["name"];
              _getReasonInfo(this.reasonTypeCode);
              Navigator.pop(context);
            });
          },
        )
      );
    }
    return wList;
  }
  
  ///解析reasonType下的reasonInfos
  _getReasonInfo(String str) {
    for (var dic in this.oringinInfo) {
      var rt = (dic["reasonType"] as Map<String,dynamic>);
      var rtCode = rt["code"] as String;
      if (rtCode == str) {
        this.reasonInfo = dic["reasonInfos"];
      }
    }
  }

  ///原因選擇器
  _showSelectorReasonInfoController(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('選擇原因', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: reasonInfoActions(),
        );
        return dialog;
      }
    );
  }
  
  ///原因選擇Actions
  List<Widget> reasonInfoActions() {
    List<Widget> wList = [];
    for (var dic in this.reasonInfo) {
      wList.add(
        CupertinoActionSheetAction(
          child: Text(dic["name"], style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          onPressed: () {
            setState(() {
              this.reasonInfoCode = dic["code"];
              this.reasonInfoName = dic["name"];
              Navigator.pop(context);
            });
          },
        )
      );
    }
    return wList;
  }

  @override
  Widget build(BuildContext context) {

    Widget body;
    List<Widget> columnList = [];
    columnList.add(
      Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            autoTextSize('撤銷處理', TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context) * 1.5), context),
            GestureDetector(
              child: Icon(Icons.cancel, color: Colors.blue, size: titleHeight(context) * 1.3,),
              onTap: () {
                Navigator.pop(context);
              },
            )
            
          ],
        ),
      ),
    );
    columnList.add(
      Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
        child: TextField(
          textInputAction: TextInputAction.done,
          maxLines: 4,
          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: '撤銷原因',
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
            )
          ),
          onChanged: (String value) {
            inputText = value;
            print(inputText);
          },
        ),
      ),
    );

    columnList.add(
      Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
        color: Color(MyColors.hexFromStr('d0e1f3')),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: autoTextSize('原因類型:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: autoTextSize('${this.reasonTypeName == '' ? '原因類型▼' : this.reasonTypeName}', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)), context),
                      ),
                      onTap: () {
                        _showSelectorReasonTypeController(context);
                      },
                    )
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: autoTextSize('原因:', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: autoTextSize('${this.reasonInfoName == '' ? '原因▼' : this.reasonInfoName}', TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)), context),
                      ),
                      onTap: () async {
                        _showSelectorReasonInfoController(context);
                      },
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    columnList.add(
      Center(
        child: Container(
          width: deviceWidth3(context),
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: autoTextSize('送出', TextStyle(fontSize: MyScreen.homePageFontSize(context)),context),
            onPressed: () {
              if (reasonTypeName == '原因類型▼') {
                Fluttertoast.showToast(msg: '請選擇原因類型');
                return;
              }
              if (reasonInfoName == '原因▼') {
                Fluttertoast.showToast(msg: '請選擇原因');
                return;
              }
              _sendAction(inputText, this.reasonInfoCode);
            },
          ),
        ),
      )
    );

    body = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: columnList,
      ),
    );

    return body;
    
  }
}
