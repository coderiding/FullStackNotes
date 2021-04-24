import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/config_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel({this.config, this.bannerList, this.localNavList, this.subNavList,
      this.gridNav, this.salesBox});

  factory HomeModel.fromJson(Map<String,dynamic>json) {
    var bListJson = json['bannerList'] as List;
    List<CommonModel> bList = bListJson.map((i) => CommonModel.fromJson(i)).toList();
    var lListJson = json['localNavList'] as List;
    List<CommonModel> lList = lListJson.map((i) => CommonModel.fromJson(i)).toList();
    var sListJson = json['subNavList'] as List;
    List<CommonModel> sList = sListJson.map((e) => CommonModel.fromJson(e)).toList();
    return json != null ?
        HomeModel(
          config: ConfigModel.fromJson(json['config']),
          bannerList: bList,
          localNavList: lList,
          subNavList: sList,
          gridNav: GridNavModel.fromJson(json['gridNav']),
          salesBox: SalesBoxModel.fromJson(json['salesBox'])
        ): null;
  }
}
