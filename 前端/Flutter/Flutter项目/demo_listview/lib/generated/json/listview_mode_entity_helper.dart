import 'package:demo_listview/Model/listview_mode_entity.dart';

//1
listviewModeEntityFromJson(ListviewModeEntity data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['duration'] != null) {
		data.duration = json['duration'] is String
				? double.tryParse(json['duration'])
				: json['duration'].toDouble();
	}
	if (json['data'] != null) {
		data.data = ListviewModeData().fromJson(json['data']);
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	return data;
}

Map<String, dynamic> listviewModeEntityToJson(ListviewModeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['code'] = entity.code;
	data['message'] = entity.message;
	data['duration'] = entity.duration;
	data['data'] = entity.data?.toJson();
	data['status'] = entity.status;
	return data;
}

//2
listviewModeDataFromJson(ListviewModeData data, Map<String, dynamic> json) {
	if (json['pagination'] != null) {
		data.pagination = ListviewModeDataPagination().fromJson(json['pagination']);
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => ListviewModeDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> listviewModeDataToJson(ListviewModeData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['pagination'] = entity.pagination?.toJson();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

//3
listviewModeDataPaginationFromJson(ListviewModeDataPagination data, Map<String, dynamic> json) {
	if (json['page'] != null) {
		data.page = json['page'].toString();
	}
	if (json['pageSize'] != null) {
		data.pageSize = json['pageSize'].toString();
	}
	if (json['pageCount'] != null) {
		data.pageCount = json['pageCount'] is String
				? int.tryParse(json['pageCount'])
				: json['pageCount'].toInt();
	}
	if (json['totalCount'] != null) {
		data.totalCount = json['totalCount'].toString();
	}
	return data;
}

Map<String, dynamic> listviewModeDataPaginationToJson(ListviewModeDataPagination entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['page'] = entity.page;
	data['pageSize'] = entity.pageSize;
	data['pageCount'] = entity.pageCount;
	data['totalCount'] = entity.totalCount;
	return data;
}

//4
listviewModeDataListFromJson(ListviewModeDataList data, Map<String, dynamic> json) {
	if (json['order_id'] != null) {
		data.orderId = json['order_id'].toString();
	}
	if (json['img_url'] != null) {
		data.imgUrl = json['img_url'].toString();
	}
	if (json['data'] != null) {
		data.data = ListviewModeDataListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> listviewModeDataListToJson(ListviewModeDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['order_id'] = entity.orderId;
	data['img_url'] = entity.imgUrl;
	data['data'] = entity.data?.toJson();
	return data;
}

//5
listviewModeDataListDataFromJson(ListviewModeDataListData data, Map<String, dynamic> json) {
	if (json['log_time'] != null) {
		data.logTime = json['log_time'].toString();
	}
	if (json['use_time'] != null) {
		data.useTime = json['use_time'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'];
	}
	return data;
}

Map<String, dynamic> listviewModeDataListDataToJson(ListviewModeDataListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['log_time'] = entity.logTime;
	data['use_time'] = entity.useTime;
	data['content'] = entity.content;
	return data;
}