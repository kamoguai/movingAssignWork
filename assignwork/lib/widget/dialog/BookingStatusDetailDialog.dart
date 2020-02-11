import 'package:assignwork/common/dao/BaseDao.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/item/BookingStatusItem.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

  @override
  autoTextSize(text, style, context) {
    var fontSize = MyScreen.normalPageFontSize(context);
    var fontStyle = TextStyle(fontSize: fontSize);
    return AutoSizeText(
      text,
      style: style.merge(fontStyle),
      minFontSize: 5.0,
      textAlign: TextAlign.center,
    );
  }   
  ///記錄競業
  String industryStr = "";

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
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '大樓: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: widget.model.building,
                          style: TextStyle(color: Colors.red, fontSize: MyScreen.normalPageFontSize_span(context))
                        )
                      ]
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '競業: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: this.industryStr,
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
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
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid)),color: Colors.pink[50],),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '有線: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: dtvCode,
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        )
                      ]
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '繳別: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: CommonUtils.filterMonthCN(widget.model.purchaseInfo.dtvMonth),
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
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
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid)),color: Colors.pink[50],),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '加購: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: '0種',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        )
                      ]
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '分機: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: widget.model.purchaseInfo.slaveNumber + '台',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
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
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid)),color: Colors.blue[50],),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'CM: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: cmCode,
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        )
                      ]
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '繳別: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: CommonUtils.filterMonthCN(widget.model.purchaseInfo.cmMonth) ,
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
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
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid)),color: Colors.lightBlue[50],),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '跨樓層: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: widget.model.purchaseInfo.crossFloorNumber + '層',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        )
                      ]
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '網路線: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: widget.model.purchaseInfo.networkCableNumber + "條",
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
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
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid)),color: Colors.grey[100],),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '備註: ',
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                ),
                TextSpan(
                  text: widget.model.description,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                ),
              ]
            ),
          ),
        ),
      ];
      return list;
    }

    ///約裝查詢用欄位畫面
    List<Widget> type1List() {
      List<Widget> list = [
         Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'BOSS回覆: ',
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                ),
                TextSpan(
                  text: '',
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                ),
              ]
            ),
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
        Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'BOSS回覆: ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: ' 已撤銷',
                          style: TextStyle(color: Colors.red, fontSize: MyScreen.normalPageFontSize_span(context))
                        )
                      ]
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '撤銷時間: ',
                          style: TextStyle(color: Colors.red, fontSize: MyScreen.normalPageFontSize_span(context))
                        ),
                        TextSpan(
                          text: widget.model.cancleInfo.operateTime,
                          style: TextStyle(color: Colors.red, fontSize: MyScreen.normalPageFontSize_span(context))
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
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '撤銷原因: ',
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                ),
                TextSpan(
                  text: widget.model.cancleInfo.reason,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize_span(context))
                ),
              ]
            ),
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
          list.addAll(type1List());
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

