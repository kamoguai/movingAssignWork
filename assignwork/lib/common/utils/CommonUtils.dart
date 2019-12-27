import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:assignwork/common/redux/ThemeRedux.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/MyFlexButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
///
///通用邏輯
///Date: 2019-03-11
///
class CommonUtils {
  static final double MILLIS_LIMIT = 1000.0;

  static final double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static final double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static final double HOURS_LIMIT = 24 * MILLIS_LIMIT;

  static final double DAYS_LIMIT = 30 * MILLIS_LIMIT;

  static double sStaticBarHeight = 0.0;

  static void initStatusBarHeight(context) async {
    sStaticBarHeight =await FlutterStatusbar.height / MediaQuery.of(context).devicePixelRatio;
  }

  static String getDateStr(DateTime date) {
    if (date == null || date.toString() == null) {
      return "";
    }
    else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0,10);
  }

  ///日期格式轉換
  static String getNewsTimeStr(DateTime date) {
    int subTime = DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (subTime < MILLIS_LIMIT) {
      return "剛剛";
    }
    else if (subTime < SECONDS_LIMIT) {
      return (subTime / MILLIS_LIMIT).round().toString() + " 秒前";
    }
    else if (subTime < MINUTES_LIMIT) {
      return (subTime / SECONDS_LIMIT).round().toString() + " 分鐘前";
    }
    else if (subTime < HOURS_LIMIT) {
      return (subTime / MINUTES_LIMIT).round().toString() + " 小時前";
    }
    else if (subTime < DAYS_LIMIT) {
      return (subTime / HOURS_LIMIT).round().toString() + " 天前";
    }
    else {
      return getDateStr(date);
    }
  }

  static getLocalPath() async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return null;
      }
    }
    String appDocPath = appDir.path + "/assignwork";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }

  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf("/"));
  }


  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = getThemeData(colors[index]);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }

  static getThemeData(Color color) {
    return ThemeData(primarySwatch: color, platform: TargetPlatform.android);
  }

  static List<Color> getThemeListColor() {
    return [
      // Colors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  static launchOutURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: 'url異常' + ": " + url);
    }
  }

  ///loading用
  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(child: SpinKitCubeGrid(color: Color(MyColors.white))),
                        new Container(height: 10.0),
                        new Container(child: new Text('資料讀取中..', style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(20.0)))),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  static onLoading(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(child: SpinKitCubeGrid(color: Color(MyColors.white))),
                        new Container(height: 10.0),
                        new Container(child: new Text('資料讀取中..', style: TextStyle(fontSize: ScreenUtil().setSp(20.0)))),
                      ],
                    ),
                  ),
                ),
              ));
    });
    // new Future.delayed(new Duration(seconds: 3), () {
    //   Navigator.pop(context);
    // });
  }

  ///包含輸入可submit的alert
  static Future<Null> showCommitOptionDialog(
    BuildContext context,
    List<String> commitMaps,
    ValueChanged<int> onTap, {
    width = 250.0,
    height = 400.0,
    List<Color> colorList,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new Container(
              width: width,
              height: height,
              padding: new EdgeInsets.all(4.0),
              margin: new EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                color: Color(MyColors.white),
                //用一个BoxDecoration装饰器提供背景图片
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: new ListView.builder(
                  itemCount: commitMaps.length,
                  itemBuilder: (context, index) {
                    return MyFlexButton(
                      maxLines: 2,
                      mainAxisAlignment: MainAxisAlignment.start,
                      fontSize: 14.0,
                      color: colorList != null ? colorList[index] : Theme.of(context).primaryColor,
                      text: commitMaps[index],
                      textColor: Color(MyColors.white),
                      onPress: () {
                        Navigator.pop(context);
                        onTap(index);
                      },
                    );
                  }),
            ),
          );
        });
  }

  ///版本更新
  static Future<Null> showUpdateAppDialog(BuildContext context, String contentMsg, String updateUrl) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('版本更新', style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
            content: new Text(contentMsg, style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    launch(updateUrl);
                    Navigator.pop(context);
                  },
                  child: new Text('確定', style: TextStyle(fontSize: ScreenUtil().setSp(20)),)),
            ],
          );
        }
    );
  }

  ///更新為不能使的app
  static Future<Null> showDummuAppDialog(BuildContext context, String contentMsg, String updateUrl) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('版本更新', style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
            content: new Text(contentMsg),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text('取消', style: TextStyle(fontSize: ScreenUtil().setSp(20)),)),
              new FlatButton(
                  onPressed: () {
                    launch(updateUrl);
                    Navigator.pop(context);
                  },
                  child: new Text('確定', style: TextStyle(fontSize: ScreenUtil().setSp(20)),)),
            ],
          );
        }
    );
  }

  ///一般需要點取消的alert
  static Future<Null> showMessageDialog(BuildContext context, String titleStr, String contentStr) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(titleStr, style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
          content: new Text(contentStr),
          actions: <Widget>[
            CupertinoButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('確定', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(20)),),
            ),
          ],
        );
      }
    );
  }

  ///confirm功能
  static Future<Null> showConfirmDialog(BuildContext context, String titleStr, String contentStr) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(titleStr, style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
          content: new Text(contentStr),
          actions: <Widget>[
            CupertinoButton(
                onPressed: (){
                  Fluttertoast.showToast(msg: contentStr);
                },
                child: Text('確定', style: TextStyle(color: Colors.blue, fontSize: ScreenUtil().setSp(20)),),
            ),
            CupertinoButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('取消', style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(20)),),
            ),
          ],
        );
      }
    );
  }

  ///空页面
  static buildEmpty() {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {},
            child: new Image(image: new AssetImage(MyICons.DEFAULT_USER_ICON), width: 70.0, height: 70.0),
          ),
          Container(
            child: Text('目前沒有資料', style: TextStyle(fontSize: ScreenUtil().setSp(20))),
          ),
        ],
      ),
    );
  }
  

  ///snr設定檔決定顏色
  static checkSnrConfigureValueColor(String data, String name, String netType, dynamic configData) {
    if (data == "" || data == "---") {
      return MyColors.hexFromStr("#000000");
    }
    final dic = configData;
    // dp最小
    final strDOWNDBMIN =  dic["DSDB_MIN"];
    // dp最大
    final strDOWNDBMAX = dic["DSDB_MAX"];
    
    final strUSSNRMIN = dic["USSNR_MIN"];
    // ds
    final strDSSNRMIN = dic["DSSNR_MIN"];
    // 外網 snr,pwr
    final strUPDBMAX_EXT = dic["USDB_MAX_EXT"];
    // 內網 snr,pwr
    final strUPDBMAX_INT = dic["USDB_MAX_INT"];
    // 上snr
    if (name == "US0" || name == "US1" || name == "US2" || name == "US3" || name == "SNR_U0" || name == "SNR_U1" || name == "SNR_U2" || name == "SNR_U3" || name == "U0_SNR" || name == "U1_SNR" || name == "U2_SNR" || name == "U3_SNR") {
      if (double.parse(data) == null) {
        return MyColors.hexFromStr("#FF0000");
      }
      else if (double.parse(data) < 1) {
        return MyColors.hexFromStr("#0000FF");
      }
      else {
        return (double.parse(data) >= double.parse(strUSSNRMIN) ? MyColors.hexFromStr("#0000FF") : MyColors.hexFromStr("#FF0000"));
      }
    }
    // 下pwr
    if (name == "UP0" || name == "UP1" || name == "UP2" || name == "UP3" || name == "POW_U0" || name == "POW_U1" || name == "POW_U2" || name == "POW_U3" || name == "U0_PWR" || name == "U1_PWR" || name == "U2_PWR" || name == "U3_PWR" ) {
      if (double.parse(data) == null) {
        return MyColors.hexFromStr("#FF0000");
      }
      else if (double.parse(data) < 1) {
        return MyColors.hexFromStr("#0000FF");
      }
      if (netType == "EXT") {
        return (double.parse(data) >= double.parse(strUPDBMAX_EXT) ? MyColors.hexFromStr("#FF0000") : MyColors.hexFromStr("#0000FF"));
      }
      else {
        return (double.parse(data) >= double.parse(strUPDBMAX_INT) ? MyColors.hexFromStr("#FF0000") : MyColors.hexFromStr("#0000FF"));
      }
    }
    // 下pwr
    if (name == "U0_PWR_PING" || name == "U1_PWR_PING" || name == "U2_PWR_PING" || name == "U3_PWR_PING" ) {
      if (double.parse(data) == null) {
        return MyColors.hexFromStr("#FF0000");
      }
      else {
        if (netType == "EXT") {
          return (double.parse(data) >= double.parse(strUPDBMAX_EXT) ? MyColors.hexFromStr("#FF0000") : MyColors.hexFromStr("#0000FF"));
        }
        else {
          return (double.parse(data) >= double.parse(strUPDBMAX_INT) ? MyColors.hexFromStr("#FF0000") : MyColors.hexFromStr("#0000FF"));
        }
      }
    }
    // ping ds
    if(name == "DSMER_PING" || name == "DS0_PING" || name == "DS1_PING" || name == "DS2_PING" || name == "DS3_PING" || name == "DS4_PING" || name == "DS5_PING" || name == "DS6_PING" || name == "DS7_PING" ) {
      if (double.parse(data) == null) {
        return MyColors.hexFromStr("#FF0000");
      }
       if (netType == "EXT") {
          return (double.parse(data) >= double.parse(strUPDBMAX_EXT) ? MyColors.hexFromStr("#FF0000") : MyColors.hexFromStr("#0000FF"));
       }
       else {
          return (double.parse(data) >= double.parse(strUPDBMAX_INT) ? MyColors.hexFromStr("#FF0000") : MyColors.hexFromStr("#0000FF"));
       }
    }
    // ping dp
    if(name == "DSDB_PING" || name == "DP0_PING" || name == "DP1_PING" || name == "DP2_PING" || name == "DP3_PING" || name == "DP4_PING" || name == "DP5_PING" || name == "DP6_PING" || name == "DP7_PING" ) {
      if (double.parse(data) == null) {
        return MyColors.hexFromStr("#FF0000");
      }
      else {
        return (double.parse(data) >= double.parse(strDOWNDBMIN) && double.parse(data) <= double.parse(strDOWNDBMAX) ? MyColors.hexFromStr("#000000") : MyColors.hexFromStr("#FF0000"));
      }
    }
    // 上DS
    if (name == "DS0" || name == "DS1" || name == "DS2" || name == "DS3" || name == "DS4" || name == "DS5" || name == "DS6" || name == "DS7" ) {
      if (double.parse(data) == null) {
        return MyColors.hexFromStr("#FD5AD5");
      }
      else {
        return (double.parse(data) >= double.parse(strDSSNRMIN)) ? MyColors.hexFromStr('#5F605E') : MyColors.hexFromStr('#FD5AD5');
      }
    }
    // 下DP
    if (name == "DP0" || name == "DP1" || name == "DP2" || name == "DP3" || name == "DP4" || name == "DP5" || name == "DP6" || name == "DP7" ) {
      if (double.parse(data) == null) {
        return MyColors.hexFromStr("#5F605E");
      }
      else {
        return (double.parse(data) >= double.parse(strDOWNDBMIN)) && (double.parse(data) <= double.parse(strDOWNDBMAX)) ? MyColors.hexFromStr('#5F605E') : MyColors.hexFromStr('#FD5AD5');
      }
    }
    return MyColors.hexFromStr("#000000");
  }

  static filterMonthCN(String str) {
    switch (str) {
      case "0":
          return "----";
      case "1":
          return "月繳";
      case "3":
          return "季繳";
      case "6":
          return "半年繳";
      case "12":
          return "年繳";
      default:
          return str;
    }
  }
  
  static filterMonthCN2(String str) {
    switch (str) {
      case "0":
          return "";
      case "1":
          return "月繳";
      case "3":
          return "季繳";
      case "6":
          return "半年繳";
      case "12":
          return "年繳";
      default:
          return str;
    }
  }

  static filterMonthNm(String str) {
    switch (str) {
      case "----":
      case "":
          return "0";
      case "月繳":
          return "1";
      case "季繳":
          return "3";
      case "半年繳":
          return "6";
      case "年繳":
          return "12";
      default:
          return str;
    }
  }

  static filterAreaCN(String str) {

    switch (str) {

      case "板橋區":
        return "220/ROOT";
      case "蘆洲區":
        return "247/ROOT";
      case "新莊區":
        return "242/ROOT";
      case "土城區":
        return "236/ROOT";
      case "三重區":
        return "241/ROOT";
      default:
        return str;
    }
  }
}