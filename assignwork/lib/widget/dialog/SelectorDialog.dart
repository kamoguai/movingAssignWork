import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///共用選擇器，包括filter功能
///Date: 2019-12-27
class SelectorDialog extends StatefulWidget {
  ///由上頁傳入dataList
  final List<dynamic> dataList;
  ///由上頁傳入func，此頁選定後把值帶回前頁
  final Function selectFunc;
  ///由上頁傳入所要查詢item name
  final String findItemName;
  ///由上頁傳入所要查詢label text
  final String labelTxt;
  ///由上頁傳入所要查詢title text
  final String titleTxt;
  ///由上頁傳入所要查詢error text
  final String errTxt;
  ///由上頁傳入所要model name text
  final String modelName;
  ///由上頁傳入所要model value text
  final String modelVal;

  SelectorDialog({this.dataList, this.selectFunc, this.findItemName, this.labelTxt, this.titleTxt, this.errTxt, this.modelName, this.modelVal});

  @override
  _SelectorDialogState createState() => _SelectorDialogState();
}

class _SelectorDialogState extends State<SelectorDialog> with BaseWidget {

  ///裝載資料
  List<dynamic> dataArray = [];
  ///原始資料
  List<dynamic> originArray = [];
  ///所選資料
  Map<String, dynamic> pickData = {};
  ///textField controller
  TextEditingController textEditingController =  TextEditingController();
  FocusNode textFocus = FocusNode();

  ///filter功能
  void filterSearchResult(String str) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(dataArray);
    if (str.isNotEmpty) {
      List<dynamic> dummyListData = List<dynamic>();
      dummySearchList.forEach((item) {
        if (item[widget.findItemName].contains(str)) {
          dummyListData.add(item);
          setState(() {
            dataArray = dummyListData;
          });
        }
      });
      return ;
    }
    else {
      setState(() {
        dataArray = originArray;
      });
    }
  }

  ///搜尋bar
  Widget searchTextField() {
    Widget content;
    content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onSubmitted: (value) {
          filterSearchResult(value);
        },
        controller: textEditingController,
        focusNode: textFocus,
        decoration: InputDecoration(
          labelText: widget.labelTxt,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
          ),
        ),
      ),
    );
    return content;
  }
  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = dataArray[index];
    var dic = SelectorModel.forMap(dicIndex, modelName: widget.modelName, modelVal: widget.modelVal);
    item = GestureDetector(
      child: Container(
        color: pickData == dicIndex ? Colors.yellow : Colors.white,
        height: titleHeight(context) * 1.5,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Center(
          child: autoTextSize(dic.name, TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), context),
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

  @override
  void initState() {
    super.initState();
    dataArray = widget.dataList;
    originArray = widget.dataList;
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
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
             child: Center(child: autoTextSize(widget.titleTxt, TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),)
           ),
           searchTextField(),
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
                            Fluttertoast.showToast(msg: widget.errTxt);
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
  ///路名
  String name;
  ///路代碼
  String code;

  SelectorModel();

  SelectorModel.forMap(dic, {modelName, modelVal}) {
    name = dic[modelName] == null ? "" : dic[modelName];
    code = dic[modelVal] == null ? "" : dic[modelVal];
  }
}