//
//  ScrollLabelView.m
//  ScrollLabel
//
//  Created by zhao on 16/9/10.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "ScrollLabelView.h"

static void each_object(NSArray *objects, void (^block)(id object))
{
    for(id obj in objects){
        block(obj);
    }
}
//宏定义 给Label的属性赋值
#define EACH_LABEL(ATTRIBUTE, VALUE) each_object(self.labels, ^(UILabel *label) {label.ATTRIBUTE = VALUE; })
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface ScrollLabelView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) UILabel *mainLabel; /**< 没滚动就能看到的Label*/


@end

@implementation ScrollLabelView

- (instancetype)init
{
    if([super init])
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if([super initWithCoder:aDecoder])
    {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.textFont = [UIFont systemFontOfSize:25];
    self.textColor = [UIColor whiteColor];
    
    self.velocity = 30.0;
    self.space = 25;
    self.pauseTimeIntervalBeforeScroll = 2;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self addSubview:self.scrollView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 滚动设置

- (void)setText:(NSString *)theText
{
    if([self.text isEqualToString:theText]) return;
    
    _text = theText;
    EACH_LABEL(text, theText);
    EACH_LABEL(font, self.textFont);
    EACH_LABEL(textColor, self.textColor);
    
    [self refreshLabelsFrame:theText];
}

/**
 *  根据Label的内容更新Label的frame
 */
- (void)refreshLabelsFrame:(NSString *)labelText
{
    if(labelText.length == 0) return;
    
    CGSize labelSize = [labelText boundingRectWithSize:CGSizeMake(MAXFLOAT, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textFont} context:nil].size;
    __block CGFloat offset = 0;
    
    each_object(self.labels, ^(UILabel *label) {
        
        CGFloat labelWidth = (labelSize.width+10) > WIDTH ? labelSize.width + self.space : WIDTH;
        label.frame = CGRectMake(offset, 0, labelWidth, HEIGHT);
        offset += labelWidth;
    });
    
    self.scrollView.contentSize = CGSizeZero;
    [self.scrollView.layer removeAllAnimations];
    
    if(labelSize.width + 10 > WIDTH)
    {
        self.scrollView.contentSize = CGSizeMake(WIDTH + self.space + CGRectGetWidth(self.mainLabel.frame), HEIGHT);
        
        [self scrollLabelIfNeed];
    }
    else
    {
        EACH_LABEL(hidden, (self.mainLabel != label));
        self.scrollView.contentSize = self.bounds.size;
        [self.scrollView.layer removeAllAnimations];
    }
}

/**
 *  循环滚动Label
 */
- (void)scrollLabelIfNeed
{
    NSTimeInterval duration = (CGRectGetWidth(self.mainLabel.frame) - WIDTH)/self.velocity;
    [self.scrollView.layer removeAllAnimations];
    //重置contentOffset 否则不会循环滚动
    self.scrollView.contentOffset = CGPointZero;
    
    [UIView animateWithDuration:duration delay:self.pauseTimeIntervalBeforeScroll options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mainLabel.frame), 0);
    } completion:^(BOOL finished) {
        if(finished)
        {
            [self performSelector:@selector(scrollLabelIfNeed) withObject:nil];
        }
    }];
}

#pragma mark -- 进入后台 前台

- (void)addObaserverNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //活跃状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollLabelIfNeed) name:UIApplicationDidBecomeActiveNotification object:nil];
    //即将进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollLabelIfNeed) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark --  getter

- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray *)labels
{
    if(!_labels)
    {
        _labels = [[NSMutableArray alloc] init];
        for(int i=0; i<2; i++)
        {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            [self.labels addObject:label];
            [self.scrollView addSubview:label];
        }
    }
    return _labels;
}

- (UILabel *)mainLabel
{
    return self.labels[0];
}

@end
