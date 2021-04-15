---
title: iOS开发之蓝牙Socket链接小票打印机（一） 
tags: 蓝牙
categories: 蓝牙
abbrlink: 18120
date: 2016-06-18 12:01:03
---

## 前言

之前公司有个面向商户的项目，需要连接商户打印机打印小票的功能。于是对这方面进行了学习研究，最后“顺利”的完成了项目需求。这里主要是对项目中用到的知识点进行一些总结。这篇文章主要包含的相关知识有：**Socket**、**CoreBluetooth**、**网口小票打印机**、**蓝牙小票打印机**、**ESC/POS打印命令集**、**图片打印**等。

## 概述

整个打印流程大致分可以为三个步骤，①链接打印机；②编辑排版打印内容；③发送数据给打印机；

①和③根据不同的打印机类型，我们要采取不同的链接方式。网口打印机通过Socket进行链接（需在同一局域网下），蓝牙打印机自然是通过蓝牙进行链接。
 ②编辑排版打印内容，需要通过ESC/POS打印命令集来做，以下会进行相关的介绍。

其实，步骤②编辑排版打印内容，放到后台做是更加合理的，这样Android和iOS两端就避免了都要写编辑排版的代码，而且也能避免排版上的差异。我们公司也是这样做的，所以步骤②就可以改为从后台获取要打印的数据。

## ESC/POS打印命令集

### 简介

> WPSON StandardCode for Printer 是EPSON公司自己制定的针式打印机的标准化指令集，现在已成为针式打印机控制语言事实上的工业标准。ESC/POS打印命令集是ESC打印控制命令的简化版本，现在大多数票据打印都采用ESC/POS指令集。其显著特征是：其中很大一部分指令都是以ESC控制符开始的一串代码。

打印机的型号种类有很多，不同的厂家也对其产品做了相应的定制。但是，ESC/POS指令集基本都会支持。关于指令的详细内容，网上有很多[文档](https://wenku.baidu.com/view/9a165cb8647d27284a735128.html?mark_pay_doc=0&mark_rec_page=1&mark_rec_position=2&clear_uda_param=1)，另外每个品牌的官网，也会有对应的打印机指令文档提供下载。我们可以下载下来研究。这里简单介绍几种常用的指令：



<!-- more -->

### 指令介绍

说明：一般打印机接受指令都支持三种格式：ASCII、十进制、十六进制。

#### 1、初始化打印机

| ASCII | 十进制 | 十六进制 |
| ----- | ------ | -------- |
| ESC @ | 27 64  | 1B 40    |

说明：清除打印缓冲区，删除用户自定义字符，打印模式被设为上电时的默认值模式。

代码：

```csharp
//重置打印机
- (void)resetPrinter {
   Byte reset[] = {0x1B,0x40};
   [self.printData appendBytes:reset length:1];
}
```

**注意：经笔者测试发现，使用初始化命令，之后的一条命令可能会失效，目前未找到原因，可能是打印机问题。另外，由于此命令会清除缓冲区，频繁调用可能会导致数据丢失，因此尽量少用此命令。**

#### 2、打印并换行

| ASCII | 十进制 | 十六进制 |
| ----- | ------ | -------- |
| LF    | 10     | 0A       |

说明：将打印缓冲区中的数据打印出来，并且按照当前行间距，把打印纸向前推进一行。

代码：

```csharp
//打印机并换行
- (void)printAndNewline {
   Byte next[] = {0x0A};
   [self.printData appendBytes:next length:1];
}
```

#### 3、打印并走n点行纸

| ASCII    | 十进制  | 十六进制 |
| -------- | ------- | -------- |
| LESC J n | 27 74 n | 1B 4A n  |

说明：打印缓冲区数据并走纸[ n × 纵向或横向移动单位] 英寸。0 ≤n ≤ 255。最大走纸距离是956 mm（不同品牌打印机数值不同）。如果超出这个距离，取最大距离。

代码：

```csharp
//打印缓冲区数据，并往前走纸n点行
- (void)printAndGoNPointLine:(int)n {
   Byte line[] = {0x1B, 0x4A, n};
   [self.printData appendBytes:line length:3];
}
```

**注意：这里是走纸点行数，要与字符行数区分**

#### 4、打印并走n行纸

| ASCII   | 十进制   | 十六进制 |
| ------- | -------- | -------- |
| ESC d n | 27 100 n | 1B 64 n  |

说明：打印缓冲区里的数据并向前走纸n行（字符行）。0 ≤n ≤ 255。该命令不影响由ESC 2 或ESC 3设置的行间距。 最大走纸距离为1016 mm，当所设的值大于1016 mm时，取最大值。

代码：

```csharp
//打印缓冲区数据，并往前走纸n行
- (void)printAndGoNLine:(int)n {
   Byte line[] = {0x1B, 0x64, n};
   [self.printData appendBytes:line length:3];
}
```

**注意：这里是走纸字符行数，要与点行数区分。只有设置了行距后，此命令才有效。使用此命令前，要先使用换行指令，否则设置无效**

#### 5、设置默认行距(1/6英寸)

| ASCII | 十进制 | 十六进制 |
| ----- | ------ | -------- |
| ESC 2 | 27 50  | 1B 32    |

说明：选择约3.75mm 行间距。约34个点。

代码：

```csharp
//设置默认行间距
- (void)printDefaultLineSpace {
   Byte defaultLineSpace[] = {0x1B,0x32};
   [self.printData appendBytes:defaultLineSpace length:2];
}
```

#### 6、设置行间距为n 点行

| ASCII   | 十进制  | 十六进制 |
| ------- | ------- | -------- |
| ESC 3 n | 27 51 n | 1B 33 n  |

说明：设置行间距为[ n × 纵向或横向移动单位] 英寸。

代码：

```csharp
//设置行间距为n个点
- (void)printLineSpace:(int)n {
   Byte lineSpace[] = {0x1B,0x33,n};
   [self.printData appendBytes:lineSpace length:3];
}
```

**注意：使用此命令前，要先使用换行指令，否则设置无效**

#### 7、设置字符右间距

| ASCII    | 十进制  | 十六进制 |
| -------- | ------- | -------- |
| ESC SP n | 27 32 n | 1B 20 n  |

说明：设置字符的右间距为[n×横向移动单位或纵向移动单位]英寸。0 ≤ n ≤255。最大右间距是31.91毫米（255/203 英寸）。任何超过这个值的设置都自动转换为最大右间距。

代码：

```csharp
//字符右间距
- (void)printCharRightSpace:(int)n {
   Byte line[] = {0x1B, 0x20, n};
   [self.printData appendBytes:line length:3];
}
```

**注意：此命令对汉字无效**

#### 8、设置输出对齐方式

| ASCII   | 十进制  | 十六进制 |
| ------- | ------- | -------- |
| ESC a n | 27 97 n | 1B 61 n  |

说明：n = 0或48 为左对齐；n = 1或49为中间对齐；n = 2或50位右对齐。

代码：

```csharp
//设置对齐方式
- (void)setAlignment:(MNAlignmentType)alignmentType {
   Byte align[] = {0x1B,0x61,alignmentType};
   [self.printData appendBytes:align length:3];
}
```

#### 9、设置字体大小

| ASCII  | 十进制  | 十六进制 |
| ------ | ------- | -------- |
| GS ! n | 29 33 n | 1D 21 n  |

说明：用0 到2 位选择字符高度，4 到7 位选择字符宽度。

![Xnip2020-11-05_18-09-56](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-09-56.jpg)

代码：

```objectivec
//字符放大倍数
typedef enum: UInt8 {
   MNPrintFont_1 = 0x00,
   MNPrintFont_2 = 0x11,
   MNPrintFont_3 = 0x22,
   MNPrintFont_4 = 0x33,
   MNPrintFont_5 = 0x44,
   MNPrintFont_6 = 0x55,
   MNPrintFont_7 = 0x66,
   MNPrintFont_8 = 0x77,
} MNPrintFont;


//设置字体大小
-(void)printCharSize:(MNPrintFont)printFont {
   Byte font[] = {0x1D,0x21,printFont};
   [self.printData appendBytes:font length:3];
};
```

#### 10、选择切纸模式和切纸

| ASCII   | 十进制  | 十六进制 |
| ------- | ------- | -------- |
| GS V  m | 29 86 m | 1D 56 m  |

| ASCII    | 十进制    | 十六进制  |
| -------- | --------- | --------- |
| GS V m n | 29 86 m n | 1D 56 m n |

说明：

- m=0,1,49 ；0 表示全切， 1表示半切，当打印机没有半切功能时，全切；
- m=66, 0≤n≤255 ；当m=66时， n表示走纸到（约18mm）+[n*0.125mm] 位置切纸

代码：

```objectivec
//切纸模式
typedef enum :UInt8 {
   MNCutPaperModelFull = 0x00,
   MNCutPaperModelHalf = 0x01,
   MNCutPaperModelFeedPaperHalf = 0x66
}MNCutPaperModel;

- (void)printCutPaper:(MNCutPaperModel)model Num:(int)n {
   if (model == MNCutPaperModelFull) {
       Byte cut[] = {0x1D, 0x56, model, n};
       [self.printData appendBytes:cut length:4];
   } else {
       Byte cut[] = {0x1D, 0x56, model};
       [self.printData appendBytes:cut length:3];
   }
}
```

**注意这条指令需要打印机支持切纸**

#### 10、产生钱箱脉冲（开钱箱）

| ASCII         | 十进制         | 十六进制      |
| ------------- | -------------- | ------------- |
| ESC p m t1 t2 | 27 112 m t1 t2 | 1B 70 m t1 t2 |

说明：

- m = 0, 1, 48, 49 ; 0 ≤ t1 ≤ 255, 0 ≤ t2 ≤ 255 ;
- 输出由t1和t2设定的钱箱开启脉冲到由m指定的引脚：

| M     | 十进制           |
| ----- | ---------------- |
| 0, 48 | 钱箱插座的引脚 2 |
| 1, 49 | 钱箱插座的引脚 5 |

代码：

```kotlin
//产生钱箱控制脉冲，一般一个打印机连接一个钱箱，这里默认写死了
-(void)printOpenCashDrawer {
    Byte open[] = {0x1B, 0x70, 0x00, 0x80, 0xFF};
    [self.printData appendBytes:open length:5];
}
```

**注意这条指令需要打印机连接钱箱**

### 打印内容

说明：这里只要将打印内容通过`kCFStringEncodingGB_18030_2000`编码，然后发送给打印机

代码：

```objectivec
- (void)printWithContent:(NSString *)content {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [content dataUsingEncoding:enc];
    [self.printData appendData:data];
}
```

以上只是部分指令，可根据需求，参考指令集文档再做相应的添加。这里要提一下的是，小票打印多用于订单详情类信息，为了是排版更美观，这里用的比较多的是制表符`/t`来使每一列对齐，可以直接这样使用`[self.printManager printWithContent:@"\t"];`

### 图片打印

关于图片打印，这里介绍两种打印指令：

![Xnip2020-11-05_18-10-37](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-10-37.jpg)

位图模式.png

![Xnip2020-11-05_18-11-00](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-11-00.jpg)

光栅位图.png

#### 原理

因为小票打印机多为热敏打印机，或针式打印机，且颜色只有黑白两色。因此，要打印图片，首先要获取图片的像素数据，然后将图片进行黑白二值化处理，之后拼接打印数据，黑色为打印的点，白色为不打印的点。如此逐行打印图片数据。

#### 调整分辨率

```objectivec
-(UIImage*)scaleImageWithImage:(UIImage*)image width:(NSInteger)width height:(NSInteger)height
{
    CGSize size;
    size.width = width;
    size.height = height;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
```

#### 获取像素数据

- 获取图像像素可以参考[Getting the pixel data from a CGImage object](https://developer.apple.com/library/content/qa/qa1509/_index.html)；

```objectivec
-(CGContextRef)CreateARGBBitmapContextWithCGImageRef:(CGImageRef)inImage
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace =CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}
```

#### 位图模式指令

- 根据像素信息将图片进行黑白化处理，并逐行拼接打印信息

```cpp
typedef enum {
    ALPHA = 0,
    BLUE = 1,
    GREEN = 2,
    RED = 3
} PIXELS;

- (NSData *) imageToThermalData:(UIImage*)image {
    CGImageRef imageRef = image.CGImage;
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self CreateARGBBitmapContextWithCGImageRef:imageRef];
    if(!context) {
        return NULL;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    
    // Get a pointer to the data
    uint32_t *bitmapData = (uint32_t *)CGBitmapContextGetData(context);
    
    if(bitmapData) {
        
        uint8_t *m_imageData = (uint8_t *) malloc(width * height/8 + 8*height/8);
        memset(m_imageData, 0, width * height/8 + 8*height/8);
        int result_index = 0;
        
        for(int y = 0; (y + 24) < height;) {
            m_imageData[result_index++] = 27;
            m_imageData[result_index++] = 51;
            m_imageData[result_index++] = 0;
            
            m_imageData[result_index++] = 27;
            m_imageData[result_index++] = 42;
            m_imageData[result_index++] = 33;
            
            m_imageData[result_index++] = width%256;
            m_imageData[result_index++] = width/256;
            for(int x = 0; x < width; x++) {
                int value = 0;
                for (int temp_y = 0 ; temp_y < 8; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y)&255;
                    }
                }
                m_imageData[result_index++] = value;
                
                value = 0;
                for (int temp_y = 8 ; temp_y < 16; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y%8)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
                
                value = 0;
                for (int temp_y = 16 ; temp_y < 24; ++temp_y)
                {
                    uint8_t *rgbaPixel = (uint8_t *) &bitmapData[(y+temp_y) * width + x];
                    uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                    
                    if (gray < 127)
                    {
                        value += 1<<(7-temp_y%8)&255;
                    }
                    
                }
                m_imageData[result_index++] = value;
            }
            m_imageData[result_index++] = 13;
            m_imageData[result_index++] = 10;
            y += 24;
        }
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
        [data appendBytes:m_imageData length:result_index];
        free(bitmapData);
        return data;
        
    } else {
        NSLog(@"Error getting bitmap pixel data\n");
    }
    
    CGContextRelease(context);
    
    return nil ;
}
```

#### 光栅位图指令

```objectivec
#pragma mark ********************另一种打印图片的方式****************************
typedef struct ARGBPixel {
    
    u_int8_t             red;
    u_int8_t             green;
    u_int8_t             blue;
    u_int8_t             alpha;
    
} ARGBPixel ;

#pragma mark 获取打印图片数据
-(NSData *)getDataForPrintWith:(UIImage *)image{
    
    CGImageRef cgImage = [image CGImage];
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    
    NSData* bitmapData = [self getBitmapImageDataWith:cgImage];
    
    const char * bytes = bitmapData.bytes;
    
    NSMutableData * data = [[NSMutableData alloc] init];
    
    //横向点数计算需要除以8
    NSInteger w8 = width / 8;
    //如果有余数，点数+1
    NSInteger remain8 = width % 8;
    if (remain8 > 0) {
        w8 = w8 + 1;
    }
    /**
     根据公式计算出 打印指令需要的参数
     指令:十六进制码 1D 76 30 m xL xH yL yH d1...dk
     m为模式，如果是58毫秒打印机，m=1即可
     xL 为宽度/256的余数，由于横向点数计算为像素数/8，因此需要 xL = width/(8*256)
     xH 为宽度/256的整数
     yL 为高度/256的余数
     yH 为高度/256的整数
     **/
    NSInteger xL = w8 % 256;
    NSInteger xH = width / (88 * 256);
    NSInteger yL = height % 256;
    NSInteger yH = height / 256;
    
    Byte cmd[] = {0x1d,0x76,0x30,0,xL,xH,yL,yH};
    
    
    [data appendBytes:cmd length:8];
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < w8; w++) {
            u_int8_t n = 0;
            for (int i=0; i<8; i++) {
                int x = i + w * 8;
                u_int8_t ch;
                if (x < width) {
                    int pindex = h * (int)width + x;
                    ch = bytes[pindex];
                }
                else{
                    ch = 0x00;
                }
                n = n << 1;
                n = n | ch;
            }
            [data appendBytes:&n length:1];
        }
    }
    return data;
}
#pragma mark 获取图片点阵图数据
-(NSData *)getBitmapImageDataWith:(CGImageRef)cgImage{
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    NSInteger psize = sizeof(ARGBPixel);
    
    ARGBPixel * pixels = malloc(width * height * psize);
    
    NSMutableData* data = [[NSMutableData alloc] init];
    
    [self ManipulateImagePixelDataWithCGImageRef:cgImage imageData:pixels];
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            
            int pIndex = (w + (h * (u_int32_t)width));
            ARGBPixel pixel = pixels[pIndex];
            
            if ((0.3*pixel.red + 0.59*pixel.green + 0.11*pixel.blue) <= 127) {
                //打印黑
                u_int8_t ch = 0x01;
                [data appendBytes:&ch length:1];
            }
            else{
                //打印白
                u_int8_t ch = 0x00;
                [data appendBytes:&ch length:1];
            }
        }
    }
    
    return data;
}

// 获取像素信息
-(void)ManipulateImagePixelDataWithCGImageRef:(CGImageRef)inImage imageData:(void*)oimageData
{
    // Create the bitmap context
    CGContextRef cgctx = [self CreateARGBBitmapContextWithCGImageRef:inImage];
    if (cgctx == NULL)
    {
        // error creating context
        return;
    }
    
    // Get image width, height. We'll use the entire image.
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    void *data = CGBitmapContextGetData(cgctx);
    if (data != NULL)
    {
        CGContextRelease(cgctx);
        memcpy(oimageData, data, w * h * sizeof(u_int8_t) * 4);
        free(data);
        return;
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data)
    {
        free(data);
    }
    
    return;
}
```

#### 拼接图片数据，准备发给打印机

```objectivec
//打印图片
- (void)printWithImage:(UIImage *)image width:(float)width height:(float)height {
    UIImage * printImage = [self scaleImageWithImage:image width:width height:height];
    NSData *data = [self imageToThermalData:printImage];
    [self.printData appendData:data];
}
```

#### 提高图片打印速度

由于打印图片是根据像素点来逐行打印，因此数据量会远高于普通文字，这就造成了打印图片的速度回比文字慢，尤其是蓝牙打印机。解决方法可以从两个方面入手，1、增加每次发送的数据量（主要针对蓝牙打印机）；2、减少图片的数据量。

##### 增加每次发送的数据量（主要针对蓝牙打印机）；

关于这一点，在下一篇讲到蓝牙时也会说到，由于蓝牙硬件限制，每次给打印机发送的数据量是有限制的，因此要将打印数据拆分，循环发送，代码如下：

```objectivec
- (void)printLongData:(NSData *)printContent{
    NSUInteger cellMin;
    NSUInteger cellLen;
    //数据长度
    NSUInteger strLength = [printContent length];
    if (strLength < 1) {
        return;
    }
    //MAX_CHARACTERISTIC_VALUE_SIZE = 120
    NSUInteger cellCount = (strLength % MAX_CHARACTERISTIC_VALUE_SIZE) ? (strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    for (int i = 0; i < cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        NSRange rang = NSMakeRange(cellMin, cellLen);
        //        截取打印数据
        NSData *subData = [printContent subdataWithRange:rang];
        //循环写入数据
        [self.peripheral writeValue:subData forCharacteristic:self.characteristicInfo type:CBCharacteristicWriteWithResponse];
    }
}
```

这里的`MAX_CHARACTERISTIC_VALUE_SIZE`是个宏定义，表示每次发送的数据长度，经笔者测试，当`MAX_CHARACTERISTIC_VALUE_SIZE = 20`时，打印文字是正常速度。但打印图片的速度非常慢，**应该在硬件允许的范围内，每次发尽量多的数据。**不同品牌型号的打印机，这个参数是不同的，笔者的蓝牙打印机该值最多到140。超出后会出现无法打印问题。**最后笔者将该值定为`MAX_CHARACTERISTIC_VALUE_SIZE = 120`，测试了公司几台打印机都没有问题。**

另外iOS9以后增加了方法`maximumWriteValueLengthForType:`可以获取写入特诊的最大写入数据量，但经笔者测试，对于部分打印机（比如我们公司的）是不准确的，因此，不要太依赖此方法，最好还是自己取一个合适的值。

##### 减少图片的数据量

要减少图片的数据量，我们可以降低分辨率。通过研究指令集笔者发现，光栅位图的倍宽，横向分辨率降低了一倍。倍高，纵向分辨率降低了一倍。因此，笔者尝试选择倍宽、倍高模式，即m=3；此时发现打印出的图片尺寸比图片要大一倍。这样我们只要将图片的宽、高分别除以2。

比如我们要打印宽、高为250的图片。m = 3 时，打印命令改为：

```kotlin
Byte cmd[] = {0x1d,0x76,0x30,3,xL,xH,yL,yH};
```

调用时：

```objectivec
[self.printManager printWithImage:[UIImage imageNamed:@"1513654780"] width:250/2 height:250/2];
```

**经笔者测试，倍宽、倍高模式打印机图片的速度，和打印文字速度相差无几。但图片的清晰度会有所下降。究竟使用哪种，可自行权衡。**

## 使用举例

### 示例代码

这里只是简单的讲解举例，代码并没有很好的封装，我们可以根据自己的需求，封装一个适合自己的模板类。

```ruby
    self.printManager.printData.length = 0;
//    [self.printManager resetPrinter];
    
//    [self.printManager printLineSpace:50];
    [self.printManager printCharSize:MNPrintFont_2];
    [self.printManager setAlignment:MNAlignmentTypeCenter];
    [self.printManager printCharRightSpace:1];
    [self.printManager printWithContent:@"这是标题"];
    
    [self.printManager printAndNewline];
//    [self.printManager printAndGoNLine:1];
    [self.printManager printAndGoNPointLine:60];
    
    [self.printManager setAlignment:MNAlignmentTypeLeft];
    [self.printManager printCharSize:MNPrintFont_1];
    [self.printManager printWithContent:@"商品名称"];
    [self.printManager printWithContent:@"\t"];
    [self.printManager printWithContent:@"\t"];
    [self.printManager printWithContent:@"数量"];
    [self.printManager printWithContent:@"\t"];
    [self.printManager printWithContent:@"价格"];
    
    [self.printManager printAndNewline];
//    [self.printManager printAndGoNLine:1];
    [self.printManager printAndGoNPointLine:34];
    
    [self.printManager printWithContent:@"商品1"];
    [self.printManager printWithContent:@"\t\t"];
    [self.printManager printWithContent:@"2"];
    [self.printManager printWithContent:@"\t"];
    [self.printManager printWithContent:@"1999"];
    
    [self.printManager printAndNewline];
//    [self.printManager printAndGoNLine:1];
    [self.printManager printAndGoNPointLine:25];
    
    [self.printManager printWithContent:@"商品2"];
    [self.printManager printWithContent:@"\t\t"];
    [self.printManager printWithContent:@"200"];
    [self.printManager printWithContent:@"\t"];
    [self.printManager printWithContent:@"19"];
    
    [self.printManager printAndNewline];
//    [self.printManager printAndGoNLine:1];
    [self.printManager printAndGoNPointLine:25];
    
    [self.printManager printWithContent:@"商品3"];
    [self.printManager printWithContent:@"\t\t"];
    [self.printManager printWithContent:@"200"];
    [self.printManager printWithContent:@"\t"];
    [self.printManager printWithContent:@"19"];
    
    [self.printManager printAndNewline];
//    [self.printManager printAndGoNLine:2];
    [self.printManager printAndGoNPointLine:25];
    
    [self.printManager setAlignment:MNAlignmentTypeCenter];
    [self.printManager printWithContent:@"-----------------------------"];
    
    [self.printManager printAndNewline];
    //    [self.printManager printAndGoNLine:2];
    [self.printManager printAndGoNPointLine:25];
    
    [self.printManager setAlignment:MNAlignmentTypeRight];
    [self.printManager printWithContent:@"总计：11598元"];
    
    [self.printManager printAndNewline];
    [self.printManager printAndGoNPointLine:100];
    
    [self.printManager setAlignment:MNAlignmentTypeCenter];
    [self.printManager printWithImage:[UIImage imageNamed:@"1513654780"] width:200 height:200];
    
    [self.printManager printAndNewline];
    [self.printManager printAndGoNPointLine:150];
    
```

### 效果图

![Xnip2020-11-05_18-11-55](https://gitee.com/coderiding/picbed/raw/master/uPic/Xnip2020-11-05_18-11-55.jpg)

小票效果图.jpeg

## 总结

篇幅所限，这一篇先介绍通过ESC/POS打印命令集，拼接打印指令，排版打印格式。接下来的文章会介绍如何通过蓝牙或Socket将我们编辑的打印数据发送给打印机。