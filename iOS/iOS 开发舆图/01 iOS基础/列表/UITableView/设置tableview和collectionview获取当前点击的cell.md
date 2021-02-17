tableview/collectionview获取当前点击的cell

````

一般collectionView 或者 tableview都有自带的点击函数，如下：
1, collectionView
   -(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//一般情况，cell不是自定义
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]; //即为要得到的cell
//自定义的cell
   TitleViewCell * cell = (TitleViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];//即为要得到的cell
}


2,tableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//非自定义cell
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
 //自定义cell
     NewsTableViewCell * cell = (NewsTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
}

````