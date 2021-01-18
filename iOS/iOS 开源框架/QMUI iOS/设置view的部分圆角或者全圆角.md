```objectivec
- (void)updateMaskedCorners {
    QMUICornerMask cornerMask = 0;
    if (self.maskedCornersMinXMinYButton.isSelected) {
        cornerMask |= QMUILayerMinXMinYCorner;
    }
    if (self.maskedCornersMaxXMinYButton.isSelected) {
        cornerMask |= QMUILayerMaxXMinYCorner;
    }
    if (self.maskedCornersMinXMaxYButton.isSelected) {
        cornerMask |= QMUILayerMinXMaxYCorner;
    }
    if (self.maskedCornersMaxXMaxYButton.isSelected) {
        cornerMask |= QMUILayerMaxXMaxYCorner;
    }
    if (cornerMask == 0) {
        // 默认值
        cornerMask = QMUILayerMinXMinYCorner|QMUILayerMaxXMinYCorner|QMUILayerMinXMaxYCorner|QMUILayerMaxXMaxYCorner;
    }
    self.targetView.layer.qmui_maskedCorners = cornerMask;
}
```