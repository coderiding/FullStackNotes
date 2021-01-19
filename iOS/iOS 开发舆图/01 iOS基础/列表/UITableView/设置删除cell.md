```objectivec
// gist说明：iOS删除row或者section

// 删除section
[self.dataArr  removeObjectAtIndex:[indexPath section]];  
[self.tableV deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];

// 删除row
[self.dataArr  removeObjectAtIndex:idx];  
[self.tableV deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
```