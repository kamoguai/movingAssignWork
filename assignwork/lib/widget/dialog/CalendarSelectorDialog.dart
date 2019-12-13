import 'package:assignwork/common/dao/BookingStatusDao.dart';
import 'package:assignwork/common/dao/ManageSectionDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/dialog/BookingResultDialog.dart';
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
  ///由前頁傳入客編
  final String custNoStr;

  CalendarSelectorDialog({this.bookingDate, this.areaStr, this.wkNoStr, this.custNoStr});

  @override
  _CalendarSelectorDialogState createState() => _CalendarSelectorDialogState();
}

class _CalendarSelectorDialogState extends State<CalendarSelectorDialog> with BaseWidget, TickerProviderStateMixin{
  ///所選日期
  DateTime _selectedDay;
  ///
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  List _selectedEvents;
  ///calendar animation
  AnimationController _animationController;
  ///calendar controller
  CalendarController _calendarController;
  ///tab controller
  TabController _tabController;
  /// scroll controller
  ScrollController _scrollController = new ScrollController();
  ///textfield node
  FocusNode _focusNode = FocusNode();
  ///裝載api資料
  List<dynamic> resApiData;
  ///model 所有list
  List<TimePeriodModel> modelList = new List<TimePeriodModel>();
  ///早班model
  List<TimePeriodModel> class1List = new List<TimePeriodModel>();
  ///午班model
  List<TimePeriodModel> class2List = new List<TimePeriodModel>();
  ///晚班model
  List<TimePeriodModel> class3List = new List<TimePeriodModel>();
  TimePeriodModel model = new TimePeriodModel();
  ///記錄所選班別
  final List<String> timePeriodArr = [];
  ///記錄textField
  String inputText = "";
  ///檢核送出
  bool isValid = false;

  ///初始化日曆相關
  _initCalendar() {
    _selectedDay = DateTime.now();
    
    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400)
    );
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
      }
      else {
        _animationController.reverse();
      }
    });
    _animationController.forward();
  }
  ///選擇日期後event
  void _onDaySelected(DateTime day, List events) {

    DateTime today = DateTime.now();
    int i = day.compareTo(today);
    var diffDate =  day.difference(today);
    int y = diffDate.inDays;
    ///如果日期小於或等於
    if (i == 0 || i == 1) {
      if (y > 30) {
        Fluttertoast.showToast(msg: '所選日期不能超過30天');
        setState(() {
          modelList.clear();
          class1List.clear();
          class2List.clear();
          class3List.clear();
          timePeriodArr.clear();
        });
        return;
      }
      setState(() {
        _selectedDay = day;

        _getChangeDateData();
      });
    }
    else {
      setState(() {
        modelList.clear();
        class1List.clear();
        class2List.clear();
        class3List.clear();
        timePeriodArr.clear();
      });
    }
    _validateSendData();
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
        ///週的style
        weekdayStyle: TextStyle(fontSize: MyScreen.normalPageFontSize(context)),
        ///週末的style
        weekendStyle: TextStyle(fontSize: MyScreen.normalPageFontSize(context), color: Colors.redAccent),

        outsideDaysVisible: false,
      ),
      ///上方顯示日期及可選週期按鈕style
      headerStyle: HeaderStyle(
        ///顯示日期的style，這裡設定字型大小
        titleTextStyle: TextStyle(fontSize: MyScreen.normalPageFontSize(context)),
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
        // padding: EdgeInsets.symmetric(vertical: 10),
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
  ///更換預約日期
  _getChangeDateData() async {
    
    modelList.clear();
    class1List.clear();
    class2List.clear();
    class3List.clear();

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
    if (res != null && res.result) {
      setState(() {
        List <dynamic> dataList = res.data;
        dataList.forEach((e) {
          model = TimePeriodModel.forMap(e);
          modelList.add(model);
        });
        ///處理班別資料
        if (modelList.length > 0) {
          for (var dic in modelList) {
            final st = dic.serviceType;
            if (st.contains("早")) {
              class1List.add(dic);
            }
            else if (st.contains("中")) {
              class2List.add(dic);
            }
            else if (st.contains("晚")) {
              class3List.add(dic);
            }
          }
        }
      });
    }
  }
  ///添加班別進入arr，以達到點擊切換顏色效果
  void _addTransform(String timePeriod) {
    setState(() {
      if (timePeriodArr.contains(timePeriod)) {
        var index = timePeriodArr.indexOf(timePeriod);
        timePeriodArr.removeAt(index);
      }
      else {
        timePeriodArr.clear();
        timePeriodArr.add(timePeriod);
      }
      _validateSendData();
    });
  }

   ///約裝撤銷dialog
  Widget _bookingResultDialog(BuildContext context, ) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: BookingResultDialog(custNo: widget.custNoStr, originDate: widget.bookingDate, changeDate: timePeriodArr[0],),
          ),
        ],
      )
    );
  }

  ///呼叫改約api
  _postModifyBookingDate(String bookingDate, String desc) async {
    Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap["function"] = "modifyBookingDate";
    jsonMap["accNo"] = _getStore().state.userInfo?.accNo;
    jsonMap["operator"] = _getStore().state.userInfo?.accNo;
    jsonMap["workorderCode"] = widget.wkNoStr;
    jsonMap["bookingDate"] = bookingDate;
    jsonMap["description"] = desc;
    var res = await BookingStatusDao.modifyBookingDate(jsonMap);
    return res;
  }

  @override
  void initState() {
    super.initState();
    _initCalendar();
    _tabController = new TabController(
      vsync: this,
      length: 3
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    modelList.clear();
    class1List.clear();
    class2List.clear();
    class3List.clear();
    timePeriodArr.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (modelList.length == 0) {
      ///初始化呼叫api
     _getChangeDateData();

    }
  }

  _validateSendData() {
    setState(() {
      if (timePeriodArr.length > 0 && inputText != "") {
        isValid = true;
      }
      else {
        isValid = false;
      }
    });
   
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
        decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),color: Color(MyColors.hexFromStr('40b89e')),),
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            autoTextSize('原裝機日期： $bookingDate', TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context) * 1.5), context),
            GestureDetector(
              child: Icon(Icons.cancel, color: Colors.white, size: titleHeight(context) * 1.3,),
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
        height: titleHeight(context) * 1.2,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 1), bottom: BorderSide(color: Colors.red, width: 1),),
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
      ),
    );
    
    columnList2.add(
      Container(
        height: (listHeight(context) * 1.4) * 4,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.red,))),
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            TimePeriodItem(key: ValueKey('class1'), classStr: "早", modelList: class1List, addTransform: _addTransform, timePeriodArr: timePeriodArr, selectDate: _selectedDay,),
            TimePeriodItem(key: ValueKey('class2'), classStr: "中", modelList: class2List, addTransform: _addTransform, timePeriodArr: timePeriodArr, selectDate: _selectedDay,),
            TimePeriodItem(key: ValueKey('class3'), classStr: "晚", modelList: class3List, addTransform: _addTransform, timePeriodArr: timePeriodArr, selectDate: _selectedDay,),
          ],
        ),
      )
    );
    if (widget.wkNoStr != null) {
      columnList2.add(
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
          child: TextField(
            focusNode: _focusNode,
            textInputAction: TextInputAction.done,
            maxLines: 4,
            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: '回覆內容',
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
              )
            ),
            onChanged: (String value) {
              inputText = value;
              _validateSendData();
            },
          ),
        ),
      );
    }
    columnList.add(
      Container(
        height: titleHeight(context) * 1.3,
        decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                height: titleHeight(context) * 1.3,
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
                  color: isValid == true ? Color(MyColors.hexFromStr('40b89e')) : Colors.grey,
                  child: Text('確定', style: TextStyle(color: Colors.white, fontSize: MyScreen.normalPageFontSize(context)),),
                  onPressed: () async {
                    if (isValid) {
                      ///改約
                      if (widget.wkNoStr != null) {
                        var res = await _postModifyBookingDate(timePeriodArr[0], inputText);
                        if (res) {
                          Navigator.pop(context);
                          showDialog(
                            context: context, 
                            builder: (BuildContext context)=> _bookingResultDialog(context)
                          );
                        }
                        else {
                          return;
                        }
                      }
                      else {
                        
                      }
                    }
                  },
                ),
              ),
            )
          ],
        ),
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
///班別class model
class TimePeriodModel {

  String serviceType;
  String timePeriod;
  String acceptedAmount;
  String sumAmount;

  TimePeriodModel();

  TimePeriodModel.forMap(data) {
    serviceType = data["serviceType"] == null ? "" : data["serviceType"];
    timePeriod = data["timePeriod"] == null ? "" : data["timePeriod"].toString();
    acceptedAmount = data["acceptedAmount"] == null ? "" : data["acceptedAmount"].toString();
    sumAmount = data["sumAmount"] == null ? "" : data["sumAmount"].toString();
  }
}