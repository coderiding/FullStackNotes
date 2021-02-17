iosTableView 局部全部刷新以及删除编辑操作
https://blog.csdn.net/weixin_34309543/article/details/86119703

局部刷新方法

### 添加数据
````
NSArray *indexPaths = @[
                       [NSIndexPath indexPathForRow:0 inSection:0],
                       [NSIndexPath indexPathForRow:1 inSection:0]
                       ];
[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];

//刘汶：注意删除的顺序，先删除数据源，后使用delerow

// Editing of rows is enabled
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //when delete is tapped
        [currentCart removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
```


###删除数据
```
NSArray *indexPaths = @[
                     [NSIndexPath indexPathForRow:0 inSection:0],
                     [NSIndexPath indexPathForRow:1 inSection:0]
                     ];
[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
更新数据（没有添加和删除数据，仅仅是修改已经存在的数据）

NSArray *indexPaths = @[
                     [NSIndexPath indexPathForRow:0 inSection:0],
                     [NSIndexPath indexPathForRow:1 inSection:0]
                     ];
[self.tableView relaodRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
```


###左滑出现删除按钮
```
需要实现tableView的代理方法

  // 只要实现了这个方法，左滑出现Delete按钮的功能就有了
  // 点击了“左滑出现的Delete按钮”会调用这个方法
  - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
      {
      // 删除模型
      [self.wineArray removeObjectAtIndex:indexPath.row];
      // 刷新
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
      }   
       // 修改Delete按钮文字为“删除”
      - (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
      {
          return @"删除";
      }
```


###左滑出现N个按钮
```
需要实现tableView的代理方法只要实现了这个方法，左滑出现按钮的功能就有了(一旦左滑出现了N个按钮，tableView就进入了编辑模式, tableView.editing = YES)

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
  {
  }   
  // 左滑cell时出现什么按钮
  - (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
  {
      UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
      NSLog(@"点击了关注");
      // 收回左滑出现的按钮(退出编辑模式)
      tableView.editing = NO;
  }];
  UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
      [self.wineArray removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }];
  return @[action1, action0];
}
```

###进入编辑模式
```
// self.tabelView.editing = YES;
[self.tableView setEditing:YES animated:YES];
// 默认情况下，进入编辑模式时，左边会出现一排红色的“减号”按钮
在编辑模式中多选
// 编辑模式的时候可以多选
self.tableView.allowsMultipleSelectionDuringEditing = YES;
// 进入编辑模式
[self.tableView setEditing:YES animated:YES];
 
// 获得选中的所有行
self.tableView.indexPathsForSelectedRows;
```