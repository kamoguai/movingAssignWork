import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:assignwork/common/utils/CommonUtils.dart';

///
///日期選擇widget
///Date: 2019-07-24
class MyCalendarWidget extends StatefulWidget {
  final calendarController;
  MyCalendarWidget({this.calendarController});
  @override
  _MyCalendarWidgetState createState() => _MyCalendarWidgetState();
}

class _MyCalendarWidgetState extends State<MyCalendarWidget>
    with TickerProviderStateMixin {
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    _selectedEvents = [];
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animationController.forward();
    _calendarController = CalendarController();
  }

  void _onDaySelected(DateTime day, List events, List none) {
    setState(() {
      _selectedDay = day;
      CommonUtils.showToast(context, msg: "$_selectedDay");
    });
  }

  ///cladar相關style顯示
  Widget _buildTableCalendar() {
    return TableCalendar(
      ///多國語
      locale: 'zh_CN',

      ///顯示事件
      events: {},

      ///顯示假期
      holidays: {},

      ///初始化要顯示week, twoweek, month
      initialCalendarFormat: CalendarFormat.month,

      ///動畫演示
      formatAnimation: FormatAnimation.slide,

      ///起始日，可選週一或週日
      startingDayOfWeek: StartingDayOfWeek.monday,

      ///操作行為
      availableGestures: AvailableGestures.none,

      ///日曆格式
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        // CalendarFormat.twoWeeks: '2 weeks',
        // CalendarFormat.week: 'Week',
      },

      ///日曆style
      calendarStyle: CalendarStyle(
        ///所選定日期顏色
        selectedColor: Colors.blue[200],

        ///今天顏色
        todayColor: Colors.deepOrange[400],

        ///註記顏色
        markersColor: Colors.brown[700],
      ),

      ///上方顯示日期及可選週期按鈕style
      headerStyle: HeaderStyle(
        ///顯示日期的style，這裡設定字型大小
        titleTextStyle: TextStyle(fontSize: 16),

        ///左邊箭頭padding，設定1為最小
        leftChevronPadding: EdgeInsets.all(1),

        ///右邊箭頭padding，設定1為最小
        rightChevronPadding: EdgeInsets.all(1),

        ///日期置中
        centerHeaderTitle: true,

        ///週期按鈕不顯示
        // formatButtonVisible: false
      ),

      ///日曆間隔
      rowHeight: 30,

      ///選定日期
      onDaySelected: _onDaySelected,

      ///controller
      calendarController: _calendarController,

      ///切換日期
      // onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildTableCalendar(),
    );
  }
}
