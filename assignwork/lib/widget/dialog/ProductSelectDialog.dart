import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';

///
///加購產品選擇器
///Date: 2020-01-03
class ProductSelectDialog extends StatefulWidget {

  ///由上頁傳入dataList
  final List<dynamic> dataList;
  ///由上頁傳入func，此頁選定後把值帶回前頁
  final Function selectFunc;
  

  ProductSelectDialog({this.dataList, this.selectFunc});

  @override
  _ProductSelectDialogState createState() => _ProductSelectDialogState();
}


class _ProductSelectDialogState extends State<ProductSelectDialog> with BaseWidget {
  ///裝載資料
  List<dynamic> dataArray = [];
  ///原始資料
  List<dynamic> originArray = [];
  ///所選資料
  Map<String, dynamic> pickData = {};
  ///radio group
  int groupVal = 1;

  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = dataArray[index];

    var dic = SelectorModel.forMap(dicIndex);
    item = GestureDetector(
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid))),
        height: titleHeight(context) * 3,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: CheckboxListTile(
                        value: true,
                        title: autoTextSize(dic.name, TextStyle(color: Colors.black), context),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool val){},

                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 4),
                        alignment: Alignment.centerRight,
                        child: autoTextSize("(${dic.priceMoney}/月)", TextStyle(color: Colors.blue), context),
                      )
                    ),
                    
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: Radio(
                        value: 1,
                        groupValue: groupVal,
                        activeColor: Colors.red,
                        onChanged: (T) {
                          updataGroupVal(T);
                        },
                      ),
                    ),
                    Flexible(
                      child: autoTextSize('月繳', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      child: Radio(
                        value: 2,
                        groupValue: groupVal,
                        activeColor: Colors.red,
                        onChanged: (T) {
                          updataGroupVal(T);
                        },
                      ),
                    ),
                    Flexible(
                      child: autoTextSize('季繳', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      child: Radio(
                        value: 3,
                        groupValue: groupVal,
                        activeColor: Colors.red,
                        onChanged: (T) {
                          updataGroupVal(T);
                        },
                      ),
                    ),
                    Flexible(
                      child: autoTextSize('半年', TextStyle(color: Colors.black), context),
                    ),
                    Flexible(
                      child: Radio(
                        value: 4,
                        groupValue: groupVal,
                        activeColor: Colors.red,
                        onChanged: (T) {
                          updataGroupVal(T);
                        },
                      ),
                    ),
                    Flexible(
                      child: autoTextSize('年繳', TextStyle(color: Colors.black), context),
                    ),
                    
                  ],
                ),
              ),
            ),
            
          ],
        )
      ),
      onTap: () {
        setState(() {
          pickData = dicIndex;
        });
      },
    );
    
    return item;
  }

  ///widget list view
  Widget listView() {
    Widget list;
    if (dataArray.length > 0) {
      list = Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: listItem,
          itemCount:  dataArray.length,
        ),
      );
    }
    return list;
  }

  void updataGroupVal(v) { 
    setState(() {
      groupVal = v;
    });
  }

  initData() {
    originArray = widget.dataList;
    for (var dic in originArray) {
      if (dic["priceMoney"] != "0") {
        dataArray.add(dic);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              color: Color(MyColors.hexFromStr('#40b89e')),
            ),
            height: titleHeight(context) * 1.5,
            child: Center(child: autoTextSize('加購產品', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),)
          ),
          widget.dataList.length > 0 ? listView() : Container(),
          Container(
            height: titleHeight(context) * 1.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    height: titleHeight(context) * 1.5,
                    child: FlatButton(
                      color: Color(MyColors.hexFromStr('#f2f2f2')),
                      child: autoTextSize('取消', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  )
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    height: titleHeight(context) * 1.5, 
                    child: FlatButton(
                      color: Color(MyColors.hexFromStr('#40b89e')),
                      child: autoTextSize('確定', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),
                      onPressed: () {
                        if (pickData.length > 0) {
                          widget.selectFunc(pickData);
                          Navigator.pop(context, 'ok');
                        }
                        else {
                          
                          return;
                        }
                        
                      },
                    ),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SelectorModel {
  ///產品name
  String name;
  ///產品代碼
  String code;
  ///金額
  String priceMoney;
  ///月數
  String priceMonth;

  SelectorModel();

  SelectorModel.forMap(dic) {
    name = dic["name"] == null ? "" : dic["name"];
    code = dic["code"] == null ? "" : dic["code"];
    priceMoney = dic["priceMoney"] == null ? "" : dic["priceMoney"];
    priceMonth = dic["priceMonth"] == null ? "" : dic["priceMonth"];
  }
}