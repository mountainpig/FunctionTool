//
//  DustEffectView.m
//  Test
//
//  Created by hj on 2019/5/8.
//  Copyright © 2019 hj. All rights reserved.
//

#import "DustEffectView.h"

@interface DustEffectView ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@end

@implementation DustEffectView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    self.layer.contents = (id)image.CGImage;
    self.image = image;
    self.imagesArray = [self imagesWithImage:image];
    return self;
}

- (void)disMissWithAnimation
{
    self.layer.contents = nil;
    for (NSInteger i = 0; i < self.imagesArray.count; i++) {
        CALayer *layer = [CALayer layer];
        UIImage *image = self.imagesArray[i];
        layer.contents = (id)image.CGImage;
        layer.frame = self.bounds;
        [self.layer addSublayer:layer];
        [self disMissWithLayer:layer index:i];
    }
}

- (void)disMissWithLayer:(CALayer *)layer index:(NSInteger)index
{
    float centerX = layer.position.x;
    float centerY = layer.position.y;
    
    float radian1 = M_PI_4/3 * [self randomNumber];
    float radian2 = M_PI_4/3 * [self randomNumber];
    float random = M_PI * 2 * [self randomNumber];
    float transX = 30 * cos(random);
    float transY = 15 * sin(random);
    
    float realTransX = transX * cos(radian1) - transY * sin(radian1);
    float realTransY = transY * cos(radian1) + transX * sin(radian1);
    CGPoint realEndPoint = CGPointMake(centerX + realTransX, centerY + realTransY);
    CGPoint controlPoint = CGPointMake(centerX + transX, centerY + transY);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:layer.position];
    [path addQuadCurveToPoint:realEndPoint controlPoint:controlPoint];
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path = path.CGPath;
    moveAnimation.calculationMode = kCAAnimationPaced;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.toValue = @(radian1 + radian2);
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.toValue = @(0.0);
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[moveAnimation,rotateAnimation,fadeOutAnimation];
    group.duration = 1;
    group.beginTime = CACurrentMediaTime() + (1.35 * index)/self.imagesArray.count;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [layer addAnimation:group forKey:nil];
}

- (float)randomNumber
{
    CGFloat result = (arc4random() % 500);
    result = result/1000.0;
    result =  arc4random() % 2 == 0 ? result : -result;
    return result;
}


- (NSMutableArray *)imagesWithImage:(UIImage *)image
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    CGImageRef imageRef = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    float width = image.size.width;
    float height = image.size.height;
    double bitmapByteCount = width * height * 4;
//    uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst;
    
    uint32_t bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little;
    /*
     CGContextRef context = CGBitmapContextCreate(nil,
     width,
     height,
     CGImageGetBitsPerComponent(imageRef),
     CGImageGetBytesPerRow(imageRef),
     CGImageGetColorSpace(imageRef),
     CGImageGetBitmapInfo(imageRef));
     */
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorSpace,
                                                 bitmapInfo);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    unsigned char *data = CGBitmapContextGetData(context);
    
    void *space = malloc(bitmapByteCount);
    space = nil;
    
    int imagesCount = 32;
    unsigned char *ttttArr[imagesCount];
    for (int i = 0; i < imagesCount; i++) {
        ttttArr[i] = malloc(bitmapByteCount);
    }
    
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < height; j++) {
            int offsst = (j * width + i) * 4;
            NSInteger index = arc4random() % imagesCount;
            unsigned char *tdata = ttttArr[index];
            tdata[offsst] = data[offsst];
            tdata[offsst + 1] = data[offsst + 1];
            tdata[offsst + 2] = data[offsst + 2];
            tdata[offsst + 3] = data[offsst + 3];
        }
    }
    
    for (int i = 0; i < imagesCount; i++) {
        void *dataBytes = ttttArr[i];
        CGContextRef tcontext = CGBitmapContextCreate(dataBytes,
                                                      width,
                                                      height,
                                                      8,
                                                      width * 4,
                                                      colorSpace,
                                                      bitmapInfo);
        UIImage *timage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(tcontext) scale:image.scale orientation:image.imageOrientation];
        [arr addObject:timage];
    }
    return arr;
}


@end
