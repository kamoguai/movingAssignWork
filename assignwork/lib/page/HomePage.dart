import 'dart:convert';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/local/LocalStorage.dart';
import 'package:assignwork/common/model/UserInfo.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/page/bookingStatus/bookingStatusType1Page.dart';
import 'package:assignwork/page/bookingStatus/bookingStatusType2Page.dart';
import 'package:assignwork/page/bookingStatus/bookingStatusType3Page.dart';
import 'package:assignwork/page/bookingStatus/bookingStatusType4Page.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/HomeDrawer.dart';
import 'package:assignwork/widget/MyTabBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:redux/redux.dart';


class HomePage extends StatefulWidget {
  static final String sName = "home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with BaseWidget, SingleTickerProviderStateMixin {
  
  final TarWidgetControl tarBarControl = new TarWidgetControl();
  ///約裝key
  GlobalKey<BookingStatusType1PageState> type1Key = new GlobalKey<BookingStatusType1PageState>();
  ///完工key
  GlobalKey<BookingStatusType2PageState> type2Key = new GlobalKey<BookingStatusType2PageState>();
  ///未完工key
  GlobalKey<BookingStatusType3PageState> type3Key = new GlobalKey<BookingStatusType3PageState>();
  ///撤銷key
  GlobalKey<BookingStatusType4PageState> type4Key = new GlobalKey<BookingStatusType4PageState>();
  ///實體數據
  final StatusDetailModel statusModel = new StatusDetailModel();
  ///bottomNavigatorBar index
  int _bnbIndex = 0;

  TabController _tabController;
  List<Widget> tabItems;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: 4
    );
    _checkServerMode();
    
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

  _checkServerMode() async {
    var text = await LocalStorage.get(Config.SERVERMODE);
    if (text != null) {
      if(mounted) {
        setState(() {
          Address.isEnterTest = true;
          Fluttertoast.showToast(msg: '歡迎使用測試機');
        });
      }
    }
  }


  ///渲染 Tab 的 Item
  _renderTabItem() {
    var itemList = [
      "約裝",
      "完工",
      "未完工",
      "撤銷"
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
  
  ///bottomNavigationBar action
  void _bottomNavBarAction(int index) {
    
    setState(() {
      _bnbIndex = index;
      if(mounted) {
        switch (index) {
          case 0:

          break;
          case 1:

          break;
          case 2:
            NavigatorUtils.goLogin(context);
          break;
        }
      }
    });
  }

  ///Scaffold bottomBar widget
  Widget bottomBar() {
    Widget bottom = Material(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 42,
                child: autoTextSize(
                    '刷新',
                    TextStyle(
                        color: Colors.white,
                        fontSize: MyScreen.homePageFontSize(context)), context),
              ),
              onTap: () {
              },
            ),
          ),
          Flexible(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 42,
                child: autoTextSize(
                    '新增',
                    TextStyle(
                        color: Colors.white,
                        fontSize: MyScreen.homePageFontSize(context)),context),
              ),
              onTap: () {},
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              height: 30,
              child: FlatButton.icon(
                icon: Image.asset('static/images/24.png'),
                color: Colors.transparent,
                label: Text(''),
                onPressed: () {
                  NavigatorUtils.goLogin(context);
                },
              ),
            ),
          ),
          Flexible(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 42,
                child: autoTextSize(
                    '',
                    TextStyle(
                        color: Colors.white,
                        fontSize: MyScreen.homePageFontSize(context)),context),
              ),
              onTap: () {},
            ),
          ),
          Flexible(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 42,
                child: autoTextSize(
                    '返回',
                    TextStyle(
                        color: Colors.white,
                        fontSize: MyScreen.homePageFontSize(context)),context),
              ),
              onTap: () {
                setState(() {
                });
              },
            ),
          ),
        ],
      ),
    );
    return bottom;
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('首頁',)
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('查詢')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          title: Text('登出'),
        ),
      ],
      backgroundColor: Color(MyColors.hexFromStr('#f4bf5f')),
      currentIndex: _bnbIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      onTap: _bottomNavBarAction,
    );
  }

  Future<bool> _dialogExitApp(BuildContext context) async {
    ///如果是安卓，回到桌面
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.HOME'
      );
      await intent.launch();
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return MyTabBarWidget(
      drawer: HomeDrawer(),
      tabItems: _renderTabItem(),
      tabViews: [
        BookingStatusType1Page(),
        BookingStatusType2Page(),
        BookingStatusType3Page(),
        BookingStatusType4Page(),
      ],
      backgroundColor: Theme.of(context).primaryColor,
      indicatorColor: Colors.white,
      title: Text('約裝狀態查詢', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
      onPageChanged: (index) {
        statusModel.setCurrentIndex(index);
      },
      bottomNavBarChild: _bottomNavBar(),
    );
    
  }
}

///首頁數據實體，包含當前index
class StatusDetailModel extends Model {
  static StatusDetailModel of(BuildContext context) => ScopedModel.of<StatusDetailModel>(context);

  int _currentIndex = 0;

  String _accNo = "";

  String _accName = "";

  String _deptId = "";

  int get currentIndex => _currentIndex;

  String get currentAccNo => _accNo;

  String get currentAccName => _accName;

  String get currentDeptId => _deptId;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setCurrentAccNo(String accno) {
    _accNo = accno;
    notifyListeners();
  }

  void setCurrentAccName(String accname) {
    _accName = accname;
    notifyListeners();
  }

  void setCurrentDeptId(String deptid) {
    _deptId = deptid;
    notifyListeners();
  }
}