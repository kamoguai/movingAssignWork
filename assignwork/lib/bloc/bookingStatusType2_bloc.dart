
import 'package:assignwork/common/config/Config.dart';
import 'package:assignwork/common/dao/BookingStatusDao.dart';
import 'package:assignwork/widget/MyNewPullLoadWidget.dart';
import 'package:assignwork/common/model/BookingStatusTableCell.dart' as prefix0;
import 'package:fluttertoast/fluttertoast.dart';

///
///約裝bloc
///Date: 2019-10-17
class BookingStatusType2Bloc {
  final MyPullLoadWidgetControl pullLoadWidgetControl = new MyPullLoadWidgetControl();

  int _page = 1;

  requestRefresh(Map jsonMap, {doNextFlag = true}) async {
    List<prefix0.CustomerWorkOrderInfos> list = new List();
    pageReset();
    jsonMap["pageIndex"] = _page;
    jsonMap["pageSize"] = Config.PAGE_SIZE;
    var res = await BookingStatusDao.getQueryCustomerWorkOrderInfos(jsonMap);
    if(res.data == null || res.result == false) {
      Fluttertoast.showToast(msg: 'API數據返回異常');
      return null;
    }
    var custInfo = res.data["customerWorkOrderInfos"];
    for (var dic in custInfo) {
      list.add(prefix0.CustomerWorkOrderInfos.fromJson(dic));
    }
    changeLoadMoreStatus(getLoadMoreStatus(list));
    refreshData(list);
    if(doNextFlag) {
      await doNext(res);
    }
    return res;
  }

  requestLoadMore(Map jsonMap) async {
    List<prefix0.CustomerWorkOrderInfos> list = new List();
    pageUp();
    jsonMap["pageIndex"] = _page;
    jsonMap["pageSize"] = Config.PAGE_SIZE;
    var res = await BookingStatusDao.getQueryCustomerWorkOrderInfos(jsonMap);
     var custInfo = res.data["customerWorkOrderInfos"];
    for (var dic in custInfo) {
      list.add(prefix0.CustomerWorkOrderInfos.fromJson(dic));
    }
    changeLoadMoreStatus(getLoadMoreStatus(list));
    loadMoreData(list);
    return res;
  }


  pageReset() {
    _page = 1;
  }

  pageUp() {
    _page++;
  }

  getLoadMoreStatus(res) {
    return (res != null && res.length == Config.PAGE_SIZE);
  }

  doNext(res) async {
    if (res.next != null) {
      var resNext = await res.next();
      if (resNext != null && resNext.result) {
        changeLoadMoreStatus(getLoadMoreStatus(resNext));
        refreshData(resNext);
      }
    }
  }

  ///列表数据长度
  int getDataLength() {
    return pullLoadWidgetControl.dataList.length;
  }

  ///修改加载更多
  changeLoadMoreStatus(bool needLoadMore) {
    pullLoadWidgetControl.needLoadMore = needLoadMore;
  }

  ///是否需要头部
  changeNeedHeaderStatus(bool needHeader) {
    pullLoadWidgetControl.needHeader = needHeader;
  }

  ///刷新列表数据
  refreshData(res) {
    if (res != null) {
      pullLoadWidgetControl.dataList = res;
    }
  }

  ///加载更多数据
  loadMoreData(res) {
    if (res != null) {
      pullLoadWidgetControl.addList(res);
    }
  }

  ///清理数据
  clearData() {
    refreshData([]);
  }

  ///列表数据
  get dataList => pullLoadWidgetControl.dataList;

  void dispose() {
    pullLoadWidgetControl.dispose();
  }
}