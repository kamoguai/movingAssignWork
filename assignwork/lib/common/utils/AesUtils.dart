
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pointycastle/pointycastle.dart';

///
///aes加解密
///Date: 2019-05-23
///
class AesUtils {
  
  static final String _aeskey_en = 'dctv2952dctv2952';
  static final String _aeskey_de = 'dctv1688dctv1688';
  static final int _iv_size = 16;
  /// AES加密 128
  ///
  /// - Parameters:
  ///   - msg: 原始字串
  /// - Returns: String
  static String aes128Encrypt(String msg) {
    ///宣告key轉byte[]
    var raw = utf8.encode(_aeskey_en);
    ///宣告iv長度轉byte[]
    var iv = Uint8List(_iv_size);
    ///宣告隨機數
    var random = Random.secure();
    ///宣告隨機數列長度為16
    var values = List<int>.generate(16, (i) => random.nextInt(256));
    ///轉成byte[]
    iv = Uint8List.fromList(values);
    ///宣告chiper方法及帶入key和iv
    CipherParameters params = new PaddedBlockCipherParameters(new ParametersWithIV(new KeyParameter(raw), iv), null);
    ///使用AES/CBC/PKCS7格式
    BlockCipher encryptionCipher = new PaddedBlockCipher('AES/CBC/PKCS7');
    ///cipher初始化，true代表encrypt
    encryptionCipher.init(true, params);
    ///原始字串轉byte[]後，由cipher執行壓碼
    Uint8List encrypted = encryptionCipher.process(utf8.encode(msg));
    ///添加規則，規則為msg轉byte 和 vi隨機數轉byte，二筆加再一起
    var outBytes = Uint8List(_iv_size + encrypted.length);
    ///宣告空陣列去裝規則內容
    List<int> list = [];
    for (var i in encrypted) {
      list.add(i);
    }
    for (var i in iv) {
      list.add(i);
    }
    ///將陣列轉為byte[]
    outBytes = Uint8List.fromList(list);
    ///最後回傳base64字串
    return base64.encode(outBytes);
  }
  /// AES解密 128
  ///
  /// - Parameters:
  ///   - encrypted: 壓過碼的字串
  /// - Returns: String
  static String aes128Decrypt(String encrypted) {
    String decyptedResult = "";
    try {
      ///宣告key轉byte[]
      var raw = utf8.encode(_aeskey_de);
      ///將壓碼字串作base64解碼
      var enctypted1 = base64Decode(encrypted);
      ///宣告iv長度轉byte[]
      var iv = Uint8List(_iv_size);
      ///宣告解密規則
      var msgBytes = Uint8List(enctypted1.length - _iv_size);
      ///將aes encrypt字串內容長度轉byte丟進msgBytes
      msgBytes = enctypted1.buffer.asUint8List(0,msgBytes.length);
      ///將aes encrypt字串內容長度取後iv長度丟進ivByte
      iv = Uint8List.fromList(enctypted1.skip(msgBytes.length).toList());
      ///宣告chiper方法及帶入key和iv
      CipherParameters params = new PaddedBlockCipherParameters(new ParametersWithIV(new KeyParameter(raw), iv), null);
      ///使用AES/CBC/PKCS7格式
      BlockCipher decryptionCipher = new PaddedBlockCipher('AES/CBC/PKCS7');
      ///cipher初始化，false代表descrypt
      decryptionCipher.init(false, params);
      ///將msgBytes由cipher執行壓碼
      var cipherProcess = decryptionCipher.process(msgBytes);
      ///將結果轉回字串
      decyptedResult = utf8.decode(cipherProcess);
    } catch (e) {
      Fluttertoast.showToast(msg: "AES解析失敗", timeInSecForIos: 2, fontSize: 20);
      decyptedResult = "";
    }
    ///回傳明碼字串
    return decyptedResult;
    
   
  }
}