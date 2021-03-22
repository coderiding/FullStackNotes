

```

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
    //return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(1 == indexPath.section){
        // 刘汶：暂时隐藏重量cell
        if (indexPath.row==8) {
            return 0;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

```