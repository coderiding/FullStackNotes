- 两个UICollectionView上下联动，点击collectionviewA时，触发collectionviewB联动，这里collectionviewA是只能点击的，collectionviewB是只能滑动的

```objectivec
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 134是collectionviewA，就是点击的调用
    if (collectionView.tag == 134) {
        lw_mode_Car_cate *m = self.carTypesMode.car_cate[indexPath.row];
        self.selectCar = m;
        self.selectCarIndex = indexPath.row;
        
        // carPicCollectionView是collectionviewB,这里就是点击collectionviewA,collectionviewB滑动到相应位置
        [self.carPicCollectionView layoutIfNeeded];
        [self.carPicCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectCarIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 135) {
        
        // 写scrollViewDidScroll这个方法，是为了拿到偏移值，这样可以拿到collectionviewB滑动到那个row，再通知collectionviewA作出操作
        NSInteger index = scrollView.contentOffset.x/scrollView.width;
        
        lw_mode_Car_cate *m = self.carTypesMode.car_cate[index];
        self.selectCar = m;
        self.selectCarIndex = index;
        
        [self reloadCarLabel];
        
        // 这里就是collectionviewA作出反应
        [self.collectionView layoutIfNeeded];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectCarIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
```