import 'dart:ffi';

import 'package:assignwork/common/model/BookingStatusTableCell.dart';
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
                          child: autoTextSize(model.customerWorkOrderInfos.name, TextStyle(color: Colors.grey[700]), context),
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
                          child: autoTextSize(model.customerWorkOrderInfos.code, TextStyle(color: Colors.grey[700]), context)
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
  CustomerWorkOrderInfos customerWorkOrderInfos;
  BookingItemModel();

  BookingItemModel.forMap(BookingStatusTableCell data) {
    customerWorkOrderInfos.bookingDate = data.customerWorkOrderInfos.bookingDate == null ? "" : data.customerWorkOrderInfos.bookingDate;
    customerWorkOrderInfos.building = data.customerWorkOrderInfos.building == null ? "" : data.customerWorkOrderInfos.building;
    customerWorkOrderInfos.code = data.customerWorkOrderInfos.code == null ? "" : data.customerWorkOrderInfos.code;
    customerWorkOrderInfos.constructName = data.customerWorkOrderInfos.constructName == null ? "" : data.customerWorkOrderInfos.constructName;
    customerWorkOrderInfos.description = data.customerWorkOrderInfos.description == null ? "" : data.customerWorkOrderInfos.description;
    customerWorkOrderInfos.installAddress = data.customerWorkOrderInfos.installAddress == null ? "" : data.customerWorkOrderInfos.installAddress;
    customerWorkOrderInfos.mobile = data.customerWorkOrderInfos.mobile == null ? "" : data.customerWorkOrderInfos.mobile;
    customerWorkOrderInfos.name = data.customerWorkOrderInfos.name == null ? "" : data.customerWorkOrderInfos.name;
    customerWorkOrderInfos.openTime = data.customerWorkOrderInfos.openTime == null ? "" : data.customerWorkOrderInfos.openTime;
    customerWorkOrderInfos.orderTypeCode = data.customerWorkOrderInfos.orderTypeCode == null ? "" : data.customerWorkOrderInfos.orderTypeCode;
    customerWorkOrderInfos.orderTypeName = data.customerWorkOrderInfos.orderTypeName == null ? "" : data.customerWorkOrderInfos.orderTypeName;
    customerWorkOrderInfos.slaveInfo = data.customerWorkOrderInfos.slaveInfo == null ? "" : data.customerWorkOrderInfos.slaveInfo;
    customerWorkOrderInfos.telephone = data.customerWorkOrderInfos.telephone == null ? "" : data.customerWorkOrderInfos.telephone;
    customerWorkOrderInfos.workorderCode = data.customerWorkOrderInfos.workorderCode == null ? "" : data.customerWorkOrderInfos.workorderCode;
    customerWorkOrderInfos.cancleInfo.operateTime = data.customerWorkOrderInfos.cancleInfo.operateTime == null ? "" : data.customerWorkOrderInfos.cancleInfo.operateTime;
    customerWorkOrderInfos.cancleInfo.operators = data.customerWorkOrderInfos.cancleInfo.operators == null ? "" : data.customerWorkOrderInfos.cancleInfo.operators;
    customerWorkOrderInfos.cancleInfo.reason = data.customerWorkOrderInfos.cancleInfo.reason == null ? "" : data.customerWorkOrderInfos.cancleInfo.reason;
    customerWorkOrderInfos.purchaseInfo.allowanceMonth = data.customerWorkOrderInfos.purchaseInfo.allowanceMonth == null ? "" : data.customerWorkOrderInfos.purchaseInfo.allowanceMonth;
    customerWorkOrderInfos.purchaseInfo.cmCode = data.customerWorkOrderInfos.purchaseInfo.cmCode == null ? "" : data.customerWorkOrderInfos.purchaseInfo.cmCode;
    customerWorkOrderInfos.purchaseInfo.cmMonth = data.customerWorkOrderInfos.purchaseInfo.cmMonth == null ? "" : data.customerWorkOrderInfos.purchaseInfo.cmMonth;
    customerWorkOrderInfos.purchaseInfo.crossFloorNumber = data.customerWorkOrderInfos.purchaseInfo.crossFloorNumber == null ? "" : data.customerWorkOrderInfos.purchaseInfo.crossFloorNumber;
    customerWorkOrderInfos.purchaseInfo.dtvCode = data.customerWorkOrderInfos.purchaseInfo.dtvCode == null ? "" : data.customerWorkOrderInfos.purchaseInfo.dtvCode;
    customerWorkOrderInfos.purchaseInfo.dtvMonth = data.customerWorkOrderInfos.purchaseInfo.dtvMonth == null ? "" : data.customerWorkOrderInfos.purchaseInfo.dtvMonth;
    customerWorkOrderInfos.purchaseInfo.networkCableNumber = data.customerWorkOrderInfos.purchaseInfo.networkCableNumber == null ? "" : data.customerWorkOrderInfos.purchaseInfo.networkCableNumber;
    customerWorkOrderInfos.purchaseInfo.slaveNumber = data.customerWorkOrderInfos.purchaseInfo.slaveNumber == null ? "" : data.customerWorkOrderInfos.purchaseInfo.slaveNumber;
    customerWorkOrderInfos.purchaseInfo.sumMoney = data.customerWorkOrderInfos.purchaseInfo.sumMoney == null ? "" : data.customerWorkOrderInfos.purchaseInfo.sumMoney;
    customerWorkOrderInfos.purchaseInfo.additionalInfos.code = data.customerWorkOrderInfos.purchaseInfo.additionalInfos.code == null ? "" : data.customerWorkOrderInfos.purchaseInfo.additionalInfos.code;
    customerWorkOrderInfos.purchaseInfo.additionalInfos.month = data.customerWorkOrderInfos.purchaseInfo.additionalInfos.month == null ? "" : data.customerWorkOrderInfos.purchaseInfo.additionalInfos.month;
    
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
  String openTime;
  PurchaseInfo purchaseInfo;
  CancleInfo cancleInfo;
  CustomerWorkOrderInfos();
  
}
class CancleInfo {
  String operateTime;
  String operators;
  String reason;
  CancleInfo();

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
  AdditionalInfos additionalInfos;
  PurchaseInfo();
}
class AdditionalInfos {
  String code;
  String month;
  AdditionalInfos();
}