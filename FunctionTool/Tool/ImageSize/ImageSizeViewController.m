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
//UIKit
- (UIImage *)uikitImage:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

//CoreGraphics
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
