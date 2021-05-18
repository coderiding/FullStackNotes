import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smas_acs_copy/utils/acs_http_utils.dart';
import 'package:smas_common_copy/common_global.dart';

class AcsUtils {
  List<String> consMap = [];
  List<String> sitesMap = [];

  Future<dynamic> getSite(BuildContext context) async {
    List<DropdownMenuItem<String>> items = [];
    List siteList = await AcsHttpUtils(context).getSite();

    for(int i = 0; i < siteList.length; i++) {
      sitesMap.add(siteList[i]['siteId'] + '#' + siteList[i]['siteDesc']);
      DropdownMenuItem<String> item = new DropdownMenuItem<String>(
        value: siteList[i]['siteId'] + '#' + siteList[i]['siteDesc'],
        child: SizedBox(
          width: 300.0,
          child: Text(siteList[i]['siteId'] + ' - ' + siteList[i]['siteDesc'],
          textAlign: TextAlign.center,
          ),
        ),
      );
      items.add(item);
    }
    Global.getPreference().setStringList('acs_sites_map', sitesMap);
    return items;
  }

  Future<dynamic> getConnection(BuildContext context,String siteId) async {
    List<DropdownMenuItem<String>> items = [];
    List conList = await AcsHttpUtils(context).getConnection(siteId);

    for (var i = 0;i < conList.length; i++) {
      consMap.add(conList[i]['connectionId']);
      DropdownMenuItem<String> item = new DropdownMenuItem<String> (
        value: conList[i]['connectionId'],
        child: new Text(conList[i]['connectionDesc']),
      );
      items.add(item);
    }
    Global.getPreference().setStringList('acs_cons_map', consMap);
    return items;
  }
}