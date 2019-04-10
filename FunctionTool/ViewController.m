//
//  ViewController.m
//  FunctionTool
//
//  Created by 黄敬 on 2018/8/6.
//  Copyright © 2018年 hj. All rights reserved.
//

#import "ViewController.h"
#import "MusicWordsAninationViewController.h"
#import "PinyinViewController.h"
#import "CAReplicatorLayerViewController.h"
#import "ImageSizeViewController.h"
#import "GetImageColorViewController.h"
#import "PathViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_listArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _listArray = @[@"歌词滚动",@"汉字转拼音",@"转菊花",@"5种图片压缩方法",@"图片取色器",@"绘图"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _listArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:MusicWordsAninationViewController.new animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:PinyinViewController.new animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:CAReplicatorLayerViewController.new animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:ImageSizeViewController.new animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:GetImageColorViewController.new animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:PathViewController.new animated:YES];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
