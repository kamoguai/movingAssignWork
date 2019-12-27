
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/dialog/CalendarSelectorDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
///
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
    _changeTimePeriodColor(dic);
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
           _isValidTimePeriod(dic, timeP);
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

  ///確定時段是否能指派，灰色不可派，白色可派
  _changeTimePeriodColor(TimePeriodModel model) {
    DateTime today = DateTime.now();
    final nowHour = today.hour;
    final diffDate = widget.selectDate.difference(today);
    ///取得差異天數
    final i = diffDate.inDays;
    ///同日期
    if (i == 0) {
      
      if (nowHour >= 9 && nowHour < 11) {
        var hStr = model.timePeriod.substring(0,2);
        var intH = int.parse(hStr);
        if (intH < 13) {
          _bkColor = Colors.grey[300];
        }
      }
      else if (nowHour >= 11 && nowHour < 16) {
        var hStr = model.timePeriod.substring(0,2);
        var intH = int.parse(hStr);
        if (intH < 18) {
          _bkColor = Colors.grey[300];
        }
      }
      else if (nowHour >16) {
        var hStr = model.timePeriod.substring(0,2);
        var intH = int.parse(hStr);
        if (intH < 22) {
          _bkColor = Colors.grey[300];
        }
      }
      else {
        _bkColor = Colors.white;
      }
    }
    ///大於日期
    else if (i == 1) {
      if (nowHour >= 20) {
        var hStr = model.timePeriod.substring(0,2);
        var intH = int.parse(hStr);
        if (intH < 13) {
          _bkColor = Colors.grey[300];
        }
      }
    }
  }
  ///檢核可用班別
  _isValidTimePeriod(TimePeriodModel model, String timeP) {
    DateTime today = DateTime.now();
    final nowHour = today.hour;
    final diffDate = widget.selectDate.difference(today);
    ///取得差異天數
    final i = diffDate.inDays;
    ///同日期
    if (i == 0) {
      
      if (nowHour >= 9 && nowHour < 11) {
        var hStr = model.timePeriod.substring(0,2);
        var intH = int.parse(hStr);
        if (intH < 13) {
          Fluttertoast.showToast(msg: '此班別已無法指派，請派其他班別。');
          return;
        }
        else {
          widget.addTransform(timeP);
        }
      }
      ///區間無法派中班
      else if (nowHour >= 11 && nowHour < 16) {
        var hStr = model.timePeriod.substring(0,2);
        var intH = int.parse(hStr);
        if (intH < 18) {
          Fluttertoast.showToast(msg: '此班別已無法指派，請派其他班別。');
          return;
        }
        else {
          widget.addTransform(timeP);
        }
      }
      ///大於16點無法派晚班
      else if (nowHour > 16 ) {
        var hStr = model.timePeriod.substring(0,2);
        var intH = int.parse(hStr);
        if (intH < 22) {
          Fluttertoast.showToast(msg: '今日已無法指派，請派其他日期。');
          return;
        }
      }
      else {
        widget.addTransform(timeP);
      }
    }
    ///大於日期
    else if (i == 1) {
      ///當天晚上20點
      if (nowHour >= 20) {
        var hStr = model.timePeriod.substring(0,2);
        var intH = int.parse(hStr);
        if (intH < 13) {
          Fluttertoast.showToast(msg: '晚上8點後無法派隔日早班，請派隔日其他班別。');
          return;
        }
        else {
          widget.addTransform(timeP);
        }
      }
      else {
        widget.addTransform(timeP);
      }
    }
    else {
      widget.addTransform(timeP);
    }
    print("所選時間 -> $timeP");
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