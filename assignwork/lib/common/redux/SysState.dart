import 'package:assignwork/common/model/UserInfo.dart';
import 'package:flutter/material.dart';
import 'package:assignwork/common/redux/UserInfoRedux.dart';
import 'package:assignwork/common/redux/ThemeRedux.dart';
///
///Redux全局State
///Date: 2019-06-04
///
class SysState {
  ///用戶信息
  UserInfo userInfo;

  ///主題數據
  ThemeData themeData;

  ///個人案件列表
  // List<MaintTableCell> maintList = new List();

  ///構造方法
  SysState({this.userInfo, this.themeData});

}
///創建 Reducer
///源碼中Reducer 是一個方法 typedef state Reducer<State>(State state, dynamic action);
///這裡自定義appReducer 用於創建store
SysState appReducer(SysState state, action) {
  return SysState(
    ///通過 UserReducdr 將 SysState 內的 userInfo 和 action 關聯在一起
    userInfo: UserInfoReducer(state.userInfo, action),

    ///通過 ThemeDataReducer 將 SysState 內的 themeData 和 action 關聯在一起
    themeData: ThemeDataReducer(state.themeData, action),
  );
}