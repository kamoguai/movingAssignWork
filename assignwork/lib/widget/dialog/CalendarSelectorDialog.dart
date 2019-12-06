import 'package:assignwork/common/dao/ManageSectionDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/item/TimePeriodItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:redux/redux.dart';
///
///日期班表選擇器
///Date: 2019-10-23
///
class CalendarSelectorDialog extends StatefulWidget {
  ///由前頁傳入預約日期
  final String bookingDate;
  ///由前頁傳入地區
  final String areaStr;
  ///由前頁傳入工單號
  final String wkNoStr;

  CalendarSelectorDialog({this.bookingDate, this.areaStr, this.wkNoStr});

  @override
  _CalendarSelectorDialogState createState() => _CalendarSelectorDialogState();
}

class _CalendarSelectorDialogState extends State<CalendarSelectorDialog> with BaseWidget, TickerProviderStateMixin{
  
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  TabController _tabController;
  ScrollController _scrollController = new ScrollController();

  ///初始化日曆相關
  _initCalendar() {
    _selectedDay = DateTime.now();
   
    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400)
    );
    _animationController.forward();
  }
  ///選擇日期後event
  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;

      _getChangeDateData();
      // Fluttertoast.showToast(msg: "$_selectedDay");
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
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
      availableGestures: AvailableGestures.horizontalSwipe,
      ///日曆格式
      availableCalendarFormats: const {
        CalendarFormat.month: '月',
        // CalendarFormat.twoWeeks: '2週',
        // CalendarFormat.week: '週',
      },
      ///日曆style
      calendarStyle: CalendarStyle(
        ///所選定日期顏色
        selectedColor:  Colors.blue[200],
        ///今天顏色
        todayColor:Colors.deepOrange[400],
        ///註記顏色
        markersColor: Colors.brown[700],

        outsideDaysVisible: false,
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
      rowHeight: 35,
      ///選定日期
      onDaySelected: _onDaySelected, 
      ///controller
      calendarController: _calendarController,
      ///切換日期
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  ///渲染 Tab 的 Item
  _renderTabItem() {
    var itemList = [
      "早班",
      "中班",
      "晚班",
    ];
    renderItem(String item, int i) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          item,
          style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),
          maxLines: 1,
        ),
      );
    }
    List<Widget> list = new List();
    for (int i = 0; i < itemList.length; i++ ) {
      list.add(renderItem(itemList[i], i));
    }
    return list;
  }
  
  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

  _getChangeDateData() async {
    DateFormat df = new DateFormat('yyyy-MM-dd');
    String selectData = df.format(_selectedDay);
    Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap["accNo"] = _getStore().state.userInfo?.accNo;
    jsonMap["function"] = "queryBookService";
    jsonMap["businessType"] = "3";
    jsonMap["workorderCode"] = widget.wkNoStr;
    jsonMap["bookingDate"] = selectData;
    jsonMap["manageSectionCode"] = widget.areaStr;
    var res = await ManageSectionDao.getQueryBookService(jsonMap);
    
  }

  @override
  void initState() {
    super.initState();
    _initCalendar();
    _tabController = new TabController(
      vsync: this,
      length: 3
    );
    Fluttertoast.showToast(msg: '${widget.areaStr}');
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _calendarController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Widget body;
    List<Widget> columnList = [];
    List<Widget> columnList2 = [];
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
      _buildTableCalendar()
    );
    columnList2.add(
      Container(
        height: titleHeight(context) * 1.4,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 1), bottom: BorderSide(color: Colors.grey, width: 1),),
          color: Color(MyColors.hexFromStr('f4bf5f')),
        ),
        child: TabBar(
          indicator: BoxDecoration(
             
            color: Colors.white
          ),
          labelColor: Colors.red,
          unselectedLabelColor: Colors.white,
          tabs: _renderTabItem(),
          indicatorWeight: 0.1,
          controller: _tabController,
        ),
        // child: Flex(
        //   direction: Axis.horizontal,
        //   children: <Widget>[
        //     Expanded(
        //       child: GestureDetector(
        //         child: Container(
        //           decoration: BoxDecoration(
        //             border: Border(right: BorderSide(color: Colors.grey, width: 1),),
        //             // color: Colors.white
        //           ),

        //         ),
        //         onTap: () {

        //         },
        //       ),
        //     ),
        //     Expanded(
        //       child: FlatButton(
        //         color: Colors.amber,
        //         child: Text('午班'),
        //         onPressed: (){},
        //       ),
        //     ),
        //     Expanded(
        //       child: FlatButton(
        //         color: Colors.orange,
        //         child: Text('晚班'),
        //         onPressed: (){},
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
    columnList2.add(
      Container(
        height: titleHeight(context) * 8,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            TimePeriodItem(classStr: "早",),
            TimePeriodItem(classStr: "中",),
            TimePeriodItem(classStr: "晚",),
          ],
        ),
      )
    );
    columnList2.add(
      Container(
        height: 200, 
        color: Colors.amber,
      )
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