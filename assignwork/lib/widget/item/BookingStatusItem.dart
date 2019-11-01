
import 'package:assignwork/common/model/BookingStatusTableCell.dart' as prefix0;
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/dialog/BookingCancelDialog.dart';
import 'package:assignwork/widget/dialog/BookingStatusDetailDialog.dart';
import 'package:assignwork/widget/dialog/CalendarSelectorDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


///
///約裝狀態查詢item
///Date: 2019-10-14
///
class BookingStatusItem extends StatelessWidget with BaseWidget{
  ///api回傳資料
  final BookingItemModel model;
  ///使用者編號
  final String accNo;
  ///使用者名稱
  final String accName;
  ///部門編號
  final String deptId;
  ///api傳入資料，查詢類型
  final String bookingType;
  ///由前頁呼叫的function
  final Function detailEvent;
  ///由前頁呼叫的function
  final Function getIndustry;

  BookingStatusItem({this.accName, this.accNo, this.deptId, this.bookingType, this.model, this.detailEvent, this.getIndustry});
  
  ///height 分隔線
  _containerHeightLine() {
    return Container(height: 20, width: 1, color: Colors.grey,);
  }

  ///confirm功能
  static Future<Null> showConfirmDialog(BuildContext context, String titleStr, String contentStr) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(titleStr, style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
          content: new Text(contentStr, style: TextStyle(fontSize: ScreenUtil().setSp(16)),),
          actions: <Widget>[
            CupertinoButton(
                onPressed: (){
                  Fluttertoast.showToast(msg: contentStr);
                },
                child: Text('確定', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(20)),),
            ),
            CupertinoButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('取消', style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(20)),),
            ),
          ],
        );
      }
    );
  }

  ///詳情popup
  Widget _detailPopDialog(BuildContext context, bookingType) {

    List<Widget> columnList() {
      List<Widget> list = [
        Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: BookingStatusDetailDialog(bookingType: bookingType, model: model, accNo: accNo,),
        ),
      ];
      switch (bookingType) {
        case "1":
          List<Widget> type1 = [
            SizedBox(height: 20.0,),
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.maxFinite,
                height: 75,
                child: Column(
                  children: <Widget>[
                    autoTextSize('撤銷後不得再派裝，請小心使用', TextStyle(color: Colors.red), context),
                    FlatButton(
                      color: Colors.red[300],
                      onPressed: (){
                        Navigator.pop(context);
                        showDialog(
                          context: context, 
                          builder: (BuildContext context)=> _bookingCancelDialog(context,)
                        );
                      },
                      child: autoTextSize('撤銷', TextStyle(color: Colors.white), context),
                    ),
                  ],
                ),
              ),
            ),
          ];
          list.addAll(type1);
          break;
        case "2":
          break;
        case "3":
          break;
        case "4":
          break;
      }
      return list;
    }

    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: columnList()
      ),
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
        child: CalendarSelectorDialog(bookingDate: model.bookingDate,)
      )
    );
  }

  ///約裝撤銷dialog
  Widget _bookingCancelDialog(BuildContext context, ) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        child: BookingCancelDialog(accNo: accNo, wkNo: model.workorderCode,)
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    DateFormat dft = new DateFormat('yyyy-MM-dd HH:mm:ss');
    var bookingDate;
    if (model != null) {
      ///將約裝日期formate成自己要的格式
      bookingDate = dft.parse(model.bookingDate);
      dft = new DateFormat('yy-MM-dd (HH:mm)');
      bookingDate = dft.format(bookingDate);
    }
    ///通用欄位畫面
    List<Widget> commonList(context) {
      List<Widget> list = [
        GestureDetector(
          onTap: (){
            showDialog(
              context: context, 
              builder: (BuildContext context)=> _detailPopDialog(context,bookingType)
            );
          },
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: autoTextSize('姓名: ', TextStyle(color: Colors.black), context),
                          ),
                          Flexible(
                            flex: 2,
                            child: autoTextSize(model.name, TextStyle(color: Colors.grey[700]), context),
                          ),
                        ],
                      ),
                    ),
                    _containerHeightLine(),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: autoTextSize('客編: ', TextStyle(color: Colors.black), context),
                          ),
                          Flexible(
                            flex: 2,
                            child: autoTextSize(model.code, TextStyle(color: Colors.grey[700]), context)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(width: double.maxFinite, height: 1, color: Colors.grey,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: autoTextSize('電話: ', TextStyle(color: Colors.black), context),
                          ),
                          Flexible(
                            flex: 2,
                            child: autoTextSize(model.telephone, TextStyle(color: Colors.grey[700]), context),
                          ),
                        ],
                      ),
                    ),
                    _containerHeightLine(),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: autoTextSize('手機: ', TextStyle(color: Colors.black), context),
                          ),
                          Flexible(
                            flex: 2,
                            child: autoTextSize(model.mobile, TextStyle(color: Colors.grey[700]), context)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: double.maxFinite, height: 1, color: Colors.grey,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: autoTextSize('地址: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 5,
                      child: autoTextSize(model.installAddress, TextStyle(color: Colors.grey[700]), context)
                    ),
                  ],
                ),
              ),
              Container(width: double.maxFinite, height: 1, color: Colors.grey,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: autoTextSize('大樓: ', TextStyle(color: Colors.black), context),
                          ),
                          Flexible(
                            flex: 2,
                            child: autoTextSize(model.building, TextStyle(color: Colors.red[300]), context),
                          ),
                        ],
                      ),
                    ),
                    _containerHeightLine(),
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: autoTextSize('狀態: ', TextStyle(color: Colors.black), context),
                          ),
                          Flexible(
                            flex: 2,
                            child: autoTextSize(model.orderTypeName, TextStyle(color: Colors.black), context)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: double.maxFinite, height: 1, color: Colors.grey,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: autoTextSize('備註: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 7,
                      child: autoTextSizeLeft(model.description, TextStyle(color: Colors.grey[700]), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: autoTextSize('約裝時間: ', TextStyle(color: Colors.blue), context),
                      ),
                      Flexible(
                        flex: 3,
                        child: autoTextSize(bookingDate, TextStyle(color: Colors.blue), context),
                      ),
                    ],
                  ),
                ),
                _containerHeightLine(),
                Flexible(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: autoTextSize('配屬: ', TextStyle(color: Colors.black), context),
                      ),
                      Flexible(
                        flex: 2,
                        child: autoTextSize(model.slaveInfo, TextStyle(color: Colors.grey[700]), context)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            showDialog(
              context: context, 
              builder: (BuildContext context)=> _calendarSelectorDialog(context)
            );
          },
        ),
        
      ];
      return list;
    }
    ///約裝查詢用欄位畫面
    List<Widget> type1List() {
      List<Widget> list = [
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: autoTextSize('工程改約: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 3,
                      child: autoTextSize('', TextStyle(color: Colors.brown), context),
                    ),
                  ],
                ),
              ),
              _containerHeightLine(),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: autoTextSize('派工: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.constructName, TextStyle(color: Colors.black), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
      return list;
    }
    ///完工查詢用欄位畫面
    List<Widget> type2List() {
      DateFormat dft = new DateFormat('yyyy-MM-dd HH:mm');
      var openTime;
      if (model.openTime != null) {
        openTime = dft.parse(model.openTime);
        dft = new DateFormat('yy-MM-dd HH:mm');
        openTime = dft.format(openTime);
      }
      List<Widget> list = [
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: autoTextSizeLeft('完工\n時間: ', TextStyle(color: Colors.red), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSizeLeft(openTime, TextStyle(color: Colors.red), context),
                    ),
                  ],
                ),
              ),
              _containerHeightLine(),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      // flex: 2,
                      child: autoTextSizeLeft('工程\n人員: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      // flex: 7,
                      child: autoTextSizeLeft(model.constructName, TextStyle(color: Colors.black), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: autoTextSize('撤銷原因: ', TextStyle(color: Colors.black), context),
              ),
              Flexible(
                flex: 3,
                child: autoTextSize(model.cancleInfo.reason, TextStyle(color: Colors.black), context)
              ),
            ],
          ),
        ),
      ];
      return list;
    }
    ///未完工查詢用欄位畫面
    List<Widget> type3List() {
      List<Widget> list = [];
      return list;
    }
    ///撤銷查詢用欄位畫面
    List<Widget> type4List() {
      DateFormat dft = new DateFormat('yyyy-MM-dd HH:mm');
      var operateTime;
      if (model.cancleInfo != null) {
        operateTime = dft.parse(model.cancleInfo.operateTime);
        dft = new DateFormat('yy-MM-dd HH:mm');
        operateTime = dft.format(operateTime);
      }
      List<Widget> list = [
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: autoTextSize('撤銷: ', TextStyle(color: Colors.red), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(operateTime, TextStyle(color: Colors.red), context),
                    ),
                  ],
                ),
              ),
              _containerHeightLine(),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: autoTextSize('撤銷人: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.cancleInfo.operators, TextStyle(color: Colors.black), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: autoTextSize('撤銷原因: ', TextStyle(color: Colors.black), context),
              ),
              Flexible(
                flex: 3,
                child: autoTextSize(model.cancleInfo.reason, TextStyle(color: Colors.black), context)
              ),
            ],
          ),
        ),
      ];
      return list;
    }
    ///最後要顯示Column畫面
    List<Widget> finalShowList() {
      List<Widget> list = [];
      list.addAll(commonList(context));
      ///依據不同bookingType添加畫面
      switch (bookingType) {
        case "1":
          list.addAll(type1List());
          break;
        case "2":
          list.addAll(type2List());
          break;
        case "3":
          list.addAll(type1List());
          break;
        case "4":
          list.addAll(type4List());
          break;
      }

      return list;
    }

    return Container(
      width: double.maxFinite,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: finalShowList()
        ),
        color: Colors.white,
      ),
    );
  }
}

class BookingItemModel {
  int rowCount;
  String bookingDate;
  String building;
  String code;
  String description;
  String installAddress;
  String mobile;
  String name;
  String orderTypeCode;
  String orderTypeName;
  String slaveInfo;
  String telephone;
  String workorderCode;
  String constructName;
  String openTime;
  PurchaseInfo purchaseInfo;
  CancleInfo cancleInfo;
  BookingItemModel();

  BookingItemModel.forMap(prefix0.CustomerWorkOrderInfos data) {
    bookingDate = data.bookingDate == null ? "" : data.bookingDate;
    building = data.building == null ? "" : data.building;
    code = data.code == null ? "" : data.code;
    constructName = data.constructName == null ? "" : data.constructName;
    openTime = data.openTime == null ? "" : data.openTime;
    description = data.description == null ? "" : data.description;
    installAddress = data.installAddress == null ? "" : data.installAddress;
    mobile = data.mobile == null ? "" : data.mobile;
    name = data.name == null ? "" : data.name;
    orderTypeCode = data.orderTypeCode == null ? "" : data.orderTypeCode;
    orderTypeName = data.orderTypeName == null ? "" : data.orderTypeName;
    slaveInfo = data.slaveInfo == null ? "" : data.slaveInfo;
    telephone = data.telephone == null ? "" : data.telephone;
    workorderCode = data.workorderCode == null ? "" : data.workorderCode;
    if (data.cancleInfo != null) {
      cancleInfo = CancleInfo.forMap(data.cancleInfo);
    }
    if (data.purchaseInfo != null) {
      purchaseInfo = PurchaseInfo.forMap(data.purchaseInfo);
    }
    if (data.purchaseInfo.additionalInfos != null) {
      
    }
  }
}


class CancleInfo {
  String operateTime;
  String operators;
  String reason;
  CancleInfo();
  CancleInfo.forMap(data) {
    operateTime = data.operateTime == null ? "" : data.operateTime;
    operators = data.operators == null ? "" : data.operators;
    reason = data.reason == null ? "" : data.reason;
  }
}
class PurchaseInfo {
  String allowanceMonth;
  String cmMonth;
  String cmCode;
  String dtvCode;
  String dtvMonth;
  String crossFloorNumber;
  String networkCableNumber;
  String slaveNumber;
  String sumMoney;
  List<AdditionalInfos> additionalInfos;
  PurchaseInfo();
  PurchaseInfo.forMap(data) {
    allowanceMonth = data.allowanceMonth == null ? "" : "${data.allowanceMonth}";
    cmMonth = data.cmMonth == null ? "" : "${data.cmMonth}";
    cmCode = data.cmCode == null ? "" : data.cmCode;
    dtvCode = data.dtvCode == null ? "" : data.dtvCode;
    dtvMonth = data.dtvMonth == null ? "" : "${data.dtvMonth}";
    crossFloorNumber = data.crossFloorNumber == null ? "" : "${data.crossFloorNumber}";
    networkCableNumber = data.networkCableNumber == null ? "" : "${data.networkCableNumber}";
    slaveNumber = data.slaveNumber == null ? "" : "${data.slaveNumber}";
    sumMoney = data.sumMoney == null ? "" : "${data.sumMoney}";
  }
}
class AdditionalInfos {
  String code;
  String month;
  AdditionalInfos();
  AdditionalInfos.forMap(data) {
    code = data.code == null ? "" : data.code;
    month = data.month == null ? "" : "${data.month}";
  }
}