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
    // Do any additional setup after loading the view.
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 40)];
    backLabel.textColor = [UIColor redColor];
    backLabel.font = [UIFont systemFontOfSize:30];
    backLabel.text = @"原来你也在这里";
    backLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:backLabel];
    
    UILabel *foreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 40)];
    foreLabel.textColor = [UIColor whiteColor];
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
