import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smas_acs_copy/models/worker.dart';
import 'package:smas_acs_copy/utils/acs_http_utils.dart';
import 'package:smas_common_copy/common_global.dart';
import 'package:smas_common_copy/generated/i18n.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:convert';

class WorkerInfo extends StatefulWidget {
  @override
  _WorkerInfoState createState() => _WorkerInfoState();
}

class _WorkerInfoState extends State<WorkerInfo> {
  List baseInfo;
  List valList = [];
  String _site = 'none';
  Worker wkInfo = new Worker();
  String _msg;
  bool scanResult = false;
  bool accessExist = true;
  bool mdeicalExist = true;
  bool workerExist = true;

  @override
  void initState() {
    initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _msg = I18n.of(context).acs_scan_qr_code;
    baseInfo = [
      {'title': I18n.of(context).acs_base_info},
      {'title': I18n.of(context).acs_smart_card_id + ' :'},
      {'title': I18n.of(context).acs_chinese_name + ' :'},
      {'title': I18n.of(context).acs_english_name + ' :'},
      {'title': I18n.of(context).acs_cwra_no + ' :'},
      {'title': I18n.of(context).acs_status + ' :'},
      {'title': I18n.of(context).acs_access_right},
      {'title': I18n.of(context).acs_vendor + ' :'},
      {'title': I18n.of(context).acs_eff_date + ' :'},
      {'title': I18n.of(context).acs_trade + ' :'},
      {'title': I18n.of(context).acs_medical_test},
      {'title': I18n.of(context).acs_desc + ' :'},
      {'title': I18n.of(context).acs_eff_date + ' :'},
      {'title': I18n.of(context).acs_result + ' :'},
    ];

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade400,
        centerTitle: true,
        title: Text(I18n.of(context).acs_scan_worker),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
                icon: Icon(Icons.keyboard_backspace),
                onPressed: () {
                  Navigator.of(context).pop();
                });
          },
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: new Visibility(
        visible: _site == 'none' ? false : true,
        child: new FloatingActionButton(
          onPressed: _scan,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Card(
      color: Colors.orange.shade400,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: scanResult ? _buildGrid() : _buildContain(),
        ),
      ),
    );
  }

  Widget _buildContain() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Center(
        child: new Text(
          _msg,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.red,
            fontSize: 22.0,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    List<Widget> tiles = [];
    Widget content;

    for (int i = 0, j = 0;j < baseInfo.length;j++) {
      if (j <= 6) {
        if (j == 0 || j == 6) {
          tiles.add(_buildGridType1(j));
        }else{
          tiles.add(_buildGridType2(j, i));
        }

        i++;
      }else if (j > 6 && j <= 9) {
        if (accessExist) {
          tiles.add(_buildGridType3(j,i));
          i++;
        }
      }else if (j > 9) {
        if (mdeicalExist) {
          if (j == 10) {
            tiles.add(_buildGridType4(j));
          }else{
            tiles.add(_buildGridType5(j,i));
          }

          i++;
        }
      }
    }

    return _buildContent(tiles);
  }

  Widget _buildContent(List<Widget> tiles) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildContent1(tiles),
        _buildContent2(tiles),
        _buildContent3(tiles),
      ],
    );
  }

  Widget _buildContent3(List<Widget> tiles) {
    return mdeicalExist ? Container(
      padding: EdgeInsets.only(left: 10,top:0,right: 10,bottom: 5),
      alignment: Alignment.topLeft,
      color: valList[valList.length - 1] == I18n.of(context).positive ? Colors.red : Colors.green,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.black,
            height: 0,
          ),
          tiles[valList.length - 4],
          tiles[valList.length - 3],
          tiles[valList.length - 2],
          tiles[valList.length - 1],
        ],
      ),
    ) : Container(
      padding: EdgeInsets.all(10),
      color: Colors.red,
      alignment: Alignment.topLeft,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: new Text(
              I18n.of(context).acs_medical_test,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 20.0
              ),
            ),
          ),
          Center(
            child: new Padding(
              padding: EdgeInsets.only(top: 10),
              child: new Text(
                I18n.of(context).no_record,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent2(List<Widget> tiles) {
    return accessExist ? Container(
      padding: EdgeInsets.only(left:10,top:0,right: 10,bottom: 5),
      color: Colors.green,
      alignment: Alignment.topLeft,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.black,
            height: 0,
          ),
          tiles[6],
          tiles[7],
          tiles[8],
          tiles[9],
        ],
      ),
    ) : Container(
      padding: EdgeInsets.all(10),
      color: Colors.red,
      alignment: Alignment.topLeft,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: new Text(
              I18n.of(context).acs_access_right,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color:Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top:10),
              child: new Text(
                I18n.of(context).no_record,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent1(List<Widget> tiles) {
    return Container(
      padding: EdgeInsets.only(left: 10,top:5,right: 10,bottom: 5),
      alignment: Alignment.topLeft,
      color: valList[5] != 'A - Active' ? Colors.red.shade400 : Colors.green,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          tiles[0],
          tiles[1],
          tiles[2],
          tiles[3],
          tiles[4],
          tiles[5],
        ],
      ),
    );
  }

  Widget _buildGridType5(int j,int i) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: new Column(
        children: <Widget>[
          Text(
            baseInfo[j]['title'] + ' ' + valList[i],
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridType4(int j) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: new Column(
        children: <Widget>[
          Center(
            child: Text(
              baseInfo[j]['title'],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGridType3(int j,int i) {
    return Container(
      margin: EdgeInsets.only(top:10),
      child: new Column(
        children: <Widget>[
          Text(
            baseInfo[j]['title'] + ' ' + valList[i],
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 18.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGridType2(int j,int i) {
    return Container(
      margin: EdgeInsets.only(top:10),
      child: new Column(
        children: <Widget>[
          Text(
            baseInfo[j]['title'] + '' + valList[i],
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 18.0
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGridType1(int j) {
    return Container(
      margin: EdgeInsets.only(top:10),
      child: new Column(
        children: <Widget>[
          Center(
            child: Text(
              baseInfo[j]['title'],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 20.0
              ),
            )
          )
        ],
      ),
    );
  }

  Future _scan() async {
    try {
      valList.clear();
      String barcode = await scanner.scan();
      wkInfo = await AcsHttpUtils(context).getWorkerInfo(
        json.decode(barcode)['smartCardId'],
        _site.split("#")[0],
      );

      if (wkInfo.smartCardId == null) {
        scanResult = false;
        _msg = I18n.of(context).acs_invalid_qr_code;

        if (mounted) {
          setState(() {});
        }
        return;
      }

      accessExist = wkInfo.workerAccessRight == null ? false : true;
      mdeicalExist = wkInfo.workerMedicalTest == null ? false : true;
      valList.add('');
      valList.add(wkInfo.smartCardId == null ? '' : wkInfo.smartCardId);
      valList.add(wkInfo.chineseName == null ? '' : wkInfo.chineseName);
      valList.add(wkInfo.englishName == null ? '' : wkInfo.englishName);
      valList.add(wkInfo.cwraCardNo == null ? '' : wkInfo.cwraCardNo);
      valList.add(wkInfo.status + ' - ' + wkInfo.statusDesc);
      valList.add('');

      if (accessExist) {
        valList.add(wkInfo.workerAccessRight.vendorId + ' - ' + wkInfo.workerAccessRight.vendorDesc);
        valList.add(wkInfo.workerAccessRight.effectiveDate == null ? '' :
        wkInfo.workerAccessRight.effectiveDate.substring(0,10) +
        '~' +
            (wkInfo.workerAccessRight.effectiveDateTo == null ? '':
            wkInfo.workerAccessRight.effectiveDateTo.substring(0,10)));
        valList.add(wkInfo.workerAccessRight.tradeId + ' - ' + wkInfo.workerAccessRight.tradeDesc);
      }

      valList.add('');

      if (mdeicalExist) {
        valList.add(wkInfo.workerMedicalTest.medicalTestDesc);
        valList.add(wkInfo.workerMedicalTest.effectiveDate == null ? '' : wkInfo.workerMedicalTest.effectiveDate.substring(0,10) +
    '~' +
            (wkInfo.workerMedicalTest.etfToDate == null ? '' : wkInfo.workerMedicalTest.etfToDate.substring(0,10)));
        valList.add(wkInfo.workerMedicalTest.result == '0' ? I18n.of(context).negative : I18n.of(context).positive);
      }

      scanResult = true;
    } catch (e) {
      _msg = I18n.of(context).acs_invalid_qr_code;
      scanResult = false;
    }

    if (mounted) {
      setState(() {

      });
    }
  }

  initValue() async {
    _site = Global.getPreference().getString('acs_site_id');
    if (mounted) {
      setState(() {});
    }
  }
}
