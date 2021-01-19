开发的时候，经常使用tableview，但是很少注意样式的选用，就是plain和group的区分，不管是plain还是group，取决于你想要什么样式。

### Group样式

- 默认帮你实现了header和footer;
- 没有悬浮效果；
- 设置header和footer的高度为0，如果你不想要的话，最后就是没有header、footer，没有悬浮。设置标题tableHeaderView的高度为特小值，但不能为零，若为零的话，ios会取默认值18，就无法消除头部间距了。

    ```objectivec
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    view.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = view;

    //或者
    -(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
          return 0.01f;
    }

    // 或者：特殊的处理方法也能实现该效果
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);

    - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
    {
        return 12;
    }

    - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
    {
        if (section == self.datalist.count-1) {
            return 12;
        }
        
        return 0.01;
    }
    ```

### Plain样式

- 没有主动实现header和footer;
    - 想让plain类型的section之间留有空白，需要在UITableView代理方法中return自定义的header和footer，并在自定义的UITableViewHeaderFooterView里面重写setFrame方法
- 但是有悬浮的效果；
    - 让plain类型的UITableView段头不停留（取消粘性效果）

    ```objectivec
    -(void)scrollViewDidScroll:(UIScrollView *)scrollView {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    ```

- 去掉悬浮效果，最后也是实现了，没有header、footer，没有悬浮