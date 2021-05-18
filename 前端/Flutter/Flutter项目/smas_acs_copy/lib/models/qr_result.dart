// To parse this JSON data, do
//
//     final qrResult = qrResultFromJson(jsonString);

import 'dart:convert';

QrResult qrResultFromJson(String str) => QrResult.fromJson(json.decode(str));

String qrResultToJson(QrResult data) => json.encode(data.toJson());

class QrResult {
  QrResult({
    this.smartCardId,
    this.englishName,
    this.chineseName,
    this.accessDate,
    this.resultFlag,
    this.msgCode,
  });

  String smartCardId;
  String englishName;
  String chineseName;
  String accessDate;
  bool resultFlag;
  String msgCode;

  factory QrResult.fromJson(Map<String, dynamic> json) => QrResult(
    smartCardId: json["smartCardId"],
    englishName: json["englishName"],
    chineseName: json["chineseName"],
    accessDate: json["accessDate"],
    resultFlag: json["resultFlag"],
    msgCode: json["msgCode"],
  );

  Map<String, dynamic> toJson() => {
    "smartCardId": smartCardId,
    "englishName": englishName,
    "chineseName": chineseName,
    "accessDate": accessDate,
    "resultFlag": resultFlag,
    "msgCode": msgCode,
  };
}
