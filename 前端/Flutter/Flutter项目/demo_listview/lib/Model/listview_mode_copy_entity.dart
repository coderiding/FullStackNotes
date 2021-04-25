import 'package:demo_listview/generated/json/base/json_convert_content.dart';
import 'package:demo_listview/generated/json/base/json_field.dart';

class ListviewModeCopyEntity with JsonConvert<ListviewModeCopyEntity> {
	String name;
	int code;
	String message;
	double duration;
	ListviewModeCopyData data;
	int status;
}

class ListviewModeCopyData with JsonConvert<ListviewModeCopyData> {
	ListviewModeCopyDataPagination pagination;
	@JSONField(name: "list")
	List<ListviewModeCopyDataList> xList;
}

class ListviewModeCopyDataPagination with JsonConvert<ListviewModeCopyDataPagination> {
	String page;
	String pageSize;
	int pageCount;
	String totalCount;
}

class ListviewModeCopyDataList with JsonConvert<ListviewModeCopyDataList> {
	@JSONField(name: "order_id")
	String orderId;
	@JSONField(name: "img_url")
	String imgUrl;
	ListviewModeCopyDataListData data;
}

class ListviewModeCopyDataListData with JsonConvert<ListviewModeCopyDataListData> {
	@JSONField(name: "log_time")
	String logTime;
	@JSONField(name: "use_time")
	String useTime;
	dynamic content;
}
