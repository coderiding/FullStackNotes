我们在开发中，UITableView是很常用的控件。有的时候，系统自带的分割线可以满足产品的要求（实在是万幸），但是大部分时候，系统自带的分割线并不能满足产品的需求，那就需要我们自定义。那么tableview的分割线我们一般是如何绘制的呢？
温馨提示：以下设置分割线的方法只针对于tableview的plain样式，group样式不适用。
一、自己添加一个view来实现

我们自定义tableview的分割线的时候，一般是采用如下的方式：
    1. 先在tableview中，关闭系统自带的分割线。
tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    2. 在cell中添加一个view。按需求设置好颜色，设置view的高度为一个像素。然后把这个view添加到cell的contentview上。
- (UIView *)line {

   if (!_line) {
       
       _line = [[UIView alloc] initWithFrame:CGRectMake(0,54, [UIScreen mainScreen].bounds.size.width, 1.0/[UIScreen mainScreen].scale)];
       _line.backgroundColor = [UIColor blueColor];
   }
   return _line;
}
二、改造系统的分割线

随着开发时间越来越长，后来发现修改系统分割线的一些属性也可以达到需求想要的效果，不一定要采用添加一个view的方式来实现自定义分割线。
系统自带的分割线不是和屏幕等宽的，而是距离左边缘15个像素。
造成以上效果的原因是系统自带的分割线的edgeInsets默认是UIEdgeInsetsMake(0, 15, 0, 0)。
UIEdgeInsets的定义如下，分别是距离顶部、左边缘、底部、右边缘的距离。
  UIKIT_STATIC_INLINE UIEdgeInsets UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    UIEdgeInsets insets = {top, left, bottom, right};
    return insets;
}
UIEdgeInsetsZero和UIEdgeInsetsMake(0, 0, 0, 0)是相等的。
找到了系统分割线和屏幕不等宽的原因，那么当我们需要一条和屏幕等宽的分割线时，就可以通过修改degeInsets来达到效果。步骤如下：
* 1.设置tableview的相关属性。
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; //设置分割线的分割
    tableView.separatorColor = [UIColor blueColor]; //设置分割线的颜色
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)]; //设置分割线的边Insets
separatorStyle 可以不设置，默认是打开的。
* 2.在cell的初始化方法中调用该方法：
 [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
@property (nonatomic) UIEdgeInsets                    separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED; // allows customization of the separator frame
NS_AVAILABLE_IOS说明iOS7之后的系统都生效，所以setSeparatorInset:可以放心调用。
如果需要一条两边都留边距的分割线，修改UIEdgeInsetsMake的左右边距即可。例如：左右边距同时留10个像素。代码如是[self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
温馨提示：如果tableview和cell里设置的edgeInsets不一致时，cell里设置的edgeInsets生效。
综上所述：个人觉得以上两种设置分割线的方法，采用修改系统属性来达到要求的方式更好一些。代码量更少一些，维护方便，还有就是不会有坐标设置的问题产生，如果使用自定义view的方式，如果坐标设置的不严谨，会有坐标问题产生。除非是修改系统属性实在是达不到产品要求，才建议去自己写view实现分割线。个人见解，仅供参看。
时代在进步，人类的社会在发展。加油，明天会更好。
