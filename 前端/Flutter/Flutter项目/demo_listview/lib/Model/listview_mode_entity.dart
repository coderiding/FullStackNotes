import 'package:demo_listview/generated/json/base/json_convert_content.dart';
import 'package:demo_listview/generated/json/base/json_field.dart';

//1
class ListviewModeEntity with JsonConvert<ListviewModeEntity> {
	String name;
	int code;
	String message;
	double duration;
	ListviewModeData data;
	int status;
}

//2
class ListviewModeData with JsonConvert<ListviewModeData> {
	ListviewModeDataPagination pagination;
	@JSONField(name: "list")
	List<ListviewModeDataList> xList;
}

//3
class ListviewModeDataPagination with JsonConvert<ListviewModeDataPagination> {
	String page;
	String pageSize;
	int pageCount;
	String totalCount;
}

//4
class ListviewModeDataList with JsonConvert<ListviewModeDataList> {
	@JSONField(name: "order_id")
	String orderId;
	@JSONField(name: "img_url")
	String imgUrl;
	ListviewModeDataListData data;
}

//5
class ListviewModeDataListData with JsonConvert<ListviewModeDataListData> {
	@JSONField(name: "log_time")
	String logTime;
	@JSONField(name: "use_time")
	String useTime;
	dynamic content;
}
