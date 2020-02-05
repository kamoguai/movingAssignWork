
import 'dart:convert';

import 'package:assignwork/common/dao/ManageSectionDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/dialog/SelectorDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
///
///新戶約裝輸入客戶基本資料的dialog
///Date: 2019-12-18
class CustDetailSelectDialog extends StatefulWidget {
  final Function getMatchDataFunc;
  final Map<String, dynamic> logMatchAddr;
  CustDetailSelectDialog({this.getMatchDataFunc, this.logMatchAddr});

  @override
  _CustDetailSelectDialogState createState() => _CustDetailSelectDialogState();

}

class _CustDetailSelectDialogState extends State<CustDetailSelectDialog> with BaseWidget{
  
  ///地址地區arr
  List<dynamic> areaAddressArr = [];
  ///街路段arr
  List<dynamic> roadAddressArr = [];
  ///記錄全路段
  Map<String, dynamic> logFullAddress = {"city": "新北市", "area": "板橋區", "areaCode": "220/ROOT", "road": "", "roadCode": "", "community": "", "lane": "", "unit": "", "ofUnit": "", "floor": "", "floorOf": "", "custName": "", "mobile": "", "telAreaCode": "" , "telPhone": "", "fullAddressCode": "", "fullAddress": "", "buildingName": ""};
  ///記錄市區代碼
  String manageSectionCodeStr = "";
  ///記錄匹配後地址
  Map<String, dynamic> logMatchAddr = {};

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
  ///是否檢核通過
  bool _isValid = false;
  ///是否通過匹配
  bool _isGetAddressPK = false;
  ///第一次call地址，避免反覆呼叫
  bool _isFirstCallAddress = true;

  ///鍵盤config
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardAction(
          focusNode: _mobileFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(child: autoTextSize('完成', TextStyle(color: Colors.black), context), onTap: (){_fieldFoucusChange(context, _mobileFocus, _telAreaCodeFocus);},)
          ),
        ),
        KeyboardAction(
          focusNode: _telAreaCodeFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(child: autoTextSize('完成', TextStyle(color: Colors.black), context), onTap: (){_fieldFoucusChange(context, _telAreaCodeFocus, _telPhoneFocus);},)
          ),
        ),
        KeyboardAction(
          focusNode: _telPhoneFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: autoTextSize('完成', TextStyle(color: Colors.black), context)
          ),
        ),
        KeyboardAction(
          focusNode: _communityFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(child: autoTextSize('完成', TextStyle(color: Colors.black), context), onTap: (){_fieldFoucusChange(context, _communityFocus, _laneFocus);},)
          ),
        ),
        KeyboardAction(
          focusNode: _laneFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: autoTextSize('完成', TextStyle(color: Colors.black), context)
          ),
        ),
        KeyboardAction(
          focusNode: _unitFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(child: autoTextSize('完成', TextStyle(color: Colors.black), context), onTap: (){_fieldFoucusChange(context, _unitFocus, _ofUnitFocus);},)
          ),
        ),
        KeyboardAction(
          focusNode: _ofUnitFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: autoTextSize('完成', TextStyle(color: Colors.black), context)
          ),
        ),
        KeyboardAction(
          focusNode: _floorFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: InkWell(child: autoTextSize('完成', TextStyle(color: Colors.black), context), onTap: (){_fieldFoucusChange(context, _floorFocus, _floorOfFocus);},)
          ),
        ),
        KeyboardAction(
          focusNode: _floorOfFocus,
          closeWidget: Padding(
            padding: EdgeInsets.all(5),
            child: autoTextSize('完成', TextStyle(color: Colors.black), context)
          ),
        ),
      ]
    );
  }
  
  _fieldFoucusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }


  ///取得地址api
  _getAddressData(String sectionCode) async {
    ///初始化road arr
    this.roadAddressArr.clear();
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "queryManageSection";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["currentManageSectionCode"] = sectionCode;
    var res = await ManageSectionDao.getQueryManageSection(paramMap);
    if (res.result) {
      if(mounted)
      setState(() {
        isLoading = false;
        this.roadAddressArr = res.data;
        this._isFirstCallAddress = false;
      });
      
    }
  }
  
  ///匹配地址
  _postMatchAddress() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    Map<String, dynamic> paramMap2 = new Map<String, dynamic>();
    paramMap2["parentManageSectoinCode"] = this.logFullAddress["roadCode"];
    paramMap2["community"] = _communityController.text.length == 0 ? "0" : _communityController.text;
    paramMap2["lane"] = _laneController.text.length == 0 ? "0" : _laneController.text;
    paramMap2["unit"] = _unitController.text.length == 0 ? "0" : _unitController.text;
    paramMap2["ofUnit"] = _ofUnitController.text.length == 0 ? "0" : _ofUnitController.text;
    paramMap2["floor"] = _floorController.text.length == 0 ? "0" : _floorController.text;
    paramMap2["floorOf"] = _floorOfController.text.length == 0 ? "0" : _floorOfController.text;
    paramMap2["description"] = "";

    paramMap["function"] = "matchAddress";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["installAddress"] = paramMap2;
    paramMap["postAddress"] = paramMap2;
    CommonUtils.showLoadingDialog(context);
    var res = await ManageSectionDao.postMatchAddress(paramMap);
    Navigator.pop(context);
    if (res.result) {
      setState(() {
        this._isGetAddressPK = true;
        this.logMatchAddr = res.data;
        this.logFullAddress["fullAddressCode"] = res.data["installAddressCode"];
        this.logFullAddress["buildingName"] = res.data["InstallAddressBuildingName"];
        _appendFullData();
        Fluttertoast.showToast(msg: '匹配成功！');
      });
    }
    else {
      Fluttertoast.showToast(msg: res.data);
      return ;
    }
  }

  _appendFullData() {
      this.logFullAddress["community"] = _communityController.text;
      this.logFullAddress["lane"] = _laneController.text;
      this.logFullAddress["unit"] = _unitController.text;
      this.logFullAddress["ofUnit"] = _ofUnitController.text;
      this.logFullAddress["floor"] =  _floorController.text;
      this.logFullAddress["floorOf"] = _floorOfController.text;
      this.logFullAddress["custName"] = _nameController.text;
      this.logFullAddress["mobile"] = _mobileController.text;
      this.logFullAddress["telAreaCode"] = _telAreaCodeController.text;
      this.logFullAddress["telPhone"] = _telPhoneController.text;
     
      var fullAddr = "${this.logFullAddress["city"]}${this.logFullAddress["area"]}${this.logFullAddress["road"]}";
      if (this.logFullAddress["community"] != "") {
        fullAddr += "${this.logFullAddress["community"]}巷";
      }
      if (this.logFullAddress["lane"] != "") {
        fullAddr += "${this.logFullAddress["lane"]}弄";
      }
      if (this.logFullAddress["unit"] != "") {
        fullAddr += "${this.logFullAddress["unit"]}號";
      }
      if (this.logFullAddress["ofUnit"] != "") {
        fullAddr += "之${this.logFullAddress["ofUnit"]}號";
      }
      if (this.logFullAddress["floor"] != "") {
        fullAddr += "${this.logFullAddress["floor"]}樓";
      }
      if (this.logFullAddress["floorOf"] != "") {
        fullAddr += "之${this.logFullAddress["floorOf"]}樓";
      }
      this.logFullAddress["fullAddress"] = fullAddr;
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
        // child: RoadSelectDialog(dataList: roadData, selectFunc: _selectFunc,),
        child: SelectorDialog(dataList: roadData, selectFunc: _selectFunc, findItemName: 'name', labelTxt: '道路', titleTxt: '選擇道路', errTxt: '尚未選擇路段！', modelName: 'name', modelVal: 'code',),
      )
    );
  }

  void _selectFunc(Map<String, dynamic> map) {
    setState(() {
      this.logFullAddress["road"] = map["name"];
      this.logFullAddress["roadCode"] = map["code"];
      
    });
  }

  void initData() {
    ///callback時進入
    if (widget.logMatchAddr.length > 0) {
      _nameController.value = TextEditingValue(text: widget.logMatchAddr["custName"] ?? "");
      _mobileController.value = TextEditingValue(text: widget.logMatchAddr["mobile"] ?? "");
      _telAreaCodeController.value = TextEditingValue(text: widget.logMatchAddr["telAreaCode"] ?? "");
      _telPhoneController.value = TextEditingValue(text: widget.logMatchAddr["telPhone"] ?? "");
      _communityController.value = TextEditingValue(text: widget.logMatchAddr["community"] ?? "");
      _laneController.value = TextEditingValue(text: widget.logMatchAddr["lane"] ?? "");
      _unitController.value = TextEditingValue(text: widget.logMatchAddr["unit"] ?? "");
      _ofUnitController.value = TextEditingValue(text: widget.logMatchAddr["ofUnit"] ?? "");
      _floorController.value = TextEditingValue(text: widget.logMatchAddr["floor"] ?? "");
      _floorOfController.value = TextEditingValue(text: widget.logMatchAddr["floorOf"] ?? "");
      this.logFullAddress["area"] = widget.logMatchAddr["area"];
      this.logFullAddress["areaCode"] = widget.logMatchAddr["areaCode"];
      this.logFullAddress["road"] = widget.logMatchAddr["road"];
      this.logFullAddress["roadCode"] = widget.logMatchAddr["roadCode"];
      
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
    _nameController.dispose();
    _nameFocus.dispose();
    _mobileController.dispose();
    _mobileFocus.dispose();
    _telAreaCodeController.dispose();
    _telAreaCodeFocus.dispose();
    _telPhoneController.dispose();
    _telPhoneFocus.dispose();
    _communityController.dispose();
    _communityFocus.dispose();
    _laneController.dispose();
    _laneFocus.dispose();
    _unitController.dispose();
    _unitFocus.dispose();
    _ofUnitController.dispose();
    _ofUnitFocus.dispose();
    _floorController.dispose();
    _floorFocus.dispose();
    _floorOfController.dispose();
    _floorOfFocus.dispose();
    _scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    ///初次進入
    if (widget.logMatchAddr.length == 0) {
      if (this.roadAddressArr.length == 0 && this._isFirstCallAddress) {
        var currentSection = json.decode(areaAddressJson);
        this.areaAddressArr = currentSection;
        isLoading = true;
        _getAddressData(this.areaAddressArr[4]["code"]);

      }
    }
    ///callback 進入
    else {
      if (this._isFirstCallAddress) {
        var currentSection = json.decode(areaAddressJson);
        this.areaAddressArr = currentSection;
        for (var dic in this.areaAddressArr) {
          if (dic["name"].toString().contains(this.logFullAddress["area"])) {
            if(mounted)
            isLoading = true;
            _getAddressData(dic["code"]);
          }
        }
      }
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
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),color: Color(MyColors.hexFromStr('40b89e'))),
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            autoTextSize('客戶資料輸入', TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context) * 1.5), context),
            GestureDetector(
              child: Icon(Icons.cancel, color: Colors.white, size: titleHeight(context) * 1.3,),
              onTap: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            )
            
          ],
        ),
      ),
    );

    columnList.add(
        Expanded(
        child: KeyboardActions(
          config: _buildConfig(context),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            child: Column(
              children: columnList2,
            ),
          ),
        )
      ),
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
                  if (val.length < 10) {
                    Fluttertoast.showToast(msg: '請輸入完整手機號！');
                    return;
                  }
                  else {
                    var subStr = val.substring(0,2);
                    if (!subStr.contains("09")) {
                      Fluttertoast.showToast(msg: '請輸入正確的手機號碼！');
                      return;
                    } 
                    _fieldFoucusChange(context, _mobileFocus, _telAreaCodeFocus);

                  }
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(2.0), color: Colors.lightGreen[100]),
                child: autoTextSize('板橋區'.contains(this.logFullAddress["area"]) == true ? "板橋區" : this.logFullAddress["area"], TextStyle(color: Colors.blue), context),
              ),
              onTap: (){                
                FocusScope.of(context).unfocus();
                _showSelectorController(context, dataList: this.areaAddressArr, title: '鄉鎮市區', dropStr: 'area');
              },
            ),
            Container(
              child: autoTextSize('鄉鎮市區', TextStyle(color: Colors.black), context),
            ),
          ],
        ),
      )
    );

    var roadStr = "";
    if (this.logFullAddress["road"] != "") {
      roadStr = this.logFullAddress["road"];
    }
    else {
      roadStr = '請選擇路段';
    }
    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid), borderRadius: BorderRadius.circular(2.0), color: Colors.lightGreen[100]),
                child: autoTextSize(roadStr, TextStyle(color: Colors.blue), context),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                if (!isLoading && this.roadAddressArr.length > 0)
                showDialog(
                  context: context,
                  builder: (BuildContext context) => roadSelectorDialot(context)
                );
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: autoTextSize('街路段', TextStyle(color: Colors.black), context),
            ),
            
          ],
        ),
      )
    );

    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Container(
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
            ),
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: autoTextSize('巷', TextStyle(color: Colors.black), context),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
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
            ),
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: autoTextSize('弄', TextStyle(color: Colors.black), context),
              ),
            ),
          ],
        ),
      )
    );

    columnList2.add(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 3,
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
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: autoTextSize(' - ', TextStyle(color: Colors.black), context)
              ),
            ),
            Flexible(
              flex: 3,
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
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: autoTextSize('號', TextStyle(color: Colors.black), context)
              ),
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
          children: <Widget>[
            Flexible(
              flex: 3,
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
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: autoTextSize('樓 - ', TextStyle(color: Colors.black), context)
              ),
            ),
            Flexible(
              flex: 3,
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
                    labelText: '之樓',
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
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );

    columnList.add(
      Container(
        height: titleHeight(context) * 1.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                height: titleHeight(context) * 1.3,
                child: FlatButton(
                  color: Colors.purple[50],
                  child: autoTextSize('匹配', TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    _isValid = _validateSubmit();
                    if(_isValid) {
                      _postMatchAddress();
                    }
                    else {
                      return ;
                    }
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
                    FocusScope.of(context).unfocus();
                    if(this._isGetAddressPK) {
                      Navigator.pop(context);
                      widget.getMatchDataFunc(this.logFullAddress);
                    }
                    else {
                      Fluttertoast.showToast(msg: "請先匹配地址！");
                      return;
                    }
                  },
                ),
              )
            )
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
                text: this.logMatchAddr["InstallAddessBuildingName"] == null ? "" : this.logMatchAddr["InstallAddessBuildingName"],
                style: TextStyle(color: Colors.red, fontSize: MyScreen.defaultTableCellFontSize(context)),
              )
            ]
          ),
        )
      )
    );

    body = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: columnList
      ),
    );
    
    return body;
   
  }
  ///欄位檢核
  bool _validateSubmit() {
    if (_nameController.text.length == 0) {
      Fluttertoast.showToast(msg: '請填妥顧客姓名。');
      return false;
    }
    if ((_mobileController.text.length == 0) && (_telPhoneController.text.length == 0)) {
      Fluttertoast.showToast(msg: '市話或手機請至少填入一項。');
      return false;
    }
    if (_telPhoneController.text.length > 0) {
      if (_telAreaCodeController.text.length == 0) {
        Fluttertoast.showToast(msg: '請輸入市話區碼。');
      return false;
      }
    }
    if (this.logFullAddress["road"] == "" ) {
      Fluttertoast.showToast(msg: '路段尚未選擇');
      return false;
    }
    if (this.logFullAddress["community"] == "" && this.logFullAddress["lane"] != "") {
      Fluttertoast.showToast(msg: '您沒有輸入『巷』，『弄』不能輸入。');
      return false;
    }
    if (this.logFullAddress["unit"] == "" && this.logFullAddress["ofUnit"] != "") {
      Fluttertoast.showToast(msg: '您沒有輸入『號』，『之號』不能輸入。');
      return false;
    }
    if (this.logFullAddress["floor"] == "" && this.logFullAddress["floorOf"] != "") {
      Fluttertoast.showToast(msg: '您沒有輸入『樓』，『之樓』不能輸入。');
      return false;
    }
    if (this.logFullAddress["unit"] == "" && this.logFullAddress["floor"] != "") {
      Fluttertoast.showToast(msg: '您沒有輸入『號』，『樓』不能輸入。');
      return false;
    }
    if (this.logFullAddress["floor"] != "" ) {
      int i = int.parse(this.logFullAddress["floor"]);
      if (i >= 100)
      Fluttertoast.showToast(msg: '請勿輸入不合理樓層。');
      return false;
    }
    if (this.logFullAddress["floorOf"] != "" ) {
      int i = int.parse(this.logFullAddress["floorOf"]);
      if (i >= 100)
      Fluttertoast.showToast(msg: '請勿輸入不合理樓層之幾。');
      return false;
    }

    return true;

  }

   ///下拉選擇器
  _showSelectorController(BuildContext context, { List<dynamic> dataList, String title, String valName, String dropStr}) {
    FocusScope.of(context).unfocus();
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
                    this.logFullAddress["area"] = dic["name"];
                    this.logFullAddress["areaCode"] = dic["code"];
                    for(var dis in this.areaAddressArr) {
                      if (dis["name"].contains(dic["name"])) {
                        _getAddressData(dis["code"]);
                      }
                    }
                    break;
                } 
                isLoading = true;
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