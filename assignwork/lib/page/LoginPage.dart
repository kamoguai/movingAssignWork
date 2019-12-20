import 'package:flutter/material.dart';
import 'package:assignwork/common/local/LocalStorage.dart';
import 'package:assignwork/common/config/Config.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:assignwork/common/net/Address.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/MyInputWidget.dart';
import 'package:assignwork/common//utils/CommonUtils.dart';
import 'package:assignwork/widget/MyFlexButton.dart';
import 'package:assignwork/common/dao/UserInfoDao.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///
///登入頁面
///Date: 2019-03-11
///
class LoginPage extends StatefulWidget {
  static final String sName = "login";
  final bool isAutoLogin;
  LoginPage({this.isAutoLogin});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _account = "";
  var _password = "";
  var _fcmToken = "123abc";
  final TextEditingController accountController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();
  String _serverMode = "prod";

  _LoginPageState() : super();

  @override
  void initState() {
    super.initState();
    UserInfoDao.validNewVersion(context);
    initParams();
  }

  initParams() async {
   
    _account = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    _serverMode = await LocalStorage.get(Config.SERVERMODE);  
  
    accountController.value = new TextEditingValue(text: _account ?? "");
    pwController.value = new TextEditingValue(text: _password ?? "");
    
  }
  ///切換server site
  void _changeTaped() {
    setState(() {
      if (_serverMode == null || _serverMode == "prod") {
        Fluttertoast.showToast(msg: '切換成測試機');
        _serverMode = "test";
      }
      else {
        Fluttertoast.showToast(msg: '切換成正式機');
        _serverMode = "prod";
      }
      LocalStorage.save(Config.SERVERMODE, _serverMode);
    });
  }

  ///版號顯示
  Widget _buildAppVerNo() {
    double verFontSize = 16.0;
    return new AutoSizeText(
      '版號: ' + Address.verNo,
      style: TextStyle(fontSize: verFontSize),
      minFontSize: 1.0,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
  ///呼叫登入api
  callLoginApi(store) async {
    UserInfoDao.login(_account.trim(), _password.trim(), _fcmToken, context).then((res) {                                
      Navigator.pop(context);
      if (res != null && res.result) {                                 
        if (res.data.retCode == "14") {
            UserInfoDao.updateDummyApp(context, res.data.blankURL);
        }
        else if (res.data.retCode == "00"){
            CommonUtils.showLoadingDialog(context);
            Map<String, dynamic> jsonMap = {};
            jsonMap["ssoKey"] = res.data.ssoKey;
            jsonMap["accNo"] = _account;
            jsonMap["passWord"] = _password;
            jsonMap["sysName"] = "movingAssignment";
            UserInfoDao.getUserInfo(res.data.serverURL ,jsonMap, store).then((res) {
              Navigator.pop(context);
              if (res != null && res.result) {
                print('登入成功 res => ${res.data}');
                  new Future.delayed(const Duration(seconds: 1),() {
                    NavigatorUtils.goHome(context);
                    return true;
                  });
              }
            });
        }
        else {
          Fluttertoast.showToast(msg: res.data.retMSG);
        }                                     
      } else {
        print("holy 喵喵喵");
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return new StoreBuilder<SysState>(builder: (context, store) {
      return new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          //滿版的contrainer
          body: new Container(
            //背景色
            color: Color(MyColors.hexFromStr("#eeeeee")),
            child: new Center(
              //防止overFlow現象
              child: SafeArea(
                child: SingleChildScrollView(
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: 30.0, top: 0.0, right: 30.0, bottom: 0.0),
                        child: new Image(
                            image: new AssetImage('static/images/logo.png')),
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      GestureDetector(
                        child: new Text(
                          '派裝系統3.0',
                          style: TextStyle(
                            fontSize: MyScreen.loginTextFieldFontSize(context)
                          ),  
                        ),
                        onTap: () {
                          _changeTaped();
                          
                        },
                      ),
                      
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Card(
                        elevation: 5.0,
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        color: Colors.white70,
                        margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: new Padding(
                          padding: new EdgeInsets.only(left: 30.0, top: 40.0, right: 30.0, bottom: 0.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Padding(padding: new EdgeInsets.all(10.0)),
                              new MyInputWidget(
                                textStyle: TextStyle(fontSize: MyScreen.loginTextFieldFontSize(context)),
                                hintText: '請輸入帳號',
                                textTitle: '帳號',
                                onChanged: (String value) {
                                  _account = value;
                                },
                                controller: accountController,
                              ),
                              new Padding(padding: new EdgeInsets.all(10.0)),
                              new MyInputWidget(
                                textStyle: TextStyle(fontSize: MyScreen.loginTextFieldFontSize(context)),
                                hintText: '請輸入密碼',
                                textTitle: '密碼',
                                onChanged: (String value) {
                                  _password = value;
                                },
                                controller: pwController,
                              ),
                              new Padding(padding: new EdgeInsets.all(20.0)),
                              new MyFlexButton(
                                text: '登入',
                                color: Color(MyColors.hexFromStr("#358cb0")),
                                textColor: Color(MyColors.textWhite),
                                fontSize: MyScreen.loginTextFieldFontSize(context),
                                onPress: () {
                                  if (_account == null || _account.length == 0) {
                                    return;
                                  }
                                  if (_password == null ||
                                      _password.length == 0) {
                                    return;
                                  }
                                  CommonUtils.showLoadingDialog(context);
                                  callLoginApi(store);
                                },
                              ),
                              new Padding(padding: new EdgeInsets.all(10.0)),
                            ],
                          ),
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.all(10.0)),
                      new Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: new Column(
                          children: <Widget>[
                            ///使用auto_size_text元件
                            new AutoSizeText(
                              "Copyright © 2015 DigiDom Cable TV CO., Ltd. All Rights Reserved. 全國數位有線電視股份有限公司 版權所有",
                              style: TextStyle(fontSize: 20 ),
                              minFontSize: 1.0,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            new Padding(padding: new EdgeInsets.all(10.0)),
                            new Align(
                              alignment: Alignment.bottomRight,
                              child: _buildAppVerNo()
                            )
                          ],
                        ),
                      ),
                    ],
                )),
              ),
            ),
          ),
        ),
      );
    });
  }
}
