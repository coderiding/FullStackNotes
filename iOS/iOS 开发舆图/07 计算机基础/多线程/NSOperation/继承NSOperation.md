```objectivec
自定义 NSOperation

如果是自定义的 Operation ，需要继承 NSOperation ，且需要将操作写到自定义类的 main 方法中
这种实现方式，可以提高代码的复用性（可以将写在 block 中的代码写在 main 函数内部）
调用自定义 Operation

自定义 Operation （只是重写 main 方法，表示为非并发）

MitchellOperation*op = [[MitchellOperation alloc]init];  
[op start];// 因为是继承 NSOperation ，所以有 start 方法  

// 把需要实现的代码放在 main 函数内

#import "MitchellOperation.h"  
@implementation MitchellOperation  
-(void)main{  
    // 在这里自定义耗时的操作  
    NSLog(@"%s%@",__func__,[NSThread currentThread]);  
}  
@end  

自定义 Operation 例 2 （只是重写 main 方法，表示为非并发）

@implementation MyOperation  
- (void)main {  
    @autoreleasepool {  
        if (self.isCancelled) return;  
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];  
        if (self.isCancelled) { imageData = nil; return; }  
        if (imageData) {  
            UIImage *downloadedImage = [UIImage imageWithData:imageData];  
        }  
        imageData = nil;  
        if (self.isCancelled) return;  
        [self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:)  
        withObject:downloadedImage  
        waitUntilDone:NO];  
    }  
}  
- (void)imageDownloaderDidFinish{  

}  
@end
```