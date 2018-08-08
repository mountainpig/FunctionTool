//
//  ImageSizeViewController.m
//  FunctionTool
//
//  Created by 黄敬 on 2018/8/8.
//  Copyright © 2018年 hj. All rights reserved.
//

#import "ImageSizeViewController.h"
#import <CoreImage/CoreImage.h>
#import <CoreImage/CIFilter.h>
#import <CoreImage/CIContext.h>
#import <Accelerate/Accelerate.h>

@interface ImageSizeViewController ()

@end

@implementation ImageSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"ttttt"]; //
    
    CGSize smallSize = CGSizeMake(image.size.width/2, image.size.height/2);
    
    UIImage *uikitImage = [self uikitImage:image size:smallSize];
    [self imageWithRect:CGRectMake(10, 84, 80, 80)].image = uikitImage;
    
    UIImage *coreGraphicsImage = [self coreGraphicsImage:image size:smallSize];
    [self imageWithRect:CGRectMake(10 + 90, 84, 80, 80)].image = coreGraphicsImage;
    
    UIImage *imageIOImage = [self imageIOImage:image size:smallSize];   //推荐使用
    [self imageWithRect:CGRectMake(10, 84 + 90, 80, 80)].image = imageIOImage;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{  //比较慢
        UIImage *coreImage = [self coreImage:image size:smallSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self imageWithRect:CGRectMake(10 + 90, 84 + 90, 80, 80)].image = coreImage;
        });
        
    });

    UIImage *vImage = [self vImage:image size:smallSize];
    [self imageWithRect:CGRectMake(10, 84 + 180, 180, 180)].image = vImage;
    
    /*
     Core Image表现最差。Core Graphics 和 Image I/O最好。实际上，在苹果官方在 Performance Best Practices section of the Core Image Programming Guide 部分中特别推荐使用Core Graphics或Image I / O功能预先裁剪或缩小图像。
     
     其实微信最早是使用UIKit，后来改使用ImageIO。
     
     UIKit处理大分辨率图片时，往往容易出现OOM，原因是-[UIImage drawInRect:]在绘制时，先解码图片，再生成原始分辨率大小的bitmap，这是很耗内存的。解决方法是使用更低层的ImageIO接口，避免中间bitmap产生。
     
     所以最后我比较建议和微信一样使用ImageIO。
     */

}

- (UIImageView *)imageWithRect:(CGRect)rect
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    return imageView;
}

- (void)logTime:(void (^)(void))block
{
    CFTimeInterval timeInterval = CFAbsoluteTimeGetCurrent();
    block();
    NSLog(@"%f",CFAbsoluteTimeGetCurrent() - timeInterval);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//UIKit 这种方式最简单，效果也不错，但我不太建议使用这种方式
- (UIImage *)uikitImage:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

//CoreGraphics
/*
 CoreGraphics / Quartz 2D提供了一套较低级别的API，允许进行更高级的配置。 给定一个CGImage，使用临时位图上下文来渲染缩放后的图像。
 使用CoreGraphics图像的质量与UIKit图像相同。 至少我无法察觉到任何区别，并且imagediff也没有任何区别。 表演只有不同之处。
 */
- (UIImage *)coreGraphicsImage:(UIImage *)image size:(CGSize)size
{
    CGImageRef ref = [image CGImage];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(ref);
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, CGImageGetBitsPerComponent(ref), CGImageGetBytesPerRow(ref), colorSpace, CGImageGetBitmapInfo(ref));
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGContextDrawImage(context, rect, ref);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *reslutImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return reslutImage;
}

//ImageIO
/*
 Image I / O是一个功能强大但鲜为人知的用于处理图像的框架。 独立于Core Graphics，它可以在许多不同格式之间读取和写入，访问照片元数据以及执行常见的图像处理操作。
 这个库提供了该平台上最快的图像编码器和解码器，具有先进的缓存机制，甚至可以逐步加载图像。
 */
- (UIImage *)imageIOImage:(UIImage *)image size:(CGSize)size
{
    NSData *data = UIImagePNGRepresentation(image);
    CGFloat max = MAX(size.width, size.height);
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    NSDictionary *optionDic = @{(__bridge NSString *)kCGImageSourceThumbnailMaxPixelSize:@(max),
                                (__bridge NSString *)kCGImageSourceCreateThumbnailFromImageAlways:(__bridge id)kCFBooleanTrue};
//                                (__bridge NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES;
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0,  (__bridge CFDictionaryRef)optionDic);
    UIImage *resultImge = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return resultImge;
}

//CoreImage
/*
 CoreImage是IOS5中新加入的一个Objective-c的框架，里面提供了强大高效的图像处理功能，用来对基于像素的图像进行操作与分析。IOS提供了很多强大的滤镜(Filter)，这些Filter提供了各种各样的效果，并且还可以通过滤镜链将各种效果的Filter叠加起来，形成强大的自定义效果，如果你对该效果不满意，还可以子类化滤镜。

 */
- (UIImage *)coreImage:(UIImage *)image size:(CGSize)size
{
    CGImageRef ref = [image CGImage];
    float scale = size.width/image.size.width;
    
    CIImage *ci = [[CIImage alloc] initWithCGImage:ref];
    
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setValue:ci forKey:kCIInputImageKey];
    [filter setValue:@(scale) forKey:kCIInputScaleKey];
    [filter setValue:@(1) forKey:kCIInputAspectRatioKey];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@NO}];
    CGImageRef imageRef = [context createCGImage:result fromRect:result.extent];
    UIImage *resultImge = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return resultImge;
}

//vImage
/*
 使用时需要 import Accelerate
使用CPU的矢量处理器处理大图像。 强大的图像处理功能，包括Core Graphics和Core Video互操作，格式转换和图像处理。
 这个不是很流行并且文档很少的小框架却十分强大。 结果令人惊讶。这样可以产生最佳效果，并且图像清晰平衡。 没有CG那么模糊，又不像CI那样明亮的不自然。
 */
- (UIImage *)vImage:(UIImage *)image size:(CGSize)size
{
    CGImageRef ref = [image CGImage];
    vImage_CGImageFormat format = {
        .bitsPerComponent = 8,
        .bitsPerPixel = 32,
        .colorSpace = nil,
        .bitmapInfo = (CGBitmapInfo)kCGImageAlphaFirst,
        .version = 0,
        .decode = nil,
        .renderingIntent = kCGRenderingIntentDefault,
    };
    
    vImage_Buffer sourceBuffer = {};
    vImageBuffer_InitWithCGImage(&sourceBuffer, &format, NULL, ref, kvImageNoFlags);

    size_t bytesPerPixel = CGImageGetBitsPerPixel(ref)/8;
    size_t destBytesPerRow = size.width * bytesPerPixel;
    

    vImage_Buffer  destBuffer;
    destBuffer.data = malloc(size.height * destBytesPerRow);
    destBuffer.width = size.width;
    destBuffer.height = size.height;
    destBuffer.rowBytes = destBytesPerRow;
    
    vImageScale_ARGB8888(&sourceBuffer, &destBuffer, NULL, kvImageHighQualityResampling);
    CGImageRef imageRef = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, kvImageNoFlags, nil);
    UIImage *resultImge = [UIImage imageWithCGImage:imageRef scale:0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return resultImge;
}
@end
