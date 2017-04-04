//
//  LARArticleViewController.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARArticleViewController.h"
#import "LARCTDisplayView.h"
#import "LARCoreTextData.h"
#import "LARCTFrameParser.h"
#import "LARCTFrameParserConfig.h"
#import "LARArticle.h"
#import "LARWord.h"
#import "UIBarButtonItem+LARBarItem.h"

@interface LARArticleViewController ()

@property (strong, nonatomic)  LARCTDisplayView *ctView;
/** ScrollView */
@property (strong, nonatomic) UIScrollView *scrollView;
/** 配置文件 */
@property (strong, nonatomic) LARCTFrameParserConfig *config;
/** 正常文章 */
@property (strong, nonatomic) NSMutableAttributedString *normalStr;
/** 高亮文字 */
@property (strong, nonatomic) NSMutableAttributedString *highlightStr;
/** 数组 */
@property (copy, nonatomic) NSArray *number;
/** 滑动条 */
@property (strong, nonatomic) UISlider *slider;
/** 变化之前的sliderNumber */
@property (assign, nonatomic) NSNumber *beforeNum;
@end

@implementation LARArticleViewController

- (NSArray *)number {
    if (!_number) {
        _number = @[@0,@1,@2,@3,@4,@5];
    }
    return _number;
}

- (NSMutableAttributedString *)highlightStr {
    
        _highlightStr = [[NSMutableAttributedString alloc] initWithString:_article];
        [_article enumerateSubstringsInRange:NSMakeRange(0, [_article length])
                                     options:NSStringEnumerationByWords
                                  usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                                      LARWord *word;
                                      for (int i = 0; i < _words.count; ++i) {
                                          word = _words[i];
                                          if ([word.word isEqualToString:substring] && (int)word.level == (int)(_slider.value + 0.5)) {
                                              UIColor *cor = [UIColor greenColor];
                                              NSDictionary *d = @{(NSString *)kCTBackgroundColorAttributeName:(id)cor.CGColor};
                                              [_highlightStr addAttributes:d range:substringRange];
                                              break;
                                          }
                                      }
                                  }];
    
    return _highlightStr;
}

- (NSMutableAttributedString *)normalStr {
    if (!_normalStr) {
        _normalStr = [[NSMutableAttributedString alloc] initWithString:_article];
    }
    return _normalStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ctView = [[LARCTDisplayView alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    
    // 设置文字界面Frame
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.ctView.frame = CGRectMake(0, 0, w, h);
    
    LARCTFrameParserConfig *config = [[LARCTFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.ctView.width;
    
    self.tabBarController.navigationItem.title = @"文章";
    // 添加两个按钮,先添加的在右边
    self.tabBarController.navigationItem.rightBarButtonItems = @[
                                                [UIBarButtonItem itemWithNormalImage:@"mine-moon-icon" SelectImage:@"mine-sun-icon-click" Action:@selector(moonClick:) Target:self], // 月亮按钮
                                                [UIBarButtonItem itemWithNumber:self.number Frame:CGRectMake(0, 0, 100, 30) Action:@selector(sliderSlide:) Target:self],
                                                ];
    
    
   
    
    LARCoreTextData *data = [LARCTFrameParser paraseContent:self.normalStr config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.frame = CGRectMake(0, 0, w, h - self.tabBarController.tabBar.height);
    self.scrollView.contentSize = CGSizeMake(w, data.height);
    [self.scrollView addSubview:_ctView];
    [self.view addSubview:self.scrollView];
    
    self.view.backgroundColor = LARGlobalBg;
    self.config = config;
}

- (void)moonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIBarButtonItem *slider = self.tabBarController.navigationItem.rightBarButtonItems[1];
    // 找出单词列表里面的单词
    if (sender.selected) {
        self.ctView.data = [LARCTFrameParser paraseContent:self.highlightStr config:_config];
        slider.customView.hidden = NO;
    } else {
        self.ctView.data = [LARCTFrameParser paraseContent:self.normalStr config:_config];
        slider.customView.hidden = YES;
    }
    [_ctView setNeedsDisplay];
}

- (void)sliderSlide:(UISlider *)slider {
    if(!_slider){
        _slider = slider;
    }
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    NSNumber *number = self.number[index];
    if ([number intValue]!=[self.beforeNum intValue]) {
        self.beforeNum = number;
        self.ctView.data = [LARCTFrameParser paraseContent:self.highlightStr config:_config];
        [_ctView setNeedsDisplay];
        LARLog(@"sliderIndex:%lu",(unsigned long)index);
        LARLog(@"number:%@",number);
    }
}

@end
