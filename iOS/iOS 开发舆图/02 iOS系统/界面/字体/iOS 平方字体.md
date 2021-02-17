iOS 平方字体

````
NSString *fontName = @"PingFangSC-Regular";
switch (fontWeight) {
    case FontWeightStyleMedium:
        fontName = @"PingFangSC-Medium";
        break;
    case FontWeightStyleSemibold:
        fontName = @"PingFangSC-Semibold";
        break;
    case FontWeightStyleLight:
        fontName = @"PingFangSC-Light";
        break;
    case FontWeightStyleUltralight:
        fontName = @"PingFangSC-Ultralight";
        break;
    case FontWeightStyleRegular:
        fontName = @"PingFangSC-Regular";
        break;
    case FontWeightStyleThin:
        fontName = @"PingFangSC-Thin";
        break;
}

UIFont *font = [UIFont fontWithName:fontName size:fontSize];

return font ?: [UIFont systemFontOfSize:fontSize];
````