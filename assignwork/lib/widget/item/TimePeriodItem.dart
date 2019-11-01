import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
///選擇班表頁面
///Date: 2019-11-01
///
class TimePeriodItem extends StatefulWidget {
  final String classStr;
  TimePeriodItem({Key key, this.classStr}) : super(key: key);
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
    switch (widget.classStr) {
      case "早":
      setState(() {
        _bkColor = Colors.yellow;
      });
      break;
      case "中":
      setState(() {
        _bkColor = Colors.blue;
      });
      break;
      case "晚":
      setState(() {
        _bkColor = Colors.grey;
      });
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: _bkColor
    );
  }
}