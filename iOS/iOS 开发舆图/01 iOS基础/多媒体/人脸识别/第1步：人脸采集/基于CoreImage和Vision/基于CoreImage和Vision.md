自从 iOS 5（大概在2011年左右）之后，iOS 开始支持人脸识别，只是用的人不多。人脸识别 API 让开发者不仅可以进行人脸检测，还能识别微笑、眨眼等表情。

Vision 是 Apple 在 WWDC 2017 推出的图像识别框架，它基于 Core ML，所以可以理解成 Apple 的工程师设计了一种算法模型，然后利用 Core ML 训练，最后整合成一个新的框架。


```objectivec
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KRFaceDetectResolutionType) {
    KRFaceDetectResolutionTypeCoreImage,//静态图像人脸识别
    KRFaceDetectResolutionTypeOpenCV,
    KRFaceDetectResolutionTypeVision,
    KRFaceDetectResolutionTypeAVFoundation//动态人脸识别
};

@interface KRFaceDetectTool : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithType:(KRFaceDetectResolutionType)type;

- (void)testForDetectFace;

- (BOOL)detectFaceWithImage:(UIImage*)image;

@end
NS_ASSUME_NONNULL_END

#import "KRFaceDetectTool.h"

#import <CoreImage/CIDetector.h>
#import "KRCVFaceDetectTool.h"
#import <Vision/Vision.h>
#import "KRGCDExtension.h"

@interface KRFaceDetectTool ()
@property (nonatomic, assign) KRFaceDetectResolutionType type;

//CoreImage
@property (nonatomic, strong) CIDetector *ciDetector;
@property (nonatomic, strong) KRCVFaceDetectTool *cvDetector;
@property (nonatomic, strong) VNImageBasedRequest *visionFaceDetectRequest;

@end

@implementation KRFaceDetectTool

- (instancetype)init {
    NSAssert(NO, @"Please use the given initial method !");
    return nil;
}

+ (instancetype)new {
    NSAssert(NO, @"Please use the given initial method !");
    return nil;
}

- (instancetype)initWithType:(KRFaceDetectResolutionType)type
{
    self = [super init];
    if (self) {
        _type = type;
        [self prepareToDetectWithType:type];
    }
    return self;
}

- (void)dealloc {
    if (self.ciDetector) {
        self.ciDetector = nil;
    }
    if (self.cvDetector) {
        self.cvDetector = nil;
    }
}

- (void)prepareToDetectWithType:(KRFaceDetectResolutionType)type {
    switch (type) {
        case KRFaceDetectResolutionTypeCoreImage:
        {
            if (!self.ciDetector) {
                NSDictionary *options = @{CIDetectorAccuracy:CIDetectorAccuracyLow};
                self.ciDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
            }
        }
            break;
        case KRFaceDetectResolutionTypeVision:
        {
            void (^completionHandler)(VNRequest *, NSError * _Nullable) = ^(VNRequest *request, NSError * _Nullable error) {
                NSArray *observations = request.results;
                if (request.results.count > 0) {
                    NSLog(@"KRFaceDetectTool: has face!");
                } else {
                    NSLog(@"KRFaceDetectTool: no face!");
                }
            };
            
            self.visionFaceDetectRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:completionHandler];
        }
            break;
        case KRFaceDetectResolutionTypeOpenCV:
        {
            if (!self.cvDetector) {
                self.cvDetector = [[KRCVFaceDetectTool alloc] initWithType:KRCVFaceXMLTypeHaarcascadeFrontalfaceAlt];
            }
        }
            break;
        case KRFaceDetectResolutionTypeAVFoundation:
        {
            
        }
            break;
        default:
            break;
    }
}

- (BOOL)detectFaceWithImage:(UIImage*)image{
    switch (self.type) {
        case KRFaceDetectResolutionTypeCoreImage:
        {
            CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage];
            NSArray *features = [self.ciDetector featuresInImage:ciImage];
            if (features.count) {
                return YES;
            }
            return NO;
        }
            break;
        case KRFaceDetectResolutionTypeVision:
        {
            VNImageRequestHandler *visionRequestHandler = [[VNImageRequestHandler alloc] initWithCGImage:image.CGImage options:@{}];
            
            [visionRequestHandler performRequests:@[self.visionFaceDetectRequest] error:nil];
            
        }
            break;
        case KRFaceDetectResolutionTypeOpenCV:
        {
            [self.cvDetector detectFaceWithImage:image];
        }
            break;
        case KRFaceDetectResolutionTypeAVFoundation:
        {
            
        }
            break;
        default:
            break;
    }
    return NO;
}

- (void)testForDetectFace {
    [self prepareToDetectWithType:KRFaceDetectResolutionTypeCoreImage];
    [self prepareToDetectWithType:KRFaceDetectResolutionTypeOpenCV];
    [self prepareToDetectWithType:KRFaceDetectResolutionTypeVision];
    [self prepareToDetectWithType:KRFaceDetectResolutionTypeAVFoundation];
    
    UIImage *testImage = [UIImage imageNamed:@"test_1080x1920.JPG"] ;
    UIImage *testImage2 = [UIImage imageNamed:@"test_3024x3024.JPG"];
    //    testImage2 = [testImage2 imageByRotateLeft90];
    
    void (^coreImageHighAccuracyBlock)(void) = ^{
        @autoreleasepool {
            CIImage *ciImage = [[CIImage alloc] initWithCGImage:testImage.CGImage];
            NSArray *features = [self.ciDetector featuresInImage:ciImage];
            if (features.count) {
                NSLog(@"KRFaceDetectTool: has face!");
            } else {
                NSLog(@"KRFaceDetectTool: no face!");
            }
        }
    };
    
    void (^cvDetectBlock)(void) = ^{
        @autoreleasepool {
            BOOL result = [self.cvDetector detectFaceWithImage:testImage];
            NSLog(@"KRFaceDetectTool: %@",result ? @"has face!": @"no face!");
        }
    };
    
    
    void (^visionDetectBlock)(void) = ^{
        VNImageRequestHandler *visionRequestHandler = [[VNImageRequestHandler alloc] initWithCGImage:testImage.CGImage options:@{}];
        [visionRequestHandler performRequests:@[self.visionFaceDetectRequest] error:nil];
    };
    
    int64_t result = kr_dispatch_benchmark(100, coreImageHighAccuracyBlock);
    NSLog(@"KRFaceDetectTool:xxx coreImageHighAccuracyBlock cost time:%lld",result);

    int64_t result2 = kr_dispatch_benchmark(100, cvDetectBlock);
    NSLog(@"KRFaceDetectTool:xxx cvDetectBlock cost time:%lld",result2);

    int64_t result3 = kr_dispatch_benchmark(100, visionDetectBlock);
    NSLog(@"KRFaceDetectTool:xxx visionDetectBlock cost time:%lld",result3);

}

@end
```