NestedScrollView属于Sliver系列控件，是对CustomScrollView的封装。内部由多个controller控制器实现，与RefreshIndicator组合实现ListView下拉刷新时出现滑动BUG。

可以在其内部嵌套其他滚动视图的滚动视图，其滚动位置是固有链接的。

<img src='https://gitee.com/threecornerstones/ThreeCornerstones_Pic/raw/master/uPic/3zWQvH.png' alt='3zWQvH'/>

https://blog.csdn.net/jaynm/article/details/105486590  Flutter 基于NestedScrollView+RefreshIndicator完美解决滑动冲突  https://app.yinxiang.com/shard/s35/nl/9757212/2f8e939d-96e7-46ca-b09d-32ddf827ca67  