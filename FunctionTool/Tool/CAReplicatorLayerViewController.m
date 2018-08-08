//
//  CAReplicatorLayerViewController.m
//  FunctionTool
//
//  Created by 黄敬 on 2018/8/7.
//  Copyright © 2018年 hj. All rights reserved.
//

#import "CAReplicatorLayerViewController.h"

@interface CAReplicatorLayerViewController ()
{
    UIImageView *_imageView;
    CAReplicatorLayer *_replicatorLayer;
}
@end

@implementation CAReplicatorLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CAReplicatorLayer";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [UIImageView new];
    _imageView.frame = CGRectMake(200, 200, 20, 20);
    _imageView.backgroundColor = [UIColor orangeColor];
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    _imageView.alpha = 0;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds = self.view.bounds;
    replicatorLayer.position = self.view.center;
    replicatorLayer.preservesDepth = YES;
    [replicatorLayer addSublayer:_imageView.layer];
    [self.view.layer addSublayer:replicatorLayer];
    _replicatorLayer = replicatorLayer;
    
    CGFloat count = 15;
    _replicatorLayer.instanceDelay = 1.0 / count;
    _replicatorLayer.instanceCount = count;
    _replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) / count, 0, 0, 1.0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.duration = 1;
    animation2.repeatCount = MAXFLOAT;
    animation2.fromValue = @(1);
    animation2.toValue = @(0);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1;
    animationGroup.repeatCount = MAXFLOAT;//HUGE_VALF;
    [animationGroup setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    [_imageView.layer addAnimation:animationGroup forKey:@"animationGroup"];
    
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
