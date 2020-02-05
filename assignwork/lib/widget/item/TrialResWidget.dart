
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
///
///試算結果widget
///Date: 2020-02-03
class TrialResWidget extends StatelessWidget with BaseWidget{

  ///由前頁帶入資料
  final Map<String, dynamic> logTrialArr;
  ///由前頁帶入func
  final String fromFunc;

  TrialResWidget({this.logTrialArr, this.fromFunc});
  
  @override
  Widget build(BuildContext context) {
    Widget body;
    List<Widget> columnList = [];
    ///有線，寬頻
    columnList.add(
    Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid), top: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child:  RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '有線：',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '${this.logTrialArr["dtvMoney"] == "" ? "0000" : this.logTrialArr["dtvMoney"]}',
                        style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '元',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      )
                    ]
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '寬頻：',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '${this.logTrialArr["cmMoney"] == "" ? "0000" : this.logTrialArr["cmMoney"]}',
                        style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '元',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
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
    ///新約顯示
    if (this.fromFunc == 'book') {
      ///加購，網路線
      columnList.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child:  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '加購：',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                        ),
                        TextSpan(
                          text: '${this.logTrialArr["additionalMoney"] == "" ? "0000" : this.logTrialArr["additionalMoney"]}',
                          style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                        ),
                        TextSpan(
                          text: '元',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                        )
                      ]
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child:  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '網路線：',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                        ),
                        TextSpan(
                          text: '${this.logTrialArr["networkCableMoney"] == "" ? "0000" : this.logTrialArr["networkCableMoney"]}',
                          style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                        ),
                        TextSpan(
                          text: '元',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
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
    }
    ///裝機，跨樓層
    columnList.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child:  RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '裝機費：',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '${this.logTrialArr["installMoney"] == "" ? "0000" : this.logTrialArr["installMoney"]}',
                        style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '元',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      )
                    ]
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '跨樓層：',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '${this.logTrialArr["buildMoney"] == "" ? "0000" : this.logTrialArr["buildMoney"]}',
                        style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '元',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
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
    ///押金，合計
    columnList.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '押金：',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '${this.logTrialArr["foregiftMoney"] == "" ? "0000" : this.logTrialArr["foregiftMoney"]}',
                        style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '元',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      )
                    ]
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.yellow[100],
                padding: EdgeInsets.only(left: 5.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '合計：',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '${this.logTrialArr["sumMoney"] == "" ? "0000" : this.logTrialArr["sumMoney"]}',
                        style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize_span(context))
                      ),
                      TextSpan(
                        text: '元',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize_span(context))
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
    body = Column(
      children: columnList
    );

    return body;
  }
}