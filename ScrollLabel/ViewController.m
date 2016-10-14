//
//  ViewController.m
//  ScrollLabel
//
//  Created by zhao on 16/6/24.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollTextView.h"
#import "ScrollLabelView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CycleScrollTextView *textView_short;
@property (weak, nonatomic) IBOutlet CycleScrollTextView *textView_long;

@property (strong, nonatomic)  ScrollLabelView *labelView_short;
@property (strong, nonatomic)  ScrollLabelView *labelVIew_long;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.textView_long.text = @"我是能滚动的长Label, 那你滚个给我看看";
    self.textView_short.text = @"我是不能滚动Label";
    // 重新进入前台
    [self.textView_long addCycleScrollObserverNotification];
    [self.textView_short addCycleScrollObserverNotification];
    
    
    [self.view addSubview:self.labelView_short];
    // 重新进入前台
    [self.labelView_short addObaserverNotification];
    [self.view addSubview:self.labelVIew_long];
    // 重新进入前台
    [self.labelVIew_long addObaserverNotification];
}

- (ScrollLabelView *)labelVIew_long
{
    if(!_labelVIew_long)
    {
        _labelVIew_long = [[ScrollLabelView alloc] initWithFrame:CGRectMake(36, 360, 325, 46)];
        _labelVIew_long.backgroundColor = [UIColor darkGrayColor];
        _labelVIew_long.text = @"人终有一死，而有些人则需要一点小小的帮助";
    }
    return _labelVIew_long;
}

- (ScrollLabelView *)labelView_short
{
    if(!_labelView_short)
    {
        _labelView_short = [[ScrollLabelView alloc] initWithFrame:CGRectMake(74, 300, 251, 46)];
        _labelView_short.backgroundColor = [UIColor darkGrayColor];
        _labelView_short.text = @"费雷尔卓德必将重建";
    }
    return _labelView_short;
}

@end
