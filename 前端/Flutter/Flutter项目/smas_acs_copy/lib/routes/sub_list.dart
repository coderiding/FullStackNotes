import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smas_acs_copy/utils/acs_utils.dart';
import 'package:smas_common_copy/common_global.dart';
import 'package:smas_common_copy/config_reader.dart';
import 'package:smas_common_copy/generated/i18n.dart';

class SubList extends StatefulWidget {
  @override
  _SubListState createState() => new _SubListState();
}

class _SubListState extends State<SubList> {
  List moduleName;
  List modulePath = ['images/attendance.png','images/info.png'];
  List routes = ['/qrScan','/workerInfo'];
  String _siteValue = 'none';
  List<String> _tempSite = [];
  List<DropdownMenuItem<String>> sites = [];

  @override
  void initState() {
    initSiteValue();
    super.initState();
  }

  initSiteValue() async {
    sites = await AcsUtils().getSite(context);
    DropdownMenuItem<String> item0 = new DropdownMenuItem<String>(
      value: 'none',
      child: SizedBox(
        width: 300.0,
        child: Text(I18n.of(context).acs_select_site,textAlign: TextAlign.center,),
      ),
    );
    sites.insert(0, item0);
    _siteValue = Global.getPreference().getString('acs_site_id');
    _tempSite = Global.getPreference().getStringList('acs_sites_map');
    _siteValue = _tempSite.contains(_siteValue) ? _siteValue : 'none';
    if (mounted) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    moduleName = [
      I18n.of(context).acs_scan_attendance,
      I18n.of(context).acs_scan_worker
    ];
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal.shade400,
        title: Text(I18n.of(context).acs_applications_list),
        leading: Builder(builder: (context){
          return IconButton(
              icon: Icon(Icons.keyboard_backspace),
              onPressed: (){
                Navigator.of(context).pop();
              }
          );
        }),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: GridView.builder(
                itemCount: routes.length - 1,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context,index){
                  String iconPath = ConfigReader.getConfig()['acs_api_url'] + modulePath[index];
                  String title = moduleName[index];

                  return GestureDetector(
                    onTap: (){
                      if (_siteValue == 'none'){
                        Fluttertoast.showToast(
                          fontSize: 18,
                          gravity: ToastGravity.BOTTOM,
                          msg: I18n.of(context).acs_unselected_site,
                        );
                      }else {
                        return Navigator.of(context).pushNamed(routes[index]);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Image.network(
                          iconPath,
                          height: MediaQuery.of(context).size.height/10,
                          fit: BoxFit.fitWidth,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          DropdownButton(
            onChanged: (T){
              if (mounted) {
                setState(() {
                  _siteValue = T;
                  Global.getPreference().setString('acs_site_id', _siteValue);
                });
              }
            },
            value: _siteValue,
            icon: Icon(Icons.my_location),
            iconSize: 20,
            items: sites,
            iconEnabledColor: Colors.green.withOpacity(0.7),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color:Colors.black54,
              fontSize: 18.0
            ),
          ),
        ],
      ),
    );
  }

}