
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/dialog/CalendarSelectorDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
///選擇班表頁面
///Date: 2019-11-01
///
class TimePeriodItem extends StatefulWidget {
  final String classStr;
  final List<TimePeriodModel> modelList;
  final Function addTransform;
  final List<String> timePeriodArr;
  final DateTime selectDate;
  TimePeriodItem({Key key, this.classStr, this.modelList, this.addTransform, this.timePeriodArr, this.selectDate}) : super(key: key);
  @override
  _TimePeriodItemState createState() => _TimePeriodItemState();
}

class _TimePeriodItemState extends State<TimePeriodItem> with BaseWidget{

  Color _bkColor;

  @override
  void initState() {
    super.initState();
    initLayout();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initLayout() {
    
    _bkColor = Colors.white;
    
  }


  Widget _renderItem(BuildContext context, int index) {
    var dic = widget.modelList[index];
    final subStr = dic.timePeriod.substring(0, dic.timePeriod.indexOf("-"))+":00";
    DateFormat df = new DateFormat("yyyy-MM-dd");
    String dateStr = df.format(widget.selectDate);
    final timeP = "$dateStr $subStr";
    if (widget.timePeriodArr.contains(timeP)) {
      _bkColor = Colors.yellow;
    }
    else {
      _bkColor = Colors.white;
    }
    return InkWell(
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)),color: _bkColor),
        height: listHeight(context) * 1.4,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: autoTextSize(dic.serviceType, TextStyle(color: Colors.black), context),
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                child: autoTextSize(dic.timePeriod, TextStyle(color: Colors.black), context),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: autoTextSize(dic.acceptedAmount, TextStyle(color: Colors.blue), context),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: autoTextSize('/', TextStyle(color: Colors.black), context),
                    ),
                    Container(  
                      alignment: Alignment.center,
                      child: autoTextSize(dic.sumAmount, TextStyle(color: Colors.red), context),
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
           
           widget.addTransform(timeP);
           Fluttertoast.showToast(msg: timeP);
        });
      },
    );
  }

  Widget _renderListView() {
    Widget listView;
    if (widget.modelList.length > 0) {
      listView = Container(
        height: (listHeight(context) * 1.4) * 4,
        child: ListView.builder(
          itemBuilder: _renderItem,
          itemCount: widget.modelList.length,
        ),
      );
    }
    else {
      listView = CommonUtils.buildEmpty();
    }
    return listView;
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.modelList.length < 1) {
      return CommonUtils.buildEmpty();
    }
    else {

      return _renderListView();
    }
  }
}