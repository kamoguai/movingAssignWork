import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///加購產品選擇器
///Date: 2020-01-03
class ProductSelectDialog extends StatefulWidget {

  ///由上頁傳入dataList
  final List<dynamic> dataList;
  ///由上頁傳入func，此頁選定後把值帶回前頁
  final Function selectFunc;
  ///由上頁傳入callbackData，將值返還這頁
  final Map<String, dynamic> callBackData;
  

  ProductSelectDialog({this.dataList, this.selectFunc, this.callBackData});

  @override
  _ProductSelectDialogState createState() => _ProductSelectDialogState();
}


class _ProductSelectDialogState extends State<ProductSelectDialog> with BaseWidget {
  ///裝載資料
  List<dynamic> dataArray = [];
  ///原始資料
  List<dynamic> originArray = [];
  ///所選資料
  List<dynamic> checkBoxArr = [];
  Map<String, dynamic> pickData = {};
  ///radio group
  List<dynamic> groupVal = [];

  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = dataArray[index];
    var isChecked = this.checkBoxArr[index];
    var dic = SelectorModel.forMap(dicIndex);
    item = Container(
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
                      activeColor: Colors.blue,
                      value: isChecked,
                      title: autoTextSize(dic.name, TextStyle(color: Colors.black), context),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool val){
                        updateCheckeBox(val, index);
                      },
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
                    child: _myRadioButton(
                      value: isChecked ? '1' : '',
                      index: index,
                      onChanged: (newVal) {
                        setState(() {
                          if (isChecked) {
                            groupVal[index] = newVal;
                          }
                          else {
                            groupVal[index] = "";
                          }
                          analyzePickData(index);
                        });
                      }
                    )
                  ),
                  Flexible(
                    child: autoTextSize('月繳', TextStyle(color: Colors.black), context),
                  ),
                  Flexible(
                    child: _myRadioButton(
                      value: isChecked ? '3' : '',
                      index: index,
                      onChanged: (newVal) {
                        setState(() {
                          if (isChecked) {
                            groupVal[index] = newVal;
                          }
                          else {
                            groupVal[index] = "";
                          }
                          analyzePickData(index);
                        });
                      }
                    ),
                  ),
                  Flexible(
                    child: autoTextSize('季繳', TextStyle(color: Colors.black), context),
                  ),
                  Flexible(
                    child: _myRadioButton(
                      value: isChecked ? '6' : '',
                      index: index,
                      onChanged: (newVal) {
                        setState(() {
                          if (isChecked) {
                            groupVal[index] = newVal;
                          }
                          else {
                            groupVal[index] = "";
                          }
                          analyzePickData(index);
                        });
                      }
                    ),
                  ),
                  Flexible(
                    child: autoTextSize('半年', TextStyle(color: Colors.black), context),
                  ),
                  Flexible(
                    child: _myRadioButton(
                      value: isChecked ? '12' : '',
                      index: index,
                      onChanged: (newVal) {
                        setState(() {
                          if (isChecked) {
                            groupVal[index] = newVal;
                          }
                          else {
                            groupVal[index] = "";
                          }
                          analyzePickData(index);
                          
                        });
                      }
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
  ///自定義radio button 更新
  Widget _myRadioButton({String value, int index, Function onChanged}) {
    return Radio(
      activeColor: Colors.blue,
      value: value,
      groupValue: value == "" ? groupVal : groupVal[index],
      onChanged: onChanged,
    );
  }
 
  ///check box 更新
  void updateCheckeBox(v, index) {
    setState(() {
      this.checkBoxArr[index] = v;
      ///取消選擇時
      if (!v) {
        ///移除該index資料
        this.pickData.remove('$index');
        ///設該index資料為空
        this.groupVal[index] = "";
      }
    });
  }

  ///選擇資料存入array裡
  void analyzePickData(int index) {
    setState(() {
      List<dynamic> list = [];
      Map<String,dynamic> map = Map<String,dynamic>();
      var k = 0;
      var isSame = false;
      for (var oData in this.originArray) {
        var oDic = SelectorModel.forMap(oData);
        for (var i = 0; i < this.dataArray.length; i++) {
          var dic = SelectorModel.forMap(dataArray[i]);
          if (this.checkBoxArr[i] == true) {
            // if (this.pickData.length > 0) {
            //   for (var indx in this.pickData.keys) {
            //       if (index == int.parse(indx)) {
            //         isSame = true;
            //       }
            //     }
            //   if (isSame) {
            //     continue;
            //   }
            // }


            var subOname = oDic.name;
            var subDname = dic.name;
            ///確保字串可以抓取(前的字
            if (oDic.name.indexOf('(') != -1 && dic.name.indexOf('(') != -1) {
              subOname = oDic.name.substring(0, oDic.name.indexOf('('));
              subDname = dic.name.substring(0, dic.name.indexOf('('));
            }

            if (subOname.contains(subDname)) {
              if (this.pickData.containsKey(oDic.code)) {
                this.pickData.clear();
                
              }
              
              map["code"] = oDic.code;
              map["month"] = this.groupVal[i];
              map["name"] = oDic.name;
              list.add(map);
              map = Map<String,dynamic>();
              k++;
              if (k == 3) {
                map['$index'] = list;
                this.pickData.addAll(map);
                list = [];
                map = Map<String,dynamic>();
                k = 0;
              }
            }
          }
        }        
      }
    });
  }

  initData() {
    originArray = widget.dataList;
    for (var dic in originArray) {
      if (dic["priceMoney"] != "0") {
        dataArray.add(dic);
        ///初始化規定arr大小
        this.checkBoxArr.add(false);
        ///初始化規定arr大小
        this.groupVal.add("");
      }
    }
    if (widget.callBackData.length > 0) {
      this.pickData = widget.callBackData;
      for (var indx in this.pickData.keys) {
        final i = int.parse(indx);
        this.checkBoxArr[i] = true;
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
    this.checkBoxArr.clear();
    this.groupVal.clear();
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
                        if (this.pickData.length > 0) {
                          this.pickData.forEach((k,v) {                        
                            for (var dic in v) {
                              if (dic["month"] == "") {
                                Fluttertoast.showToast(msg: '${dic['name']}尚未選擇繳費月數！');
                                return;
                              }
                            }
                          });
                          widget.selectFunc(this.pickData);
                          Navigator.pop(context);
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