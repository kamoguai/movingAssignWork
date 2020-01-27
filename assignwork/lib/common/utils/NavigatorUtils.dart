

import 'package:assignwork/page/BookingViewPage.dart';
import 'package:assignwork/page/MaintainReportPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assignwork/page/HomePage.dart';
import 'package:assignwork/page/LoginPage.dart';
///
///導航欄
///Date: 2019-10-04
///
class NavigatorUtils {
  ///替換
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切換無參數頁面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
  ///一般跳轉頁面
  static navigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(context, new CupertinoPageRoute(builder: (context) => widget));
  }
  ///跳轉至頁面並移除上一頁
  static navigatorRemoveRouter(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(context, new CupertinoPageRoute(builder: (context) => widget), null);
  }
  ///登入頁
  static goLogin(BuildContext context, {isAutoLogin}) {
    if (isAutoLogin != null  && isAutoLogin != false) {
      navigatorRouter(context, LoginPage(isAutoLogin: isAutoLogin));
    }
    else {
      Navigator.pushReplacementNamed(context, LoginPage.sName);
    }
  }
  ///跳回登入頁
  static goTopLogin(BuildContext context) {
    navigatorRemoveRouter(context, LoginPage());
  }
  ///首頁
  ///pushReplacementNamed需要由main.dart做導航
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }
  ///新戶約裝
  static goBookingView(BuildContext context) {
    Navigator.pushReplacementNamed(context, BookingViewPage.sName);
  }
  ///維護派單
  static goMaintainReportView(BuildContext context) {
    navigatorRouter(context, MaintainReportPage());
  }
  
  
}