import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/MyListState.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final String sName = "home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage>, MyListState<HomePage> {
  

  var isOpenMenu = false;

  @override
  void initState() {
    super.initState();
    clearData();
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }
  
  @override
  bool get isRefreshFirst => false;

  /// app bar action
  List<Widget> actions() {
    List<Widget> list = [
      Expanded(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  child: autoTextSize(
                      '新北全區',
                      TextStyle(
                          color: Colors.white,
                          fontSize: MyScreen.homePageFontSize(context))),
                ),
              ),
            ),
            Flexible(
              child: Container(
                alignment: Alignment.center,
                height: 30,
                child: autoTextSize(
                    '走馬燈',
                    TextStyle(
                        color: Colors.white,
                        fontSize: MyScreen.homePageFontSize(context))),
              ),
            ),
            Flexible(
              child: Container(),
            )
          ],
        ),
      )
    ];
    return list;
  }

  ///body widget
  Widget bodyView() {
    return Container(
      color: Colors.white,
    );
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
                        fontSize: MyScreen.homePageFontSize(context))),
              ),
              onTap: () {
                showRefreshLoading();
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
                        fontSize: MyScreen.homePageFontSize(context))),
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
                        fontSize: MyScreen.homePageFontSize(context))),
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
                        fontSize: MyScreen.homePageFontSize(context))),
              ),
              onTap: () {
                setState(() {
                  isOpenMenu = true;
                });
              },
            ),
          ),
        ],
      ),
    );
    return bottom;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Align(alignment: Alignment.center, child: Text('約裝查詢'),),
            // leading: Container(),
            // elevation: 0.0,
            // actions: actions(),
          ),
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountEmail: Text('帳號：A0623 楊洞維', style: TextStyle(color: Colors.grey[700]),),
                  accountName: Text('部門：研發處', style: TextStyle(color: Colors.grey[700]),),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('static/images/backGround.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                ListTile(
                  title:Text('<1> 約裝狀態查詢')
                ),
                ListTile(
                  title:Text('<2> 新戶約裝')
                ),
                ListTile(
                  title:Text('<3> 加裝立案')
                ),
                Divider(),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: ListTile(
                      title: Text('現在時間', style: TextStyle(color: Colors.blue,),textAlign: TextAlign.right,),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: bodyView(),
          bottomNavigationBar: bottomBar()),
    );
  }
}
