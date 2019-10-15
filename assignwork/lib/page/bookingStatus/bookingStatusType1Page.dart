import 'package:assignwork/common/model/BookingStatusTableCell.dart';
import 'package:assignwork/widget/MyListState.dart';
import 'package:assignwork/widget/item/BookingStatusItem.dart';
import 'package:assignwork/widget/pull/nested/nested_refresh.dart';
import 'package:flutter/material.dart';

class BookingStatusType1Page extends StatefulWidget {
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
    BookingStatusTableCell bstc = pullLoadWidgetControl.dataList[index];
    BookingItemModel model = BookingItemModel.forMap(bstc);
    return BookingStatusItem();
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
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        color: Colors.yellow[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)

        ),
      ),
    );
  }

  
}