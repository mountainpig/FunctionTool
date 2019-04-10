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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    [self.view addSubview:imageView];
    imageView.image = [self mergeBaseImage:[UIImage imageNamed:@"base"] baseRect:imageView.bounds stickerImage:[UIImage imageNamed:@"red"] stickerRect:CGRectMake(100, 50, 42, 48) stickerTransform:CGAffineTransformMakeRotation(M_PI/4)];
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 42, 48)];
    testView.layer.borderColor = [UIColor blackColor].CGColor;
    testView.layer.borderWidth = 1;
    [imageView addSubview:testView];
    
}

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

@end
