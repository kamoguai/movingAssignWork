import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
///
///pop結果顯示頁面
///Date: 2019-12-11
class BookingResultDialog extends StatelessWidget with BaseWidget{
  ///由前頁傳入客編
  final String custNo;
  ///由前頁傳入原始時間
  final String originDate;
  ///由前頁傳入變更時間
  final String changeDate;
  ///由前頁傳入呼叫此頁面的function
  final String funcType;
  BookingResultDialog({this.custNo, this.originDate, this.changeDate, this.funcType});

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

  @override
  Widget build(BuildContext context) {
    DateFormat df = new DateFormat("yyyy-MM-dd hh:mm:ss");
    DateFormat df2 = new DateFormat("yy-MM-dd hh:mm");

    var od = df.parse(originDate);
    var cd = df.parse(changeDate);
    String subODate = df2.format(od);
    String subCDate = df2.format(cd);

    List<Widget> wList = [];
    wList.add(
      Container(
        height: titleHeight(context),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
        alignment: Alignment.center,
        child: autoTextSize('裝機時段改約', TextStyle(color: Colors.black, fontWeight: FontWeight.bold), context),
      ),
    );

    wList.add(
      Container(
        height: titleHeight(context),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: autoTextSize('客編 ： $custNo', TextStyle(color: Colors.grey), context),
        ),
      )
    );

    wList.add(
      Container(  
        height: titleHeight(context),      
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.red, style: BorderStyle.solid))),
                  alignment: Alignment.centerLeft,
                  child: autoTextSize('原時間：$subODate', TextStyle(color: Colors.black87), context),
                ),
              ),
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 2),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '變更 : ',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context))
                        ),
                        TextSpan(
                          text: '$subCDate',
                          style: TextStyle(color: Colors.blueAccent, fontSize: MyScreen.normalPageFontSize(context))
                        )
                      ]
                    ),
                  )
                ),
              )
            ],
          )
        ),
      )
    );

    wList.add(
      Container(
        height: titleHeight(context),
        padding: EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'BOSS更改中請稍候...',
                style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context))
              ),
              TextSpan(
                text: '已變更成功',
                style: TextStyle(color: Colors.blueAccent, fontSize: MyScreen.normalPageFontSize(context))
              )
            ]
          ),
        ),
      )
    );


    return InkWell(
      child: Container(
        child: Column(
          children: wList
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}