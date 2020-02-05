import 'package:assignwork/common/style/MyStyle.dart';
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';

///
///可加裝客戶列表選擇器
///Date: 2020-01-31
class CustInoListDialog extends StatelessWidget with BaseWidget {

  ///前頁傳入dataList
  final List<dynamic> dataArray;
  ///callback function
  final Function callBackFunc;

  CustInoListDialog({this.dataArray, this.callBackFunc});

   ///widget list item
  Widget listItem(BuildContext context, int index) {
    Widget item;
    var dicIndex = dataArray[index];
    var dic = CustPurchasedInfosModel.forMap(dicIndex);
    item = InkWell(
      child: Container(
        alignment: Alignment.centerLeft,
        height: titleHeight(context) * 3,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.grey))),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '姓名：',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context))
                      ),
                      TextSpan(
                        text: dic.customerIofo.name,
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context))
                      )
                    ]
                  ),
                ),
              ),      
            ),
            Flexible(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.red))),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '地址：',
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context))
                      ),
                      TextSpan(
                        text: addressEncode(dic.customerIofo.installAddress),
                        style: TextStyle(color: Colors.black, fontSize: MyScreen.defaultTableCellFontSize(context))
                      )
                    ]
                  ),
                ),
              )
            )
          ],
        ),
      ),
      onTap: () {
        this.callBackFunc(dic);
        Navigator.pop(context);
      },
    );
    
    return item;
  }

  ///widget list view
  Widget listView() {
    Widget list;
    if (dataArray.length > 0) {
      list = Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: listItem,
          itemCount:  dataArray.length,
        ),
      );
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {

    Widget titleWidget;
    Widget btnAction;

    titleWidget = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.red)),color: Colors.amber[400], ),
      height: titleHeight(context),
      child: autoTextSize('有(${this.dataArray.length})筆相同結果，請選擇欲加裝客戶', TextStyle(color: Colors.black), context),
    );
    
    btnAction = Container(
      color: Colors.amber[400],
      height: titleHeight(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: deviceWidth2(context) ,
            child: FlatButton(
              textColor: Colors.red,
              child: autoTextSize('離開', TextStyle(color: Colors.red), context),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );

    return Column(
      children: <Widget>[
        titleWidget,
        listView(),
        btnAction
      ],
    );
  }
}

class CustPurchasedInfosModel {
  CustomerIofo customerIofo;
  PurchaseInfos purchaseInfos;
  CustPurchasedInfosModel();
  CustPurchasedInfosModel.forMap(data) {
    customerIofo = CustomerIofo.froMap(data["customerInfo"]);
    purchaseInfos = PurchaseInfos.forMap(data["purchaseInfos"]);
  }
}
class CustomerIofo {
  String code;
  String name;
  String customerLevel;
  String customerType;
  String telephone;
  String mobile;
  String installAddress;
  String building;
  CustomerIofo();
  CustomerIofo.froMap(data) {
    code = data["code"] == null ? "" : data["code"];
    name = data["name"] == null ? "" : data["name"];
    customerLevel = data["customerLevel"] == null ? "" : data["customerLevel"];
    customerType = data["customerType"] == null ? "" : data["customerType"];
    telephone = data["telephone"] == null ? "" : data["telephone"];
    mobile = data["mobile"] == null ? "" : data["mobile"];
    installAddress = data["installAddress"] == null ? "" : data["installAddress"];
    building = data["building"] == null ? "" : data["building"];
  }
}

class PurchaseInfos {
  String isPurchasedDtv;
  String isPurchasedCm;
  String installedSlaveNumber;
  PurchaseInfos();
  PurchaseInfos.forMap(data) {
    isPurchasedDtv = data["isPurchasedDtv"] == null ? "" : data["isPurchasedDtv"];
    isPurchasedCm = data["isPurchasedCm"] == null ? "" : data["isPurchasedCm"];
    installedSlaveNumber = data["installedSlaveNumber"] == null ? "" : '${data["installedSlaveNumber"]}';
  }
}

