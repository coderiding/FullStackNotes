import 'package:flutter/material.dart';

class WorkerScanQrCode extends StatefulWidget {
  @override
  _WorkerScanQrCodeState createState() => _WorkerScanQrCodeState();
}

class _WorkerScanQrCodeState extends State<WorkerScanQrCode> {
  String _smartCardId = '';
  String _chineseName = '';
  String _englishName = '';
  String _accessDate = '';
  String _result = '';
  String _msg = '';
  String _site = '';
  String _conValue = 'none';
  String systemTime = '';
  List<String> _tempCon = [];
  List<DropdownMenuItem<String>> cons = [];
  static Map<String,String> responseMsg;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
