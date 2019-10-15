import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';
///
///tab bar共用模組
///Date: 2019-10-15
///
class MyTabBarWidget extends StatefulWidget {

  final int type;

  final List<Widget> tabItems;

  final List<Widget> tabViews;

  final Widget appBarActions;

  final Color backgroundColor;

  final Color indicatorColor;

  final Widget title;

  final Widget floatingActionButton;

  final TarWidgetControl tarWidgetControl;

  final PageController topPageControl;

  final ValueChanged<int> onPageChanged;

  final Widget bottomNavBarChild;

  final Widget getBody;

  final Widget drawer;
  
  MyTabBarWidget({
    Key key,
    this.type,
    this.tabItems,
    this.tabViews,
    this.appBarActions,
    this.backgroundColor,
    this.indicatorColor,
    this.title,
    this.floatingActionButton,
    this.tarWidgetControl,
    this.topPageControl,
    this.onPageChanged,
    this.bottomNavBarChild,
    this.getBody,
    this.drawer
  }) : super(key: key);

  @override
  _MyTabBarWidgetState createState() => new _MyTabBarWidgetState(
    type,
    tabViews,
    appBarActions,
    indicatorColor,
    title,
    floatingActionButton,
    tarWidgetControl,
    topPageControl,
    onPageChanged,
    bottomNavBarChild,
    getBody,
    drawer,
  );
}

class _MyTabBarWidgetState extends State<MyTabBarWidget> with BaseWidget, SingleTickerProviderStateMixin{

  final int _type;

  final List<Widget> _tabViews;

  final Widget _appBarActions;

  final Color _indicatorColor;

  final Widget _title;

  final Widget _floatingActionButton;

  final TarWidgetControl _tarWidgetControl;

  final PageController _pageController;

  final ValueChanged<int> _onPageChanged;

  final Widget _bottomNavBarChild;

  final Widget _getBody;

  final Widget _drawer;

  _MyTabBarWidgetState(
    this._type,
    this._tabViews,
    this._appBarActions,
    this._indicatorColor,
    this._title,
    this._floatingActionButton,
    this._tarWidgetControl,
    this._pageController,
    this._onPageChanged,
    this._bottomNavBarChild,
    this._getBody,
    this._drawer,
  ) : super();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: widget.tabItems.length);
  }

  ///整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        elevation: 0,
        title: widget.title,
        bottom: TabBar(
          controller: _tabController,
          tabs: widget.tabItems,
          indicatorColor: _indicatorColor,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white
          ),
          labelColor: Colors.red,
          unselectedLabelColor: Colors.white,
          onTap: (index) {
            _onPageChanged?.call(index);
            _pageController.jumpTo(MediaQuery.of(context).size.width * index);
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _tabViews,
        onPageChanged: (index) {
          _tabController.animateTo(index);
          _onPageChanged?.call(index);
        },
      ),
      bottomNavigationBar: widget.bottomNavBarChild,
    );
  }
}

class TarWidgetControl {
  List<Widget> footerButton = [];
}