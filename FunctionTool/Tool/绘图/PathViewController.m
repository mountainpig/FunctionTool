//
//  PathViewController.m
//  FunctionTool
//
//  Created by hj on 2019/4/10.
//  Copyright © 2019 hj. All rights reserved.
//

#import "PathViewController.h"


@interface PathViewController ()

@end

@implementation PathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view.layer addSublayer:self.pathLayer];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addImageDraw];
    [self addArrow];
}

- (void)addImageDraw
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    [self.view addSubview:imageView];
    imageView.image = [self mergeBaseImage:[UIImage imageNamed:@"base"] baseRect:imageView.bounds stickerImage:[self closeImageWithSize:CGSizeMake(50, 50) lineWith:1.5 color:[UIColor greenColor]] stickerRect:CGRectMake(100, 50, 50, 50) stickerTransform:CGAffineTransformMakeRotation(M_PI/5)];
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 50, 50)];
    testView.layer.borderColor = [UIColor blackColor].CGColor;
    testView.layer.borderWidth = 1;
    [imageView addSubview:testView];
}

- (void)addArrow
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
    [self.view addSubview:imageView];
    imageView.image = [self arrowImageWithSize:CGSizeMake(50, 50) direction:ArrowDirectionRight lineWith:10
                                         color:[UIColor redColor]];
}


#pragma mark -
- (CAShapeLayer *)pathLayer
{
    CGRect myRect = CGRectMake(100,100,200, 200);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,200, 200)cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100,100,100,100) cornerRadius:50];
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10,10,20, 20)cornerRadius:0];
    [path appendPath:rectPath];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.frame = myRect;
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    //    fillLayer.opacity =0.5;
    return fillLayer;
    
}

#pragma mark -
- (UIImage *)mergeBaseImage:(UIImage *)baseImage baseRect:(CGRect)baseRect stickerImage:(UIImage *)stickerImage stickerRect:(CGRect)stickerRect stickerTransform:(CGAffineTransform)stickerTransform {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(baseRect.size.width, baseRect.size.height), NO, 0.0);
    [baseImage drawInRect:baseRect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat angle = atan2(stickerTransform.b, stickerTransform.a);
    
    float orginX = CGRectGetMidX(stickerRect);
    float orginY = CGRectGetMidY(stickerRect);
    float length = sqrt(orginX * orginX + orginY * orginY);
    CGFloat rads = -acos(orginX/length) - angle;
    float newX = cos(rads) * length;
    float newY = -sin(rads) * length;
    
    CGContextTranslateCTM(context, orginX - newX, orginY - newY);
    CGContextRotateCTM(context, angle);
    [stickerImage drawInRect:stickerRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//返回叉按钮图片
- (UIImage *)closeImageWithSize:(CGSize)size lineWith:(CGFloat)lineWith color:(UIColor *)color
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = nil;
    shapeLayer.frame = CGRectMake(0, 0, size.width, size.height);
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineCap = kCALineJoinRound;
    shapeLayer.lineWidth = lineWith;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path moveToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    shapeLayer.path = path.CGPath;
    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
    [shapeLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return layerImage;
}


typedef NS_ENUM(NSUInteger, ArrowDirection) {
    ArrowDirectionRight,
    ArrowDirectionLeft,
    ArrowDirectionTop,
    ArrowDirectionBottom,
};


//返回箭头图片
- (UIImage *)arrowImageWithSize:(CGSize)size direction:(ArrowDirection)direction lineWith:(CGFloat)lineWith color:(UIColor *)color
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = nil;
    shapeLayer.frame = CGRectMake(0, 0, size.width, size.height);
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineCap = kCALineJoinRound;
    shapeLayer.lineWidth = lineWith;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint firstPoint;
    CGPoint midPoint;
    CGPoint endPoint;
    
    switch (direction) {
        case ArrowDirectionRight:
        {
            firstPoint = CGPointMake(lineWith/2, lineWith/2);
            midPoint = CGPointMake(size.width - lineWith/2, size.height/2);
            endPoint = CGPointMake(lineWith/2, size.height - lineWith/2);
        }
            break;
        case ArrowDirectionLeft:
        {
            firstPoint = CGPointMake(size.width - lineWith/2, lineWith/2);
            midPoint = CGPointMake(lineWith/2, size.height/2);
            endPoint = CGPointMake(size.width - lineWith/2, size.height - lineWith/2);
        }
            
            break;
        case ArrowDirectionTop:
        {
            firstPoint = CGPointMake(lineWith/2, size.height - lineWith/2);
            midPoint = CGPointMake(size.width/2, lineWith/2);
            endPoint = CGPointMake(size.width - lineWith/2, size.height - lineWith/2);
        }
            break;
        case ArrowDirectionBottom:
        {
            firstPoint = CGPointMake(lineWith/2, lineWith/2);
            midPoint = CGPointMake(size.width/2, size.height - lineWith/2);
            endPoint = CGPointMake(size.width - lineWith/2, lineWith/2);
        }
            break;
            
        default:
            break;
    }
    
    [path moveToPoint:firstPoint];
    [path addLineToPoint:midPoint];
    [path moveToPoint:midPoint];
    [path addLineToPoint:endPoint];
    shapeLayer.path = path.CGPath;
    
    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
    [shapeLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return layerImage;
}
@end
