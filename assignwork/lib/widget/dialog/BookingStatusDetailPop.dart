import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/item/BookingStatusItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assignwork/common/model/BookingStatusTableCell.dart' as prefix0;
///
///約裝詳情popup
///Date: 2019-10-21
///
class BookingStatusDetailPop extends StatelessWidget with BaseWidget{
  ///詳情model
  final BookingItemModel model;
  ///由前頁傳過來，判別約裝狀態
  final bookingType;

  BookingStatusDetailPop(this.bookingType, this.model);

  ///height 分隔線
  _containerHeightLine() {
    return Container(height: 20, width: 1, color: Colors.grey,);
  }

  @override
  Widget build(BuildContext context) {


    ///通用欄位畫面
    List<Widget> commonList() {
      List<Widget> list = [
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
                      child: autoTextSize(model.building, TextStyle(color: Colors.grey[700]), context),
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
                      child: autoTextSize('競業: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize('', TextStyle(color: Colors.grey[700]), context)
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
                      child: autoTextSize('有線: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.purchaseInfo.dtvCode == null ? "---" : model.purchaseInfo.dtvCode, TextStyle(color: Colors.grey[700]), context),
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
                      child: autoTextSize('繳別: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.purchaseInfo.dtvMonth, TextStyle(color: Colors.grey[700]), context)
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
                      child: autoTextSize('加購: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize( "0種" , TextStyle(color: Colors.grey[700]), context),
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
                      child: autoTextSize('分機: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.purchaseInfo.slaveNumber, TextStyle(color: Colors.grey[700]), context)
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
                      child: autoTextSize('CM: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.purchaseInfo.cmCode, TextStyle(color: Colors.red[300]), context),
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
                      child: autoTextSize('繳別: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.purchaseInfo.cmMonth, TextStyle(color: Colors.black), context)
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
                      child: autoTextSize('跨樓層: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.purchaseInfo.crossFloorNumber, TextStyle(color: Colors.red[300]), context),
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
                      child: autoTextSize('網路線: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.purchaseInfo.networkCableNumber, TextStyle(color: Colors.black), context)
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
        
      ];
      return list;
    }

    ///約裝查詢用欄位畫面
    List<Widget> type1List() {

    }

     ///完工查詢用欄位畫面
    List<Widget> type2List() {

    }

    ///未完工查詢用欄位畫面
    List<Widget> type3List() {

    }

    ///撤銷查詢用欄位畫面
    List<Widget> type4List() {
      List<Widget> list = [
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: autoTextSize('BOSS回覆: ', TextStyle(color: Colors.black), context),
              ),
              Flexible(
                flex: 6,
                child: autoTextSizeLeft('已撤銷', TextStyle(color: Colors.red), context)
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
                flex: 2,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: autoTextSize('撤銷\n時間: ', TextStyle(color: Colors.blue), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.cancleInfo.operateTime, TextStyle(color: Colors.blue), context),
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
                      child: autoTextSize('撤銷人: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(model.cancleInfo.operators, TextStyle(color: Colors.grey[700]), context)
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
                flex: 2,
                child: autoTextSize('撤銷原因: ', TextStyle(color: Colors.black), context),
              ),
              Flexible(
                flex: 6,
                child: autoTextSizeLeft(model.cancleInfo.reason, TextStyle(color: Colors.black), context)
              ),
            ],
          ),
        ),
      ];
      return list;
    }

    ///最後顯示畫面
    List<Widget> finalShowList() {
      List<Widget> list = [];
      list.addAll(commonList());
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: double.maxFinite,
      child: GestureDetector(
        child: Container(
          child: Column(
              children: finalShowList()
            ),
          color: Colors.white,
        ),
        onTap: () {
          Navigator.pop(context);
        },     
      ),
    );
    // return Container(
    //   width: 200,
    //   height: 200,
    //   color: Colors.yellow,
    //   child: GestureDetector(
    //     onTap: (){Navigator.pop(context);},
    //     child: Text(model.name),
    //   ),
    // );
  }
}
