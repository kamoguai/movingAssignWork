import 'package:assignwork/bloc/bookingStatusType3_bloc.dart';
import 'package:assignwork/common/model/BookingStatusTableCell.dart' as prefix0;
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/MyNewPullLoadWidget.dart';
import 'package:assignwork/widget/item/BookingStatusItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
///
///未完工查詢tab頁
///Date: 2019-10-17
class BookingStatusType3Page extends StatefulWidget {

  @override
  BookingStatusType3PageState createState() => BookingStatusType3PageState();
}

class BookingStatusType3PageState extends State<BookingStatusType3Page> with AutomaticKeepAliveClientMixin<BookingStatusType3Page> {

  ///約裝查詢事件相關
  final BookingStatusType3Bloc bloc = new BookingStatusType3Bloc();

  ///滑動監聽
  final ScrollController scrollController = new ScrollController();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }

  ///下拉刷新數據
  Future<void> requestRefresh() async {
    Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap["accNo"] = _getStore().state.userInfo?.accNo;
    jsonMap["function"] = "queryCustomerWorkOrderInfos";
    jsonMap["type"] = "3";
    jsonMap["employeeCode"] = _getStore().state.userInfo?.accNo;
    return await bloc.requestRefresh(jsonMap);
  }

  ///上拉請求更多數據
  Future<void> requestLoadMore() async {
    Map<String, dynamic> jsonMap = new Map<String, dynamic>();
    jsonMap["accNo"] = _getStore().state.userInfo?.accNo;
    jsonMap["function"] = "queryCustomerWorkOrderInfos";
    jsonMap["type"] = "3";
    jsonMap["employeeCode"] = _getStore().state.userInfo?.accNo;
    return await bloc.requestLoadMore(jsonMap);
  }

  ///渲染item list
  _renderItem(prefix0.CustomerWorkOrderInfos c) {

    BookingItemModel model = BookingItemModel.forMap(c);
    return BookingStatusItem(model: model, bookingType: "3", accNo: _getStore().state.userInfo?.accNo, accName: _getStore().state.userInfo?.empName, deptId: _getStore().state.userInfo?.deptCD,);
  }
 
  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    if(mounted)
    ///請求更新
    if (bloc.getDataLength() == 0) {
      bloc.changeLoadMoreStatus(false);
      Map<String, dynamic> jsonMap = new Map<String, dynamic>();
      jsonMap["accNo"] = _getStore().state.userInfo?.accNo;
      jsonMap["function"] = "queryCustomerWorkOrderInfos";
      jsonMap["type"] = "3";
      jsonMap["employeeCode"] = _getStore().state.userInfo?.accNo;
      ///先讀數據
      bloc.requestRefresh(jsonMap, doNextFlag: false).then((_) {
        showRefreshLoading();
      });
    }
    else {
      bloc.changeLoadMoreStatus(true);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Color(MyColors.hexFromStr('#eef1f9')),
      child: MyPullLoadWidget(
        bloc.pullLoadWidgetControl,
        (BuildContext context, int index) => _renderItem(bloc.dataList[index]),
        requestRefresh,
        requestLoadMore,
        refreshKey: refreshIndicatorKey,
        scrollController: scrollController,
      )
    );
  }
  
}