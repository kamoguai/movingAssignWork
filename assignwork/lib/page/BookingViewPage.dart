
import 'package:assignwork/common/dao/BaseDao.dart';
import 'package:assignwork/common/redux/SysState.dart';
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/common/utils/NavigatorUtils.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:assignwork/widget/HomeDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
///
///新戶約裝頁面
///Date: 2019-12-12
class BookingViewPage extends StatefulWidget {

  static final String sName = 'booking';

  @override
  _BookingViewPageState createState() => _BookingViewPageState();
}

class _BookingViewPageState extends State<BookingViewPage> with BaseWidget{
  ScrollController _scrollController = new ScrollController();
  ///bottomNavigatorBar index
  int _bnbIndex = 0;
  ///記錄競業arr
  List<dynamic> industyArr = [];
  String industySelected = "";
  ///記錄有線產品下拉
  List<dynamic> dtvArr = [];
  String dtvSelected = "";
  ///記錄有線繳別下拉
  List<dynamic> dtvPayArr = [];
  String dtvPaySelected = "";
  ///記錄加購產品下拉
  List<dynamic> dtvAddProdArr = [];
  ///記錄分機數量下拉
  List<dynamic> slaveArr = [];
  String slaveSelected = "";
  ///記錄cm產品下拉
  List<dynamic> cmArr = [];
  String cmSelected = "";
  ///記錄cm繳別下拉
  List<dynamic> cmPayArr = [];
  String cmPaySelected = "";
  ///記錄跨樓層下拉
  List<dynamic> crossFloorArr = [];
  String crossFloorSelected = "";
  ///記錄網路線下拉
  List<dynamic> netCableArr = [];
  String netCableSelected = "";

  Store<SysState> _getStore() {
    return StoreProvider.of(context);
  }
  
  ///取得競業資料
  _getIndustryData() async {
    Map<String, dynamic> paramMap = new Map<String, dynamic>();
    paramMap["function"] = "getindustrywithwkno";
    paramMap["accNo"] = _getStore().state.userInfo?.accNo;
    paramMap["areaCode"] = "";
    var res = await BaseDao.getIndustryList(paramMap);
    if (res.result) {
      var data = res.data["industryList"];
      setState(() {
        this.industyArr = data["industryList"];
      });
    }
  }

  ///競業dialog
  



  ///Scaffold body
  Widget _bodyView() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          ///點擊跳出可輸入pop
          InkWell(
            onTap: () {
              Fluttertoast.showToast(msg: '顯示pop');
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                text: '姓名：',
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                                ),
                                TextSpan(
                                  text: '123',
                                  style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                text: '客編：',
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                                ),
                                TextSpan(
                                  text: '123',
                                  style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '電話：',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                        ),
                        TextSpan(
                          text: '123',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                        ),
                      ]
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '地址：',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                        ),
                        TextSpan(
                          text: '123',
                          style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          ///其他下拉選單
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                text: '大樓：',
                                style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                                ),
                                TextSpan(
                                  text: '123',
                                  style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)), 
                                ),
                              ]
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text('競業：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () async {
                                    _showSelectorController(context, dataList: this.industyArr, title: '競業', resultStr: this.industySelected, T: this.industySelected);
                                  },
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Colors.green[50]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('有線：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('繳別：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Colors.green[50]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('加購：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('分機：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Colors.cyan[50]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('CM：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('繳別：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text('跨樓層：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text('網路線：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                // flex: 2,
                                child: Text('備註：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                // flex: 3,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text('裝機：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text('發展人：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text('有線\n業贈：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text('寬頻\n業贈：', style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context)),),
                              ),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text('請選擇▿', style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context)),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          ButtonTheme(
            height: titleHeight(context) * 1.3,
            minWidth: MediaQuery.of(context).size.width / 2,
            // buttonColor: Colors.blue,
            child: FlatButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('試算', style: TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),),
              onPressed: () async {

              },
            ),
          ),
                    
          ///todo: 試算結果
          
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid), top: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                   decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child:  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '有線：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '寬頻：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                   decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child:  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '加購：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '押金：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                   decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child:  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '裝機費：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '跨樓層：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid)), color: Color(MyColors.hexFromStr('fff5fa'))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                   decoration: BoxDecoration(border: Border(right: BorderSide(width: 1.0, color: Colors.grey, style: BorderStyle.solid))),
                    child:  RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '網路線：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.yellow[100],
                    padding: EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '合計：',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '0000',
                            style: TextStyle(color: Colors.blue, fontSize: MyScreen.homePageFontSize(context))
                          ),
                          TextSpan(
                            text: '元',
                            style: TextStyle(color: Colors.black, fontSize: MyScreen.homePageFontSize(context))
                          )
                        ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            alignment: Alignment.center,
            child: Text('送出後不能更改，請確認資料完整性。', style: TextStyle(color: Colors.red, fontSize: MyScreen.defaultTableCellFontSize(context)),),
          ),
          SizedBox(height: 10,),
          ButtonTheme(
            height: titleHeight(context) * 1.3,
            minWidth: MediaQuery.of(context).size.width / 2,
            // buttonColor: Colors.blue,
            child: FlatButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('試算', style: TextStyle(color: Colors.white, fontSize: MyScreen.homePageFontSize(context)),),
              onPressed: () async {

              },
            ),
          ),
        ],
      ),
    );
  }
  ///Scaffold bottomBar
  Widget _bottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: autoTextSize('首頁', TextStyle(color: Colors.white), context)
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.search),
        //   title: autoTextSize('查詢', TextStyle(color: Colors.white), context)
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          title: autoTextSize('登出', TextStyle(color: Colors.white), context)
        ),
      ],
      backgroundColor: Color(MyColors.hexFromStr('#f4bf5f')),
      currentIndex: _bnbIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      onTap: _bottomNavBarAction,
    );
  }

  ///bottomNavigationBar action
  void _bottomNavBarAction(int index) {
    
    setState(() {
      _bnbIndex = index;
      if(mounted) {
        switch (index) {
          case 0:

          break;
          case 1:
            NavigatorUtils.goLogin(context);
          break;
          case 2:
            NavigatorUtils.goLogin(context);
          break;
        }
      }
    });
  }




  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text('新戶約裝', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
      ),
      body: _bodyView(),
      bottomNavigationBar: _bottomNavBar()
    );
  }







  ///下拉選擇器
  _showSelectorController(BuildContext context, { List<dynamic> dataList, String title, String valName, String resultStr, T}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          title: Text('選擇$title', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消', style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: resultStr != null ?  _selectorActions(dataList: dataList, valName: valName, resultStr: resultStr) : _selectorActions(dataList: dataList, valName: valName, T: T)
        );
        return dialog;
      }
    );
  }

  ///選擇器Actions
  List<Widget> _selectorActions({List<dynamic> dataList, String valName, String resultStr, T}) {
    List<Widget> wList = [];
    if (dataList != null && dataList.length > 0) {
      for (var dic in dataList) {
        wList.add(
          CupertinoActionSheetAction(
            child: Text(dic[valName], style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              setState(() {
                if (resultStr != null) {
                  resultStr = dic[valName];
                  T = resultStr;
                }
                Navigator.pop(context);
              });
            },
          )
        );
      }
    }
    else {
      for (var dic in dataList) {
        wList.add(
          CupertinoActionSheetAction(
            child: Text(dic, style: TextStyle(fontSize: MyScreen.homePageFontSize(context)),),
            onPressed: () {
              setState(() {
                if (resultStr != null) {
                  resultStr = dic;
                }
                Navigator.pop(context);
              });
            },
          )
        );
      }
    }
    return wList;
  }
}