```

在ios7以前的代码
// 设置距离左右各10的距离
* 
(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
[self.myTable setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
}
* 
if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
[cell setLayoutMargins:UIEdgeInsetsZero];
}
}

* 
(void)viewDidLayoutSubviews{
[super viewDidLayoutSubviews];
if ([self.myTable respondsToSelector:@selector(setSeparatorInset:)]) {
[self.myTable setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
}
if ([self.myTable respondsToSelector:@selector(setLayoutMargins:)]) {
[self.myTable setLayoutMargins:UIEdgeInsetsZero];
}
}
在ios7以后的代码
tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine
设置分隔线的颜色
self.tableView.separatorColor = rgb();


```