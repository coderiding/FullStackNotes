```
iOS tableView刷新后防止滚动

// 添加数据刷新后，防止tableview滑动(防止reload滑动)

    self.tableView.estimatedRowHeight = 0;

    self.tableView.estimatedSectionHeaderHeight = 0;

    self.tableView.estimatedSectionFooterHeight = 0;
```