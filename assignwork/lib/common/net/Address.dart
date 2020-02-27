import 'dart:io';
import 'package:flutter/services.dart';
///地址數據
class Address {
  static const String ssoDomain = "http://nsso.dctv.net.tw:8081/";
  static const String aesDomain = "http://asg.dctv.net.tw:8082/EncEDI/interfaceAES?data=";
  static const String ssoDomainName = "http://wos.dctv.net.tw:8081/";
  static const String kCMHostPath = "http://msg.dctv.net.tw/api/Q2/?";
  static const String kDHostPath = "http://msg.dctv.net.tw/api/OnDuty/?";
  static const String kAreaHostPath = "http://msg.dctv.net.tw/api/AreaBugData?";
  static const String kSNRHostName = "http://snr.dctv.tw:25888/";
  static const String kSNRHostPingName = "http://snr.dctv.tw:8989/";
  static const String getSsoKey = "SSO/json/login.do?";
  static const String getVersion = "ValidataVersion/json/index!checkVersion.action?";
  static const String bundleID = "com.dctv.assignwork";
  static const String sysName = "assignwork";
  static const String packageName = "com.dctv.assignwork";
  static String workInstallDomainName = "http://wos.dctv.net.tw:8083/WorkInstall/";
  static String domainNameAES = "http://wos.dctv.net.tw:8083/WorkInstall/interfaceJsonAES";
  ///是否進入測試機
  static bool isEnterTest = false;
  
  ///app版本設在這裡
  static final String verNo = "3.20.0210";


  ///檢查是否有更新app
  static getValidateVersionAPI() {
    String deviceType = "";
    try {
      if (Platform.isAndroid) {
        deviceType = "android";
      }
      else if (Platform.isIOS) {
        deviceType = 'ios';
      }
    } on PlatformException {
      
    }
    return "$ssoDomainName/${getVersion}packageName=$bundleID&type=$deviceType&verNo=$verNo";
  }

  ///登入SSO
  static ssoLoginAPI(account, password, serialID) {
    String deviceType = "";
    try {
      if (Platform.isAndroid) {
        deviceType = "android";
      }
      else if (Platform.isIOS) {
        deviceType = 'ios';
      }
    } on PlatformException {
      
    }
    return "$ssoDomain${getSsoKey}function=login&accNo=$account&passWord=$password&uniqueCode=$serialID&sysName=$sysName&tokenType=$deviceType&tokenID=slg;ksl;dc123&packageName=$packageName&type=$deviceType";
  }
  ///登入取得使用者資訊
  ///
  ///param: sysName, accNo, passWord, ssoKey
  static getSystemUserData(String serverUrl) {
    return "$serverUrl?";
  }

  //<-------------------- 派裝相關 api workInstall -------------------->
  
  ///查詢子管理區域
  ///
  ///param: accNo, function, currentManageSectionCode
  static queryManageSection() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///查詢派單信息
  ///
  ///params: accNo, function, type, employeeCode, pageIndex, pageSize
  static queryCustomerWorkOrderInfos() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///查詢套餐訊息
  ///
  ///param: function, accNo, areaCode
  static queryProductInfo() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///查詢開戶基本信息
  ///
  ///param: function, accNo, 
  static queryOpenBaseInfo(){
    changeEnterTest();
    return "$domainNameAES";
  }
  
  ///查詢班次 - 初裝, 改約, 加裝
  ///
  ///初裝 param: function, accNo, bookingDate
  ///
  ///改約 param: function, accNo, bookingDate, manageSectionCode, businessType, workorderCode
  ///
  ///加裝 param: function, accNo, bookingDate, manageSectionCode, businessType, purchageProductionInfo
  static queryBookService() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///試算 - 初裝, 加裝
  ///
  ///初裝 param: function, accNo, trialType, manageSectionCode, bookingDate, dtvCode, dtvMonth, cmCode, cmMonth, allowanceMonth, slaveNumber, crossFloorNumber, networkCableNunber, additionalInfo, marketingPlanCode
  ///
  ///加裝 param: function, accNo, trialType, manageSectionCode, bookingDate, dtvCode, dtvMonth, cmCode, cmMonth, allowanceMonth, slaveNumber, crossFloorNumber, networkCableNunber, additionalInfo, marketingPlanCode, customerCode,, isAlign, additionalInfos
  static postTrial() {
    changeEnterTest();
    return "$domainNameAES";
  }
  
  ///立案
  ///
  ///param: function, accNo, 
  ///customerInfo{name, moibile, telphone, gender, customerType, partyIdentification, installAddress, postAddress},
  ///purchaseInfo{dctvCode, dvtvMonth, cmdCode, cmMonth, additionalInfos, allowanceMonth, slaveNumber, crossFloorNumber, sumMoney, networkCableNumber},
  ///oderInfo{bookingDate, saleManCode, operator, description},
  ///giftInfo{classification, type, month},
  static openPurchase() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///加裝
  ///
  ///param: function, accNo,
  ///purchaseProductInfo{dctvCode, dctvMonth, cmCode, cmMonth, isAlign, slaveNumber, crossFloorNumber, sumMoney},
  ///orderInfo{bookingDate, saleManCode, operator, description}
  ///addPurchaseData{purchaseProductInfo, orderInfo, customerCode}
  ///addPurchaseInfo{addPurchaseData}
  ///giftsInfo{classification, type, month}
  static addPurchase() {
    changeEnterTest();
    return "$domainNameAES";
  }
  
  ///查詢可加裝客戶訊息, type=4,installAddress必填
  ///para: function, accNo, type, value
  ///installAddress{parentManageSectoinCode, community, lane, unit, ofUnit, floor, floorOf, description}
  static queryAddPurchaseCustomerInfos(){
    changeEnterTest();
    return "$domainNameAES";
  }

  ///匹配地址
  ///param: function, accNo,
  ///installAddress{parentManageSectoinCode, community, lane, unit, ofUnit, floor, floorOf, description}
  ///postAddress{parentManageSectoinCode, community, lane, unit, ofUnit, floor, floorOf, description}
  static matchAddress(){
    changeEnterTest();
    return "$domainNameAES";
  }

  ///取得全部前廠商列表
  ///param: function, accNo, areaCode, 
  static getIndustryList() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///改約
  ///param: function, accNo, operator, workorderCode, bookingDate, changeBookReason
  static modifyBookingData(){
    changeEnterTest();
    return "$domainNameAES";
  }

  ///撤銷
  ///param: function, accNo, operator, workorderCode, description, reasonCode
  static cancelWoroOrder() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///取得撤銷基本信息
  ///param: function, accNo, 
  static getQueryCancelBaseInfo(){
    changeEnterTest();
    return "$domainNameAES";
  }

  ///立案基本下拉選單
  ///param: function, accNo
  static getBaseListInfo() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///save競業
  ///param: function, accNo, wkNo, Industry
  static postInsertindustry() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///查詢工單競業
  ///param: function, accNo, wkNo,
  static getIndustryWithWkno() {
    changeEnterTest();
    return "$domainNameAES";
  }

  ///查詢人員列表
  ///param: function, accNo, deptCD
  static getQueryemplyeeList(){
    changeEnterTest();
    return "$domainNameAES";
  }

  ///取得通路業績
  ///param: dataDate, areaCode, accNo
  static getInstChannelWKEMP() {
    changeEnterTest();
    return "$workInstallDomainName" + "getChannelWKEMP?";
  }

  ///取得通路部門個人業績
  ///param: dataDate, areaCode, accNo, deptCode
  static getInstDeptWKEMP() {
    changeEnterTest();
    return "$workInstallDomainName" + "getDeptWKEMP?";
  }

  ///取得通路區域
  ///param: dataDate, accNo, lineNo, channDeptCd, deptCode
  static getInstAreaWKEMP() {
    changeEnterTest();
    return "$workInstallDomainName" + "getAreaWKEMP?";
  }

   ///取得贈送月份
   ///para: type, bossCode,
   static getGiftsMonth() {
     changeEnterTest();
    return "$workInstallDomainName" + "getGiftsMonth?";
   }

   ///取得派修下拉選單
   ///param: none
   static getBossPhenData() {
    changeEnterTest();
    return "$workInstallDomainName" + "bossPhenData";
   }

   ///報修派單
   ///param: customerCode, operatorCode, phenomenonTypeCode, phenomenonCode, bookingDate, description
   static postOrderReportFault({customerCode, operatorCode, phenomenonTypeCode, phenomenonCode, bookingDate, description}) {
    changeEnterTest();
    return "$workInstallDomainName" + "orderReportFault?customerCode=$customerCode&operatorCode=$operatorCode&phenomenonTypeCode=$phenomenonTypeCode&phenomenonCode=$phenomenonCode&bookingDate=$bookingDate&description=$description";
   }

  ///切換測/正式機路徑
  static changeEnterTest() async {
    if (isEnterTest) {
      workInstallDomainName = "http://labedi.dctv.net.tw:8080/WorkInstall/";
      domainNameAES = "http://labedi.dctv.net.tw:8080/WorkInstall/interfaceJsonAES";
    }
    else {
      workInstallDomainName = "http://wos.dctv.net.tw:8083/WorkInstall/";
      domainNameAES = "http://wos.dctv.net.tw:8083/WorkInstall/interfaceJsonAES";
    }
  }


}