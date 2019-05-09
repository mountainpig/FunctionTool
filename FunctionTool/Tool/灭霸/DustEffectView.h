//
//  DustEffectView.h
//  Test
//
//  Created by hj on 2019/5/8.
//  Copyright © 2019 hj. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DustEffectView : UIView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (void)disMissWithAnimation;

@end


