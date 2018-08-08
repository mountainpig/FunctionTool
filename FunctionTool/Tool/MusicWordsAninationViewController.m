//
//  MusicWordsAninationViewController.m
//  FunctionTool
//
//  Created by 黄敬 on 2018/8/6.
//  Copyright © 2018年 hj. All rights reserved.
//

#import "MusicWordsAninationViewController.h"

@interface MusicWordsAninationViewController ()

@end

@implementation MusicWordsAninationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"两种实现方式";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self firstMethod];
    [self secondMethod];
}

- (void)firstMethod
{
    UILabel *backgroundView = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 40)];
    backgroundView.textColor = [UIColor redColor];
    backgroundView.font = [UIFont systemFontOfSize:30];
    backgroundView.text = @"原来你也在这里";
    backgroundView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:backgroundView];
    
    UILabel *foreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 40)];
    foreLabel.textColor = [UIColor greenColor];
    foreLabel.text = @"原来你也在这里";
    foreLabel.font = [UIFont systemFontOfSize:30];
    foreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:foreLabel];
    
    /*
     CAGradientLayer *layer = [CAGradientLayer layer];
     layer.frame = foreLabel.bounds;
     layer.colors = @[(id)[UIColor clearColor],(id)[UIColor redColor].CGColor,(id)[UIColor blackColor].CGColor,(id)[UIColor clearColor].CGColor];
     layer.locations = @[@(0.01),@(0.1),@(0.9),@(0.99)];
     layer.startPoint = CGPointMake(0, 0);
     layer.endPoint = CGPointMake(1, 0);
     foreLabel.layer.mask = layer;
     */
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = foreLabel.bounds;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    foreLabel.layer.mask = maskLayer;
    
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.translation.x";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(foreLabel.bounds.size.width);
    basicAnimation.duration = 2;
    basicAnimation.repeatCount = LONG_MAX;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [foreLabel.layer.mask addAnimation:basicAnimation forKey:nil];
}

- (void)secondMethod
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 300, 40)];
    [self.view addSubview:backgroundView];
    
    CALayer *trackLayer = [CALayer layer];
    trackLayer.bounds = backgroundView.bounds;
    trackLayer.position = CGPointMake(backgroundView.bounds.size.width / 2.0, backgroundView.bounds.size.height / 2.0);
    trackLayer.backgroundColor = [UIColor greenColor].CGColor;
    [backgroundView.layer addSublayer:trackLayer];
    
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.bounds = backgroundView.bounds;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, backgroundView.bounds.size.height / 2.0)];
    [path addLineToPoint:CGPointMake(backgroundView.bounds.size.width, backgroundView.bounds.size.height / 2.0)];
    backLayer.path = path.CGPath;
    backLayer.position = CGPointMake(backgroundView.bounds.size.width / 2.0, backgroundView.bounds.size.height / 2.0);
    backLayer.lineWidth = backgroundView.bounds.size.height;
    backLayer.strokeColor = [UIColor redColor].CGColor;
    backLayer.strokeEnd = 0;
    [trackLayer addSublayer:backLayer];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.bounds = backgroundView.bounds;
    textLayer.position = CGPointMake(backgroundView.bounds.size.width / 2.0, backgroundView.bounds.size.height / 2.0);
    textLayer.string = @"原来你也在这里";
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.wrapped = YES;
    textLayer.truncationMode = kCATruncationEnd;
    textLayer.font = CFBridgingRetain([UIFont systemFontOfSize:30].fontName);
    textLayer.fontSize = [UIFont systemFontOfSize:30].pointSize;
    textLayer.alignmentMode = kCAAlignmentCenter;
    trackLayer.mask = textLayer;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.duration = 2;
    animation2.repeatCount = MAXFLOAT;
    animation2.fromValue = @(0);
    animation2.toValue = @(1);
    [backLayer addAnimation:animation2 forKey:@"key"];
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

@end
