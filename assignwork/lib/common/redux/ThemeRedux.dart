import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/**
 * 事件Redux
 * Date: 2019-03-11
 */

///通過 flutter_redux 的 combineReducers, 實現 Reducer 方法
final ThemeDataReducer = combineReducers<ThemeData >([
  ///將 Action、處理 Action 的方法、State綁定
  TypedReducer<ThemeData, RefreshThemeDataAction>(_refresh),
]);

///定義處理 Action 行為的方法，返回新的State
ThemeData _refresh(ThemeData themeData, action) {
  themeData = action.themeData;
  return themeData;
}

///定義一個Action類別
///將該Action 在 Reducer 中處理該Action的方法綁定
class RefreshThemeDataAction {
  final ThemeData themeData;

  RefreshThemeDataAction(this.themeData);
}