使用BMKOfflineMap：返回的对象中有城市编码
/**

根据城市名搜索该城市离线地图记录
@param cityName 城市名
@return 该城市离线地图记录,用户需要显示释放该数组，数组元素为BMKOLSearchRecord
/
- (NSArray*)searchCity:(NSString*)cityName;
或者：
http://lbsyun.baidu.com/index.php?title=open/dev-res 百度地图城市名称-城市代码（cityCode）关系对照文本

