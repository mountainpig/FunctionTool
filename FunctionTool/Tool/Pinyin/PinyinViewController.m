//
//  PinyinViewController.m
//  FunctionTool
//
//  Created by 黄敬 on 2018/8/6.
//  Copyright © 2018年 hj. All rights reserved.
//

#import "PinyinViewController.h"


@interface PinyinManager : NSObject
@property (nonatomic, strong) NSDictionary *dict;
@end

@implementation PinyinManager

+ (instancetype)shareInstance
{
    static PinyinManager *shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pinyin" ofType:@"plist"];
        shareManager.dict = [NSDictionary dictionaryWithContentsOfFile:path];
    });
    return shareManager;
}

- (NSArray *)getPinyinArrayWithChar:(unichar)ch
{
    int codePointOfChar = ch;
    NSString *codepointHexStr = [[NSString stringWithFormat:@"%x",codePointOfChar] uppercaseString];
    NSString *pinyinRecord = [self.dict objectForKey:codepointHexStr];
    if (pinyinRecord) {
        return [pinyinRecord componentsSeparatedByString:@","];
    }
    return nil;
}

- (NSString *)pinyinForString:(NSString *)str
{
    NSMutableString *pinStr = [[NSMutableString alloc] init];
    for (int i = 0; i < str.length; i++) {
        NSArray *array = [self getPinyinArrayWithChar:[str characterAtIndex:i]];
        NSString *text;
        if (array.count) {
            text = [array firstObject];
        } else {
            text = [[str substringWithRange:NSMakeRange(i, 1)] lowercaseString];
        }
        [pinStr appendString:text];
    }
    return pinStr;
}

- (NSString *)systemPinyinForString:(NSString *)str
{
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (CFMutableStringRef)[NSMutableString stringWithString:str]);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *result = [(__bridge  NSMutableString *)string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 32] withString:@""];
    CFRelease(string);
    return result;
}

@end

@interface PinyinViewController ()

@end

@implementation PinyinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *str = @"这段文字是用来测试拼音转换所用的时间,北京上海广州,发动发动妇女豆腐豆腐";

    PinyinManager *shareInstance = [PinyinManager shareInstance];
    
    CFTimeInterval timeInterval = CFAbsoluteTimeGetCurrent();
    NSString *text1 = [shareInstance pinyinForString:str];
    CFTimeInterval space = CFAbsoluteTimeGetCurrent() - timeInterval;
    NSLog(@"%@ %f",text1,space);
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150,CGRectGetWidth(self.view.frame), 140)];
    backLabel.textColor = [UIColor redColor];
    backLabel.font = [UIFont systemFontOfSize:15];
    backLabel.text = [NSString stringWithFormat:@"%f",space];
    backLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:backLabel];
    
    
    timeInterval = CFAbsoluteTimeGetCurrent();
    NSString *text2 = [shareInstance systemPinyinForString:str];
    space = CFAbsoluteTimeGetCurrent() - timeInterval;
    NSLog(@"%@ %f",text2,space);
    

    backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150 + 140,CGRectGetWidth(self.view.frame), 140)];
    backLabel.textColor = [UIColor redColor];
    backLabel.font = [UIFont systemFontOfSize:15];
    backLabel.text = [NSString stringWithFormat:@"%f",space];
    backLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:backLabel];
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
