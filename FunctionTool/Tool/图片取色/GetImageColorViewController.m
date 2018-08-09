//
//  GetImageColorViewController.m
//  FunctionTool
//
//  Created by 黄敬 on 2018/8/9.
//  Copyright © 2018年 hj. All rights reserved.
//

#import "GetImageColorViewController.h"



@interface UIView (ColorOfPoint)
@end

@implementation UIView (ColorOfPoint)

- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    return color;
}
@end


@protocol TouchImageViewDelegate <NSObject>
- (void)touchPoint:(CGPoint)point;
@end

@interface TouchImageView : UIImageView
@property (nonatomic, weak) id <TouchImageViewDelegate> delegate;
@end

@implementation TouchImageView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate touchPoint:[[touches anyObject] locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate touchPoint:[[touches anyObject] locationInView:self]];
}
@end

@interface GetImageColorViewController ()<TouchImageViewDelegate>
{
    UIImage *_image;
    unsigned char* _data;
    UIView *_imageColorView;
    UIView *_viewColorView;
    
    TouchImageView *_imageView;
}
@end

@implementation GetImageColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"ttttt"];
    _image = image;
    [self getDataWithImage:image];
    
    TouchImageView *imageView = [[TouchImageView alloc] initWithFrame:CGRectMake(0, 84, 299, 400)];
    _imageView = imageView;
    imageView.delegate = self;
    imageView.userInteractionEnabled = YES;
    imageView.image = image;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    _imageColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 484, 140, 50)];
    [self.view addSubview:_imageColorView];
    
    _viewColorView = [[UIView alloc] initWithFrame:CGRectMake(150, 484, 140, 50)];
    [self.view addSubview:_viewColorView];
}


- (void)touchPoint:(CGPoint)point
{
    _imageColorView.backgroundColor = [self image:_image point:point];
    _viewColorView.backgroundColor = [_imageView colorOfPoint:point];
    //391 * 558
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDataWithImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    float width = CGImageGetWidth(imageRef);
    float height = CGImageGetHeight(imageRef);
    double bitmapByteCount = width * height * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(malloc(bitmapByteCount),
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    // 获取位图数据
    _data = CGBitmapContextGetData(context);
}

- (UIColor *)image:(UIImage *)image point:(CGPoint)point
{
    CGImageRef imageRef = image.CGImage;
    float width = CGImageGetWidth(imageRef);
    float height = CGImageGetHeight(imageRef);
    if (!_data) {
        double bitmapByteCount = width * height * 4;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(malloc(bitmapByteCount),
                                                     width,
                                                     height,
                                                     8,
                                                     width * 4,
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedFirst);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        // 获取位图数据
        _data = CGBitmapContextGetData(context);
    }
    
    // 根据当前所选择的点计算出对应位图数据的index
    int  offset = (round(point.y) * width + round(point.x)) * 4;
    int alpha =  _data[offset];
    int red = _data[offset+1];
    int green = _data[offset+2];
    int blue = _data[offset+3];
    
    return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
