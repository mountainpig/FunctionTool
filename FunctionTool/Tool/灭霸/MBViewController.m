//
//  MBViewController.m
//  FunctionTool
//
//  Created by hj on 2019/5/9.
//  Copyright © 2019 hj. All rights reserved.
//

#import "MBViewController.h"
#import "DustEffectView.h"

@interface MBViewController ()
@property (nonatomic, strong) CALayer *animationLayer;
@property (nonatomic, strong) DustEffectView *testView;
@end

@implementation MBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self addLayer];
    UIImage *image = [UIImage imageNamed:@"home_activity_prize"];
    float width = image.size.width/5;
    float height = image.size.height/5;
    
    DustEffectView *testView = [[DustEffectView alloc] initWithFrame:CGRectMake(100, 100 + height, width, height) image:image];
    [self.view addSubview:testView];
    self.testView = testView;
}

- (void)addLayer
{
    UIImage *image = [UIImage imageNamed:@"thanos_snap"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(80, 80, 80, 80);
    [self.view addSubview:button];
    
    CALayer *layer = [CALayer layer];
    layer.masksToBounds = YES;
    layer.contents = (id)image.CGImage;
    layer.contentsGravity = kCAGravityLeft;
    layer.frame = CGRectMake(0, 0, 80, 80);
    [button.layer addSublayer:layer];
    self.animationLayer = layer;
    
}

- (void)buttonClick
{
    UIImage *image = [UIImage imageNamed:@"thanos_snap"];
    int count = image.size.width / 80;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (float i = 0; i < count; i++) {
        [arr addObject:@(i/count)];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contentsRect.origin.x"];
    animation.values = arr;
    animation.duration = 2.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.calculationMode = kCAAnimationDiscrete;
    //    animation.repeatCount = CGFLOAT_MAX;
    [self.animationLayer addAnimation:animation forKey:nil];
    
    self.testView.layer.contents = (id)[UIImage imageNamed:@"home_activity_prize"].CGImage;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.testView disMissWithAnimation];
    });
    
    
}


@end
