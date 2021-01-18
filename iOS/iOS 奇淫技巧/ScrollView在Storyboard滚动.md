### 在ViewController里面演示

1. 拖一个ScrollView到View里面，拖动它距离四边为0
2. 约束1：ScrollView添加约束到四边为0
3. 拖一个View到ScrollView里面，取名ContainView，拖动它距离ScrollView四边为0
4. 约束1：ContainView距离ScrollView约束为0
5. 竖屏滚动
    1. 约束2：竖屏滚动添加Horizontally的一条线；
    2. 约束3：竖屏滚动，添加ContainView固定高度，拉出这个属性，这个高度就决定滚动的ContenSize；
6. 横屏滚动
    1. 约束2：横屏滚动添加Vertically的一条线
    2. 约束3：水平滚动，添加ContainView固定宽度，拉出这个属性，这个宽度就决定左右滚动的ContenSize；
7. 反勾选ScrollView尺子下面的Content Layout Guides属性