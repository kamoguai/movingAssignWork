
import 'dart:convert';

import 'package:assignwork/common/dao/ManageSectionDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/dialog/RoadSelectDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
///
///新戶約裝輸入客戶基本資料的dialog
///Date: 2019-12-18
class CustDetailSelectDialog extends StatefulWidget {
  @override
  _CustDetailSelectDialogState createState() => _CustDetailSelectDialogState();

}

class _CustDetailSelectDialogState extends State<CustDetailSelectDialog> with BaseWidget{
  
  ///地址地區arr
  List<dynamic> areaAddressArr = [];
  ///街路段arr
  List<dynamic> roadAddressArr = [];
  ///記錄全路段
  List<dynamic> logFullAddress = ["新北市","板橋區"];
  ///記錄市區代碼
  String manageSectionCodeStr = "";

  ///姓名 textfield node，controller
  final FocusNode _nameFocus =  FocusNode();
  var _nameController = TextEditingController();
  ///手機 textfield node，controller
  final FocusNode _mobileFocus =  FocusNode();
  var _mobileController = TextEditingController();
  ///市話區碼 textfield node，controller
  final FocusNode _telAreaCodeFocus =  FocusNode();
  var _telAreaCodeController = TextEditingController();
  ///市話 textfield node，controller
  final FocusNode _telPhoneFocus =  FocusNode();
  var _telPhoneController = TextEditingController();
  ///巷 textfield node，controller
  final FocusNode _communityFocus =  FocusNode();
  var _communityController = TextEditingController();
  ///弄 textfield node，controller
  final FocusNode _laneFocus =  FocusNode();
  var _laneController = TextEditingController();
  ///號 textfield node，controller
  final FocusNode _unitFocus =  FocusNode();
  var _unitController = TextEditingController();
  ///之號 textfield node，controller
  final FocusNode _ofUnitFocus =  FocusNode();
  var _ofUnitController = TextEditingController();
  ///樓 textfield node，controller
  final FocusNode _floorFocus =  FocusNode();
  var _floorController = TextEditingController();
  ///之樓 textfield node，controller
  final FocusNode _floorOfFocus =  FocusNode();
  var _floorOfController = TextEditingController();
  ///scrollController
  ScrollController _scrollController = ScrollController();
  
  _fieldFoucusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }


  ///取得地址api
  _getAddressData(String sectionCode) async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "queryManageSection";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["currentManageSectionCode"] = sectionCode;
    var res = await ManageSectionDao.getQueryManageSection(paramMap);
    if (res.result) {
      setState(() {
        this.roadAddressArr = res.data;
      });
      
    }
  }

  ///道路選擇dialog
  Widget roadSelectorDialot(BuildContext context) {
    var roadData = this.roadAddressArr;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: RoadSelectDialog(dataList: roadData, selectFunc: _selectFunc,),
      )
    );
  }

  void _selectFunc(Map<String, dynamic> map) {
    setState(() {
      if (this.logFullAddress[2] == null) {
        this.logFullAddress.insert(2, map["name"]);
        this.logFullAddress.insert(3, map["code"]);
      }
      else {
        this.logFullAddress[2] = map["name"];
        this.logFullAddress[3] = map["code"];
      }
      print(this.logFullAddress.toString());
    });
  }







  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (this.roadAddressArr.length == 0) {
      var currentSection = json.decode(areaAddressJson);
      this.areaAddressArr = currentSection;
      _getAddressData(this.areaAddressArr[4]["code"]);

    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    Widget body;
    List<Widget> columnList = [];
    List<Widget> columnList2 = [];

    columnList.add(
      Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            autoTextSize('客戶資料輸入', TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context) * 1.5), context),
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
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: Column(
            children: columnList2,
          ),
        ),
      )
    );

    columnList2.add(
      Container(
        //  height: titleHeight(context),
         decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
         padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
         child: Row(
           children: <Widget>[
             Expanded(
               child: Container(
                 alignment: Alignment.centerLeft,
                 child: autoTextSize('姓名：', TextStyle(color: Colors.black), context),
               ),
             ),
             Expanded(
               flex: 3,
               child: TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                focusNode: _nameFocus,
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: '姓名',
                  hintText: '請輸入姓名',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                  )
                ),
                onFieldSubmitted: (val) {
                  _fieldFoucusChange(context, _nameFocus, _mobileFocus);
                },
               ),
             )
           ],
         ),
      )
    );

    columnList2.add(
      Container(
        // height: titleHeight(context), 
         decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
         padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
         child: Row(
           children: <Widget>[
             Expanded(
               child: Container(
                 padding: EdgeInsets.only(bottom: 15),
                 alignment: Alignment.centerLeft,
                 child: autoTextSize('手機：', TextStyle(color: Colors.black), context),
               ),
             ),
             Expanded(
               flex: 3,
               child: TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _mobileFocus,
                maxLines: 1,
                maxLength: 10,
                style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: '手機',
                  hintText: 'e.g. 09xxxxxxxx',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                  )
                ),
                onFieldSubmitted: (val) {
                  _fieldFoucusChange(context, _mobileFocus, _telAreaCodeFocus);
                },
               ),
             )
           ],
         ),
      )
    );

     columnList2.add(
      Container(
        // height: titleHeight(context), 
         decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
         padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
         child: Row(
           children: <Widget>[
             Expanded(
               child: Container(
                 padding: EdgeInsets.only(bottom: 15),
                 alignment: Alignment.centerLeft,
                 child: autoTextSize('市話：', TextStyle(color: Colors.black), context),
               ),
             ),
             Expanded(
               flex: 3,
               child: Row(
                 children: <Widget>[
                   Expanded(
                     flex: 1,
                     child: TextFormField(
                      controller: _telAreaCodeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _telAreaCodeFocus,
                      maxLines: 1,
                      maxLength: 3,
                      style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: '區碼',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                        )
                      ),
                      onFieldSubmitted: (val){
                        _fieldFoucusChange(context, _telAreaCodeFocus, _telPhoneFocus);
                      },
                     ),
                   ),
                   Container(
                     child: Text(' - '),
                   ),
                   Expanded(
                     flex: 2,
                     child: TextFormField(
                      controller: _telPhoneController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      focusNode: _telPhoneFocus,
                      maxLines: 1,
                      maxLength: 8,
                      style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: '電話',
                        labelStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                        )
                      ),
                      onFieldSubmitted: (val) {
                        _telPhoneFocus.unfocus();
                      },
                     ),
                   )
                 ],
               ),        
             )
           ],
         ),
      )
    );

    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        alignment: Alignment.centerLeft,
        child: autoTextSize('[裝機地址]', TextStyle(color: Colors.black), context),
      )
    );

    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),borderRadius: BorderRadius.circular(2.0), color: Colors.lightGreen[100]),
                child: autoTextSize('新北市', TextStyle(color: Colors.blue), context),
              ),
              onTap: (){},
            ),
            Container(
              child: autoTextSize('縣市', TextStyle(color: Colors.black), context),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(2.0), color: Colors.lightGreen[100]),
                child: autoTextSize('板橋區'.contains(this.logFullAddress[1]) == true ? "板橋區" : this.logFullAddress[1], TextStyle(color: Colors.blue), context),
              ),
              onTap: (){
                _showSelectorController(context, dataList: this.areaAddressArr, title: '鄉鎮市區', dropStr: 'area');
                FocusScope.of(context).unfocus();
              },
            ),
            Container(
              child: autoTextSize('鄉鎮市區', TextStyle(color: Colors.black), context),
            ),
          ],
        ),
      )
    );

    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(2.0), color: Colors.lightGreen[100]),
                child: autoTextSize('請選擇路段', TextStyle(color: Colors.blue), context),
              ),
              onTap: () {
                // _showSelectorController(context, dataList: this.roadAddressArr,title: '街路段', dropStr: 'road');
                showDialog(
                  context: context,
                  builder: (BuildContext context) => roadSelectorDialot(context)
                );
              },
            ),
            Container(
              child: autoTextSize('街路段', TextStyle(color: Colors.black), context),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 60,
              // height: 60,
              child: TextFormField(
                controller: _communityController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _communityFocus,
                maxLines: 1,
                maxLength: 3,
                style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: '巷',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                  )
                ),
                onFieldSubmitted: (val) {
                  _fieldFoucusChange(context, _communityFocus, _laneFocus);
                },
              ),
            ),
            Container(
              child: autoTextSize('巷', TextStyle(color: Colors.black), context),
            ),
             Container(
              margin: EdgeInsets.only(top: 20),
              width: 60,
              // height: 60,
              child: TextFormField(
                controller: _laneController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _laneFocus,
                maxLines: 1,
                maxLength: 3,
                style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: '弄',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                  )
                ),
                onFieldSubmitted: (String value) {
                  _fieldFoucusChange(context, _laneFocus, _unitFocus);
                },
              ),
            ),
            Container(
              child: autoTextSize('弄', TextStyle(color: Colors.black), context),
            ),
          ],
        ),
      )
    );

    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                child: TextFormField(
                  controller: _unitController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  focusNode: _unitFocus,
                  maxLines: 1,
                  maxLength: 3,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '號',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                    )
                  ),
                  onFieldSubmitted: (val) {
                    _fieldFoucusChange(context, _unitFocus, _ofUnitFocus);
                  },
                ),
              ),
            ),
            Flexible(
              child: autoTextSize(' - ', TextStyle(color: Colors.black), context)
            ),
            Flexible(
              flex: 2,
              child: Container(
                child: TextFormField(
                  controller: _ofUnitController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  focusNode: _ofUnitFocus,
                  maxLines: 1,
                  maxLength: 3,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '之號',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
                    )
                  ),
                  onFieldSubmitted: (val) {
                    _fieldFoucusChange(context, _ofUnitFocus, _floorFocus);
                  },
                ),
              ),
            ),
            Flexible(
              child: Container(
                child: autoTextSize('號', TextStyle(color: Colors.black), context)
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                child: TextFormField(
                  controller: _floorController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  focusNode: _floorFocus,
                  maxLines: 1,
                  maxLength: 2,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: '樓',
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
            Flexible(
              child: autoTextSize('樓 - ', TextStyle(color: Colors.black), context)
            ),
            Flexible(
              flex: 2,
              child: Container(
                child: TextFormField(
                  controller: _floorOfController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  focusNode: _floorOfFocus,
                  maxLines: 1,
                  maxLength: 2,
                  style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    // labelText: '樓',
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
          ],
        ),
      )
    );

    columnList2.add(
      Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            Expanded(
              child: FlatButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                child: autoTextSize('匹配', TextStyle(color: Colors.white), context),
                onPressed: () {

                },
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Expanded(
              child: FlatButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                child: autoTextSize('確定', TextStyle(color: Colors.black), context),
                onPressed: () {

                },
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      )
    );

    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '大樓：',
                style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context)),
              ),
              TextSpan(
                text: '',
                style: TextStyle(color: Colors.red, fontSize: MyScreen.defaultTableCellFontSize(context)),
              )
            ]
          ),
        )
      )
    );

    body = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: columnList,
      ),
    );
    
    return body;
   
  }





   ///下拉選擇器
  _showSelectorController(BuildContext context, { List<dynamic> dataList, String title, String valName, String dropStr}) {
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
                  case 'area':
                    this.logFullAddress[1] = dic["name"];
                    for(var dis in this.areaAddressArr) {
                      if (dis["name"].contains(dic["name"])) {
                        _getAddressData(dis["code"]);
                      }
                    }
                    break;
                  case 'road':
                    this.logFullAddress.insert(2, dic["name"]);
                    print('${this.logFullAddress.toString()}');
                    break;
                  
                } 
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