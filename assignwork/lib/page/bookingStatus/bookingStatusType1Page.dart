import 'package:assignwork/common/dao/BookingStatusDao.dart';
import 'package:assignwork/common/model/BookingStatusTableCell.dart';
import 'package:assignwork/common/model/BookingStatusTableCell.dart' as prefix0;
import 'package:assignwork/page/HomePage.dart';
import 'package:assignwork/widget/MyListState.dart';
import 'package:assignwork/widget/MyPullLoadWidget.dart';
import 'package:assignwork/widget/item/BookingStatusItem.dart';
import 'package:assignwork/widget/pull/nested/MyNestedPullLoadWiget.dart';
import 'package:assignwork/widget/pull/nested/nested_refresh.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BookingStatusType1Page extends StatefulWidget {

  final String accNo;

  final String accName;

  final String deptId;

  BookingStatusType1Page({this.accName, this.accNo, this.deptId});

  @override
  BookingStatusType1PageState createState() => BookingStatusType1PageState();
}

class BookingStatusType1PageState extends State<BookingStatusType1Page> with AutomaticKeepAliveClientMixin<BookingStatusType1Page>, MyListState<BookingStatusType1Page>, TickerProviderStateMixin {

  ///滑動監聽
  final ScrollController scrollController = new ScrollController();
  ///當前顯示tab
  int selectIndex = 0;
  ///NestedScrollView 的刷新状态 GlobalKey ，方便主动刷新使用
  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshIKey = new GlobalKey<NestedScrollViewRefreshIndicatorState>();
  ///動畫控制器
  AnimationController animationController;

  @override
  showRefreshLoading() {
    return Future.delayed(const Duration(seconds: 0), () {
      refreshIKey.currentState.show().then((e){});
      return true;
    });
  }

  ///渲染item list
  _renderItem(index) {
    prefix0.CustomerWorkOrderInfos bstc = pullLoadWidgetControl.dataList[index];
    BookingItemModel model = BookingItemModel.forMap(bstc);
    return BookingStatusItem(model: model);
  }

  ///取得api資料
  _getApiData() async {
    Map<String, dynamic> params = {};
    params["accNo"] = widget.accNo;
    params["function"] = "queryCustomerWorkOrderInfos";
    params["type"] = "1";
    params["employeeCode"] = widget.accNo;
    params["pageIndex"] = "1";
    params["pageSize"] = "10";
    var res = await BookingStatusDao.getQueryCustomerWorkOrderInfos(params);
    if (res != null && res.result) {

    }
    
  }
 
  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() {
    return super.requestRefresh();
  }

  @override
  requestLoadMore() {
    return super.requestLoadMore();
  }
  
  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  void initState() {
    super.initState();
    _getApiData();
  }
  
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.white,
    // );
    super.build(context);
    return ScopedModelDescendant<StatusDetailModel>(
      builder: (context, child, model) {
        return MyPullLoadWidget(
          pullLoadWidgetControl,
          (BuildContext context, int index) => _renderItem(index),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshIKey,
          // scrollController: scrollController,
          // headerSliverBuilder: (context, _) {
          //   return _sliverBuilder(context, _);
          // },
        );
      },
    );
  }
  ///支持表頭動態調整位置，這裏沒用到，回空
  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[];
  }
}