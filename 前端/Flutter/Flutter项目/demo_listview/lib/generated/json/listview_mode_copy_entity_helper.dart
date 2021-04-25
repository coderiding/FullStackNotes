import 'package:demo_listview/Model/listview_mode_copy_entity.dart';

listviewModeCopyEntityFromJson(ListviewModeCopyEntity data, Map<String, dynamic> json) {
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
		data.data = ListviewModeCopyData().fromJson(json['data']);
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	return data;
}

Map<String, dynamic> listviewModeCopyEntityToJson(ListviewModeCopyEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['code'] = entity.code;
	data['message'] = entity.message;
	data['duration'] = entity.duration;
	data['data'] = entity.data?.toJson();
	data['status'] = entity.status;
	return data;
}

listviewModeCopyDataFromJson(ListviewModeCopyData data, Map<String, dynamic> json) {
	if (json['pagination'] != null) {
		data.pagination = ListviewModeCopyDataPagination().fromJson(json['pagination']);
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => ListviewModeCopyDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> listviewModeCopyDataToJson(ListviewModeCopyData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['pagination'] = entity.pagination?.toJson();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

listviewModeCopyDataPaginationFromJson(ListviewModeCopyDataPagination data, Map<String, dynamic> json) {
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

Map<String, dynamic> listviewModeCopyDataPaginationToJson(ListviewModeCopyDataPagination entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['page'] = entity.page;
	data['pageSize'] = entity.pageSize;
	data['pageCount'] = entity.pageCount;
	data['totalCount'] = entity.totalCount;
	return data;
}

listviewModeCopyDataListFromJson(ListviewModeCopyDataList data, Map<String, dynamic> json) {
	if (json['order_id'] != null) {
		data.orderId = json['order_id'].toString();
	}
	if (json['img_url'] != null) {
		data.imgUrl = json['img_url'].toString();
	}
	if (json['data'] != null) {
		data.data = ListviewModeCopyDataListData().fromJson(json['data']);
	}
	return data;
}

Map<String, dynamic> listviewModeCopyDataListToJson(ListviewModeCopyDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['order_id'] = entity.orderId;
	data['img_url'] = entity.imgUrl;
	data['data'] = entity.data?.toJson();
	return data;
}

listviewModeCopyDataListDataFromJson(ListviewModeCopyDataListData data, Map<String, dynamic> json) {
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

Map<String, dynamic> listviewModeCopyDataListDataToJson(ListviewModeCopyDataListData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['log_time'] = entity.logTime;
	data['use_time'] = entity.useTime;
	data['content'] = entity.content;
	return data;
}