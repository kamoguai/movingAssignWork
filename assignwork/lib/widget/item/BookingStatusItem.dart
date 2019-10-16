
import 'package:assignwork/common/model/BookingStatusTableCell.dart' as prefix0;
import 'package:assignwork/widget/BaseWidget.dart';
import 'package:flutter/material.dart';


///
///約裝狀態查詢item
///Date: 2019-10-14
///
class BookingStatusItem extends StatelessWidget with BaseWidget{
  ///api回傳資料
  final BookingItemModel model;
  ///使用者編號
  final String accNo;
  ///使用者名稱
  final String accName;
  ///部門編號
  final String deptId;
  ///api傳入資料，查詢類型
  final String bookingType;

  BookingStatusItem({this.accName, this.accNo, this.deptId, this.bookingType, this.model});

  
  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.maxFinite,
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: autoTextSize('姓名: ', TextStyle(color: Colors.black), context),
                        ),
                        Flexible(
                          flex: 2,
                          child: autoTextSize(model.name, TextStyle(color: Colors.grey[700]), context),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: autoTextSize('客編: ', TextStyle(color: Colors.black), context),
                        ),
                        Flexible(
                          flex: 2,
                          child: autoTextSize(model.code, TextStyle(color: Colors.grey[700]), context)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        color: Colors.white,
      ),
    );
  }
}

class BookingItemModel {
  int rowCount;
  String bookingDate;
  String building;
  String code;
  String description;
  String installAddress;
  String mobile;
  String name;
  String orderTypeCode;
  String orderTypeName;
  String slaveInfo;
  String telephone;
  String workorderCode;
  String constructName;
  // String openTime;
  PurchaseInfo purchaseInfo;
  CancleInfo cancleInfo;
  BookingItemModel();

  BookingItemModel.forMap(prefix0.CustomerWorkOrderInfos data) {
    bookingDate = data.bookingDate == null ? "" : data.bookingDate;
    building = data.building == null ? "" : data.building;
    code = data.code == null ? "" : data.code;
    constructName = data.constructName == null ? "" : data.constructName;
    description = data.description == null ? "" : data.description;
    installAddress = data.installAddress == null ? "" : data.installAddress;
    mobile = data.mobile == null ? "" : data.mobile;
    name = data.name == null ? "" : data.name;
    orderTypeCode = data.orderTypeCode == null ? "" : data.orderTypeCode;
    orderTypeName = data.orderTypeName == null ? "" : data.orderTypeName;
    slaveInfo = data.slaveInfo == null ? "" : data.slaveInfo;
    telephone = data.telephone == null ? "" : data.telephone;
    workorderCode = data.workorderCode == null ? "" : data.workorderCode;
    if (data.cancleInfo != null) {
      cancleInfo = CancleInfo.forMap(data.cancleInfo);
    }
    if (data.purchaseInfo != null) {
      purchaseInfo = PurchaseInfo.forMap(data.purchaseInfo);
    }
    if (data.purchaseInfo.additionalInfos != null) {

    }
  }
}

class CustomerWorkOrderInfos {
  String bookingDate;
  String building;
  String code;
  String description;
  String installAddress;
  String mobile;
  String name;
  String orderTypeCode;
  String orderTypeName;
  String slaveInfo;
  String telephone;
  String workorderCode;
  String constructName;
  PurchaseInfo purchaseInfo;
  CancleInfo cancleInfo;
  CustomerWorkOrderInfos(
    
  );
  
}
class CancleInfo {
  String operateTime;
  String operators;
  String reason;
  CancleInfo();
  CancleInfo.forMap(data) {
    operateTime = data.operateTime == null ? "" : data.operateTime;
    operators = data.operators == null ? "" : data.operators;
    reason = data.reason == null ? "" : data.reason;
  }
}
class PurchaseInfo {
  String allowanceMonth;
  String cmMonth;
  String cmCode;
  String dtvCode;
  String dtvMonth;
  String crossFloorNumber;
  String networkCableNumber;
  String slaveNumber;
  String sumMoney;
  List<AdditionalInfos> additionalInfos;
  PurchaseInfo();
  PurchaseInfo.forMap(data) {
    allowanceMonth = data.allowanceMonth == null ? "" : "${data.allowanceMonth}";
    cmMonth = data.cmMonth == null ? "" : "${data.cmMonth}";
    cmCode = data.cmCode == null ? "" : data.cmCode;
    dtvCode = data.dtvCode == null ? "" : data.dtvCode;
    dtvMonth = data.dtvMonth == null ? "" : "${data.dtvMonth}";
    crossFloorNumber = data.crossFloorNumber == null ? "" : "${data.crossFloorNumber}";
    networkCableNumber = data.networkCableNumber == null ? "" : "${data.networkCableNumber}";
    slaveNumber = data.slaveNumber == null ? "" : "${data.slaveNumber}";
    sumMoney = data.sumMoney == null ? "" : "${data.sumMoney}";
  }
}
class AdditionalInfos {
  String code;
  String month;
  AdditionalInfos();
  AdditionalInfos.forMap(data) {
    code = data.code == null ? "" : data.code;
    month = data.month == null ? "" : "${data.month}";
  }
}