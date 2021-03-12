OpenCV 起始于 1999 年 Intel 的一个内部研究项目。从那时起，它的开发就一直很活跃。进化到现在，它已支持如 OpenCL 和 OpenGL 等现代技术，也支持如 iOS 和 Android 等平台。


```objectivec
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//OpenCV
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KRCVFaceXMLType) {
    KRCVFaceXMLTypeHaarcascadeFrontalfaceAlt,//对应opencv人脸识别xml的文件类型
    KRCVFaceXMLTypeHaarcascadeFrontalfaceAlt2
};

@interface KRCVFaceDetectTool : NSObject
{
    cv::CascadeClassifier faceDetector;
}

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithType:(KRCVFaceXMLType)type;

- (BOOL)detectFaceWithImage:(UIImage*)image;

@end
NS_ASSUME_NONNULL_END

#import "KRCVFaceDetectTool.h"

@implementation KRCVFaceDetectTool

- (instancetype)initWithType:(KRCVFaceXMLType)type
{
    self = [super init];
    if (self) {
        [self prepareForDetectInOpenCV:type];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)prepareForDetectInOpenCV:(KRCVFaceXMLType)type {
    switch (type) {
        case KRCVFaceXMLTypeHaarcascadeFrontalfaceAlt:
        {
            NSString* cascadePath = [[NSBundle mainBundle]
                                     pathForResource:@"haarcascade_frontalface_alt"
                                     ofType:@"xml"];
            faceDetector.load([cascadePath UTF8String]);
        }
            break;
        case KRCVFaceXMLTypeHaarcascadeFrontalfaceAlt2:
        {
            NSString* cascadePath = [[NSBundle mainBundle]
                                     pathForResource:@"haarcascade_frontalface_alt2"
                                     ofType:@"xml"];
            faceDetector.load([cascadePath UTF8String]);
        }
            break;
        default:
            break;
    }
}

- (BOOL)detectFaceWithImage:(UIImage*)image {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    if (!cvImage.empty()) {
        //转换为灰度图
        cv::Mat gray;
        cvtColor(cvImage, gray, CV_BGR2GRAY);
        
        //人脸检测
        std::vector<cv::Rect> faces;
        faceDetector.detectMultiScale(gray,
                                      faces,
                                      1.1,
                                      1,
                                      0|CV_HAAR_SCALE_IMAGE,
                                      cv::Size(100,100)
                                      );
        
        if (faces.size() > 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end

* benchmark方法 

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C"
#endif
extern int64_t kr_dispatch_benchmark(size_t count, void (^block)(void));

NS_ASSUME_NONNULL_END

 
#import "KRGCDExtension.h"

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

int64_t kr_dispatch_benchmark(size_t count, void (^block)(void)) {
    return dispatch_benchmark(count, block);
} 
```