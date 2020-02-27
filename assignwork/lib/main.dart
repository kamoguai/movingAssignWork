import 'dart:async';

import 'package:assignwork/page/AddBookingViewPage.dart';
import 'package:assignwork/page/BookingViewPage.dart';
import 'package:assignwork/page/MaintainReportPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:assignwork/common/event/HttpErrorEvent.dart';
import 'package:assignwork/common/model/UserInfo.dart';
import 'package:assignwork/common/net/Code.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/CommonUtils.dart';
import 'package:assignwork/page/HomePage.dart';
import 'package:assignwork/page/LoginPage.dart';
import 'package:assignwork/page/WelcomPage.dart';
import 'package:redux/redux.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  ///創建Store，引用 SysState中的appReducer 實現 Reducer 方法
  ///initialState 初始化 State
  final store = Store<SysState>(
    appReducer,
    ///初始化數據
    initialState: SysState(
      userInfo: UserInfo.empty(),
      themeData: CommonUtils.getThemeData(MyColors.primarySwatch),
    )
  );

  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ///設定手機畫面固定直立上方
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return StoreProvider(
      store: store,
      child: StoreBuilder<SysState>(builder: (context, store) {
        return MaterialApp(
          theme: store.state.themeData,
          routes: {
            ///設定route path, app一開始先進入welcome頁
            WelcomePage.sName: (context) {
              return WelcomePage();
            },
            LoginPage.sName: (context) {//登入
              return MyHomePage(
                child: LoginPage(),
              );
            },
            HomePage.sName: (context) {//首頁
              return MyHomePage(
                child: HomePage(),
              );
            },
            BookingViewPage.sName: (context) {
              return MyHomePage(
                child: BookingViewPage(),
              );
            },
            AddBookingViewPage.sName: (context) {
              return MyHomePage(
                child: AddBookingViewPage(),
              );
            },
            MaintainReportPage.sName: (context) {
              return MyHomePage(
                child: MaintainReportPage(),
              );
            },
          },
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Widget child;
  MyHomePage({Key key, this.child}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  StreamSubscription stream;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, allowFontScaling: false);
    return StoreBuilder<SysState>(
      builder: (context, store) {
        return Localizations.override(
          context: context,
          child: widget.child,
        );
      }
    );
  }
  @override
  void initState() {
    super.initState();
    
    stream = Code.eventBus.on<HttpErrorEvent>().listen((event){
      errorHandleFunction(event.code, event.message);
    });
  }
  @override
  void dispose() {
    super.dispose();
    if(stream != null) {
      stream.cancel();
      stream = null;
    }
  }
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        CommonUtils.showToast(context, msg: '網路錯誤');
        break;
      case 401:
        CommonUtils.showToast(context, msg: '[401錯誤可能: 未授權 \\ 授權登入失敗 \\ 登入過期]');
        break;
      case 403:
        CommonUtils.showToast(context, msg: '403權限錯誤');
        break;
      case 404:
        CommonUtils.showToast(context, msg: '404錯誤');
        break;
      case Code.NETWORK_TIMEOUT:
        //超时
        CommonUtils.showToast(context, msg: '請求超時');
        break;
      default:
        if (message.toString().contains('Socket')) {
          CommonUtils.showToast(context, msg: '網路請求異常，請更換網路試試。' + " " + message);
        }
        else {
          CommonUtils.showToast(context, msg: '請求異常' + " " + message);
        }
        
        break;
    }
  }
}
