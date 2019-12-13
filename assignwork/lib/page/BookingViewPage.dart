
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/HomeDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
///新戶約裝頁面
///Date: 2019-12-12
class BookingViewPage extends StatefulWidget {

  static final String sName = 'booking';

  @override
  _BookingViewPageState createState() => _BookingViewPageState();
}

class _BookingViewPageState extends State<BookingViewPage> with BaseWidget{
  ScrollController _scrollController = new ScrollController();
  ///bottomNavigatorBar index
  int _bnbIndex = 0;
  ///記錄競業arr
  List<dynamic> industyArr = [];
  ///記錄有線產品下拉
  List<dynamic> dtvArr = [];
  ///記錄有線繳別下拉
  List<dynamic> dtvPayArr = [];
  ///記錄加購產品下拉
  List<dynamic> dtvAddProdArr = [];
  ///記錄分機數量下拉
  List<dynamic> slaveArr = [];
  ///記錄cm產品下拉
  List<dynamic> cmArr = [];
  ///記錄cm繳別下拉
  List<dynamic> cmPayArr = [];
  ///記錄跨樓層下拉
  List<dynamic> crossFloorArr = [];
  ///記錄網路線下拉
  List<dynamic> netCableArr = [];
  
  ///取得競業資料
  _getIndustryData() async {
    
  }

  ///競業dialog
  



  ///Scaffold body
  Widget _bodyView() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          ///點擊跳出可輸入pop
          InkWell(
            onTap: () {
              Fluttertoast.showToast(msg: '顯示pop');
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                text: '姓名：',
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                                ),
                                TextSpan(
                                  text: '123',
                                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                text: '客編：',
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                                ),
                                TextSpan(
                                  text: '123',
                                  style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '電話：',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                        ),
                        TextSpan(
                          text: '123',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                        ),
                      ]
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '地址：',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                        ),
                        TextSpan(
                          text: '123',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          ///其他下拉選單
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                              text: '大樓：',
                              style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                              ),
                              TextSpan(
                                text: '123',
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)), 
                              ),
                            ]
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text('競業: ', style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)),),
                            ),
                            Flexible(
                              flex: 2,
                              child: InkWell(
                                onTap: (){},
                                child: Text('▿', style: TextStyle(color: Colors.black, fontSize: MyScreen.normalPageFontSize(context)),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  ///Scaffold bottomBar
  Widget _bottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: autoTextSize('首頁', TextStyle(color: Colors.white), context)
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.search),
        //   title: autoTextSize('查詢', TextStyle(color: Colors.white), context)
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          title: autoTextSize('登出', TextStyle(color: Colors.white), context)
        ),
      ],
      backgroundColor: Color(MyColors.hexFromStr('#f4bf5f')),
      currentIndex: _bnbIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      onTap: _bottomNavBarAction,
    );
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
            NavigatorUtils.goLogin(context);
          break;
          case 2:
            NavigatorUtils.goLogin(context);
          break;
        }
      }
    });
  }




  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('新戶約裝', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
      ),
      body: _bodyView(),
      bottomNavigationBar: _bottomNavBar()
    );
  }
}