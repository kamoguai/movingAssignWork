import 'package:assignwork/common/dao/BaseDao.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/item/BookingStatusItem.dart';
import 'package:flutter/material.dart';

///
///約裝詳情popup
///Date: 2019-10-21
///
class BookingStatusDetailDialog extends StatefulWidget {

  ///詳情model
  final BookingItemModel model;
  ///由前頁傳過來accno
  final accNo;
  ///由前頁傳過來，判別約裝狀態
  final bookingType;

  BookingStatusDetailDialog({this.bookingType, this.model,this.accNo});

  @override
  _BookingStatusDetailDialogState createState() => _BookingStatusDetailDialogState();
}

class _BookingStatusDetailDialogState extends State<BookingStatusDetailDialog> with BaseWidget {

  String industryStr = "";

  ///height 分隔線
  _containerHeightLine() {
    return Container(height: 20, width: 1, color: Colors.grey,);
  }

  ///call競業api
  _getIndustryData() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "getindustrywithwkno";
    paramMap["accNo"] = widget.accNo;
    paramMap["wkNo"] = widget.model.workorderCode;
    var res = await BaseDao.getIndustryWithWkno(paramMap);
    if (res.result) {
      var data = res.data["industry"];
      setState(() {
        this.industryStr = data["Industry"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getIndustryData();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    String cmCode = "---";
    String dtvCode = "---";
    ///cmCode擷取前段顯示
    if (widget.model.purchaseInfo.cmCode != null && widget.model.purchaseInfo.cmCode != "") {
      cmCode = widget.model.purchaseInfo.cmCode.substring(0,widget.model.purchaseInfo.cmCode.indexOf('_'));
    }
    
    if (widget.model.purchaseInfo.dtvCode != null && widget.model.purchaseInfo.dtvCode != "") {
      dtvCode = "基本頻道";
    }
    ///通用欄位畫面
    List<Widget> commonList() {
      List<Widget> list = [
        Container(
          // color: Colors.pink[50],
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
                      child: autoTextSize(widget.model.building, TextStyle(color: Colors.black), context),
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
                      child: autoTextSize(this.industryStr, TextStyle(color: Colors.black), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          color: Colors.pink[50],
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
                      child: autoTextSize(dtvCode, TextStyle(color: Colors.black), context),
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
                      child: autoTextSize(CommonUtils.filterMonthCN(widget.model.purchaseInfo.dtvMonth) , TextStyle(color: Colors.black), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          color: Colors.pink[50],
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
                      child: autoTextSize( "0種" , TextStyle(color: Colors.black), context),
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
                      child: autoTextSize(widget.model.purchaseInfo.slaveNumber + '台', TextStyle(color: Colors.black), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          color: Colors.blue[50],
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
                      child: autoTextSize(cmCode, TextStyle(color: Colors.black), context),
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
                      child: autoTextSize(CommonUtils.filterMonthCN(widget.model.purchaseInfo.cmMonth) , TextStyle(color: Colors.black), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          color: Colors.lightBlue[50],
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: autoTextSize('跨樓層: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 3,
                      child: autoTextSize(widget.model.purchaseInfo.crossFloorNumber + '層', TextStyle(color: Colors.black), context),
                    ),
                  ],
                ),
              ),
              _containerHeightLine(),
              Flexible(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: autoTextSize('網路線: ', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      flex: 3,
                      child: autoTextSize(widget.model.purchaseInfo.networkCableNumber + "條", TextStyle(color: Colors.black), context)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.grey,),
        Container(
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: autoTextSize('備註: ', TextStyle(color: Colors.black), context),
              ),
              Flexible(
                flex: 7,
                child: autoTextSizeLeft(widget.model.description, TextStyle(color: Colors.black), context)
              ),
            ],
          ),
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
                child: autoTextSize('BOSS回覆: ', TextStyle(color: Colors.black), context),
              ),
              Flexible(
                flex: 6,
                child: autoTextSizeLeft('', TextStyle(color: Colors.black), context)
              ),
            ],
          ),
         ),
      ];
      return list;
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
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: autoTextSize('撤銷\n時間: ', TextStyle(color: Colors.red), context),
                    ),
                    Flexible(
                      flex: 2,
                      child: autoTextSize(widget.model.cancleInfo.operateTime, TextStyle(color: Colors.red), context),
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
                      child: autoTextSize(widget.model.cancleInfo.operators, TextStyle(color: Colors.black), context)
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
                child: autoTextSizeLeft(widget.model.cancleInfo.reason, TextStyle(color: Colors.black), context)
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
      switch (widget.bookingType) {
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
      child: GestureDetector(
        child: Container(
          child: Column(
              children: finalShowList()
            ),
        ),
        onTap: () {
          Navigator.pop(context);
        },     
      ),
    );
    
  }
}

