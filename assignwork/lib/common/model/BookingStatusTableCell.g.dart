// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookingStatusTableCell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingStatusTableCell _$BookingStatusTableCellFromJson(
    Map<String, dynamic> json) {
  return BookingStatusTableCell(
    json['rowCount'] as int,
    json['customerWorkOrderInfos'] == null
        ? null
        : CustomerWorkOrderInfos.fromJson(
            json['customerWorkOrderInfos'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BookingStatusTableCellToJson(
        BookingStatusTableCell instance) =>
    <String, dynamic>{
      'rowCount': instance.rowCount,
      'customerWorkOrderInfos': instance.customerWorkOrderInfos,
    };

CustomerWorkOrderInfos _$CustomerWorkOrderInfosFromJson(
    Map<String, dynamic> json) {
  return CustomerWorkOrderInfos(
    json['bookingDate'] as String,
    json['building'] as String,
    json['code'] as String,
    json['description'] as String,
    json['installAddress'] as String,
    json['mobile'] as String,
    json['name'] as String,
    json['orderTypeCode'] as String,
    json['orderTypeName'] as String,
    json['slaveInfo'] as String,
    json['telephone'] as String,
    json['workorderCode'] as String,
    json['constructName'] as String,
    json['openTime'] as String,
    json['purchaseInfo'] == null
        ? null
        : PurchaseInfo.fromJson(json['purchaseInfo'] as Map<String, dynamic>),
    json['cancleInfo'] == null
        ? null
        : CancleInfo.fromJson(json['cancleInfo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CustomerWorkOrderInfosToJson(
        CustomerWorkOrderInfos instance) =>
    <String, dynamic>{
      'bookingDate': instance.bookingDate,
      'building': instance.building,
      'code': instance.code,
      'description': instance.description,
      'installAddress': instance.installAddress,
      'mobile': instance.mobile,
      'name': instance.name,
      'orderTypeCode': instance.orderTypeCode,
      'orderTypeName': instance.orderTypeName,
      'slaveInfo': instance.slaveInfo,
      'telephone': instance.telephone,
      'workorderCode': instance.workorderCode,
      'constructName': instance.constructName,
      'openTime': instance.openTime,
      'purchaseInfo': instance.purchaseInfo,
      'cancleInfo': instance.cancleInfo,
    };

CancleInfo _$CancleInfoFromJson(Map<String, dynamic> json) {
  return CancleInfo(
    json['operateTime'] as String,
    json['operator'] as String,
    json['reason'] as String,
  );
}

Map<String, dynamic> _$CancleInfoToJson(CancleInfo instance) =>
    <String, dynamic>{
      'operateTime': instance.operateTime,
      'operator': instance.operators,
      'reason': instance.reason,
    };

PurchaseInfo _$PurchaseInfoFromJson(Map<String, dynamic> json) {
  return PurchaseInfo(
    json['allowanceMonth'] as int,
    json['cmMonth'] as int,
    json['cmCode'] as String,
    json['dtvCode'] as String,
    json['dtvMonth'] as int,
    json['crossFloorNumber'] as int,
    json['networkCableNumber'] as int,
    json['slaveNumber'] as int,
    json['sumMoney'] as int,
  )..additionalInfos = (json['additionalInfos'] as List)
      ?.map((e) => e == null
          ? null
          : AdditionalInfos.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

Map<String, dynamic> _$PurchaseInfoToJson(PurchaseInfo instance) =>
    <String, dynamic>{
      'allowanceMonth': instance.allowanceMonth,
      'cmMonth': instance.cmMonth,
      'cmCode': instance.cmCode,
      'dtvCode': instance.dtvCode,
      'dtvMonth': instance.dtvMonth,
      'crossFloorNumber': instance.crossFloorNumber,
      'networkCableNumber': instance.networkCableNumber,
      'slaveNumber': instance.slaveNumber,
      'sumMoney': instance.sumMoney,
      'additionalInfos': instance.additionalInfos,
    };

AdditionalInfos _$AdditionalInfosFromJson(Map<String, dynamic> json) {
  return AdditionalInfos(
    json['code'] as String,
    json['month'] as int,
  );
}

Map<String, dynamic> _$AdditionalInfosToJson(AdditionalInfos instance) =>
    <String, dynamic>{
      'code': instance.code,
      'month': instance.month,
    };
