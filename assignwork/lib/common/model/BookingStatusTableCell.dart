import 'package:json_annotation/json_annotation.dart';

part 'BookingStatusTableCell.g.dart';

///
///約裝查詢model
///Date: 2019-10-15
///
@JsonSerializable()
class BookingStatusTableCell {
  ///記錄總行數
  int rowCount;
  CustomerWorkOrderInfos customerWorkOrderInfos;

  BookingStatusTableCell(
    this.rowCount,
    this.customerWorkOrderInfos
  );
  /// 反序列化, 因資料字首是大寫，所以要手動把小寫轉大寫
  factory BookingStatusTableCell.fromJson(Map<String, dynamic> json) => _$BookingStatusTableCellFromJson(json);
  /// 序列化
  Map<String, dynamic> toJson() => _$BookingStatusTableCellToJson(this);

  /// 命名構造函數
  BookingStatusTableCell.empty();
}

@JsonSerializable()
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

  CustomerWorkOrderInfos(
    this.bookingDate,
    this.building,
    this.code,
    this.description,
    this.installAddress,
    this.mobile,
    this.name,
    this.orderTypeCode,
    this.orderTypeName,
    this.slaveInfo,
    this.telephone,
    this.workorderCode,
    this.constructName,
    this.openTime,
    this.purchaseInfo,
    this.cancleInfo,
  );

  /// 反序列化, 因資料字首是大寫，所以要手動把小寫轉大寫
  factory CustomerWorkOrderInfos.fromJson(Map<String, dynamic> json) => _$CustomerWorkOrderInfosFromJson(json);
  /// 序列化
  Map<String, dynamic> toJson() => _$CustomerWorkOrderInfosToJson(this);

  /// 命名構造函數
  CustomerWorkOrderInfos.empty();
}
@JsonSerializable()
class CancleInfo {
  String operateTime;
  @JsonKey(name: "operator")
  String operators;
  String reason;

  CancleInfo(
    this.operateTime,
    this.operators,
    this.reason
  );

  /// 反序列化, 因資料字首是大寫，所以要手動把小寫轉大寫
  factory CancleInfo.fromJson(Map<String, dynamic> json) => _$CancleInfoFromJson(json);
  /// 序列化
  Map<String, dynamic> toJson() => _$CancleInfoToJson(this);

  /// 命名構造函數
  CancleInfo.empty();
}
@JsonSerializable()
class PurchaseInfo {
  int allowanceMonth;
  int cmMonth;
  String cmCode;
  String dtvCode;
  int dtvMonth;
  int crossFloorNumber;
  int networkCableNumber;
  int slaveNumber;
  int sumMoney;
  List<AdditionalInfos> additionalInfos;
  PurchaseInfo(
    this.allowanceMonth,
    this.cmMonth,
    this.cmCode,
    this.dtvCode,
    this.dtvMonth,
    this.crossFloorNumber,
    this.networkCableNumber,
    this.slaveNumber,
    this.sumMoney
  );

  /// 反序列化, 因資料字首是大寫，所以要手動把小寫轉大寫
  factory PurchaseInfo.fromJson(Map<String, dynamic> json) => _$PurchaseInfoFromJson(json);
  /// 序列化
  Map<String, dynamic> toJson() => _$PurchaseInfoToJson(this);

  /// 命名構造函數
  PurchaseInfo.empty();
}
@JsonSerializable()
class AdditionalInfos {
  String code;
  int month;
  AdditionalInfos(
    this.code,
    this.month
  );

  /// 反序列化, 因資料字首是大寫，所以要手動把小寫轉大寫
  factory AdditionalInfos.fromJson(Map<String, dynamic> json) => _$AdditionalInfosFromJson(json);
  /// 序列化
  Map<String, dynamic> toJson() => _$AdditionalInfosToJson(this);

  /// 命名構造函數
  AdditionalInfos.empty();
}