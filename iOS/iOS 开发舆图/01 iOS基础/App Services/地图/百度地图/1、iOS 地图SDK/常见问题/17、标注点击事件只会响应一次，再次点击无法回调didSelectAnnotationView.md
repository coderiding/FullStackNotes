标注在选中状态时不能被再次选中，所以就不会回调didSelectAnnotationView，取消选中后才可以被选中 取消选中方法，BMKMapView中有相关方法： - (void)deselectAnnotation:(id <BMKAnnotation>)annotation animated:(BOOL)animated;

