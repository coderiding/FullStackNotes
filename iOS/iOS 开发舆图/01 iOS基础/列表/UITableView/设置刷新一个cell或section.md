```objectivec
//一个section刷新
int section_index=10;//更新第11个sectioin
[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section_index] withRowAnimation:UITableViewRowAnimationNone];
//一个cell刷新    
NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];  //更新 第一个section的第4行  
[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
```