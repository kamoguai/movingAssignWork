import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/MyCalendarWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
///
///日期班表選擇器
///Date: 2019-10-23
///
class CalendarSelectorDialog extends StatefulWidget {
  ///由前頁傳入預約日期
  final String bookingDate;

  CalendarSelectorDialog({this.bookingDate});

  @override
  _CalendarSelectorDialogState createState() => _CalendarSelectorDialogState();
}

class _CalendarSelectorDialogState extends State<CalendarSelectorDialog> with BaseWidget{
  ///日曆controller
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Widget body;
    List<Widget> columnList = [];
    DateFormat dft = new DateFormat('yyyy-MM-dd HH:mm:ss');
    var bookingDate;
    ///將約裝日期formate成自己要的格式
    bookingDate = dft.parse(widget.bookingDate);
    dft = new DateFormat('yy-MM-dd (HH:mm)');
    bookingDate = dft.format(bookingDate);

    columnList.add(
      Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            autoTextSize('原裝機日期： $bookingDate', TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context) * 1.5), context),
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
      MyCalendarWidget(calendarController: _calendarController,)
    );
    columnList.add(
      Container(
        height: titleHeight(context) * 1.2,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 1), bottom: BorderSide(color: Colors.grey, width: 1),),
          color: Colors.pink
        ),
      ),
    );

    body = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: columnList,
      ),
    );

    return body;
  }
}