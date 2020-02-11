import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';

import 'package:assignwork/common/utils/CommonUtils.dart';

///
///街道路選擇器
///Date: 2019-12-20
class RoadSelectDialog extends StatefulWidget {
  ///由上頁傳入dataList
  final List<dynamic> dataList;
  ///由上頁傳入func，此頁選定後把值帶回前頁
  final Function selectFunc;

  RoadSelectDialog({this.dataList, this.selectFunc});

  @override
  _RoadSelectDialogState createState() => _RoadSelectDialogState();
}

class _RoadSelectDialogState extends State<RoadSelectDialog> with BaseWidget {

  ///裝載資料
  List<dynamic> dataArray = [];
  List<dynamic> originArray = [];
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
        if (item['name'].contains(str)) {
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
    Widget widget;
    widget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onSubmitted: (value) {
          filterSearchResult(value);
        },
        controller: textEditingController,
        focusNode: textFocus,
        decoration: InputDecoration(
          labelText: '路名',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
          ),
        ),
      ),
    );
    return widget;
  }
  ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = dataArray[index];
    var dic = RoadSelectorModel.forMap(dicIndex);
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
             child: Center(child: autoTextSize('選擇道路', TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)), context),)
           ),
           searchTextField(),
           listView(),
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
                            CommonUtils.showToast(context, msg: '尚未選擇路段！');
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

class RoadSelectorModel {
  ///路名
  String name;
  ///路代碼
  String code;

  RoadSelectorModel();

  RoadSelectorModel.forMap(dic) {
    name = dic["name"] == null ? "" : dic["name"];
    code = dic["code"] == null ? "" : dic["code"];
  }
}