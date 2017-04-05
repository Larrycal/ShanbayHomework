//
//  LARArticleViewController.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARArticleViewController.h"
#import "UIBarButtonItem+LARBarItem.h"
#import "LARCTDisplayView.h"
#import "LARArticleWordInfo.h"
#import "LARCoreTextData.h"
#import "LARCTFrameParser.h"
#import "LARCTFrameParserConfig.h"
#import "LARArticle.h"
#import "LARWord.h"


@interface LARArticleViewController ()<UIGestureRecognizerDelegate>

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
/** 月亮按钮 */
@property (strong, nonatomic) UIBarButtonItem *moonButton;
/** 滑条所在Item */
@property (strong, nonatomic) UIBarButtonItem *sliderItem;

@end

@implementation LARArticleViewController

#pragma mark - 懒加载操作
- (UIBarButtonItem *)moonButton {
    if (!_moonButton) {
        _moonButton = [UIBarButtonItem itemWithNormalImage:@"mine-moon-icon" SelectImage:@"mine-sun-icon-click" Action:@selector(moonClick:) Target:self];
    }
    return _moonButton;
}

- (UIBarButtonItem *)sliderItem {
    if (!_sliderItem) {
        
        _sliderItem = [UIBarButtonItem itemWithNumber:self.number Frame:CGRectMake(0, 0, 100, 30) Action:@selector(sliderSlide:) Target:self];
    }
    return _sliderItem;
}

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
              usingBlock:^(NSString * _Nullable substring,
                           NSRange substringRange,
                           NSRange enclosingRange, BOOL * _Nonnull stop) {
              LARWord *word;
              // 遍历nce4单词列表 中的单词，若文章中有，且等级对应则进行高亮操作
              for (int i = 0; i < _words.count; ++i) {
                  word = _words[i];
                  if ([word.word isEqualToString:substring] && (int)word.level <= (int)(_slider.value + 0.5)) {
                      UIColor *cor = LARRGB(89, 170, 154);
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
            [_article enumerateSubstringsInRange:NSMakeRange(0, [_article length])
                      options:NSStringEnumerationByWords
                      usingBlock:^(NSString * _Nullable substring,
                                   NSRange substringRange,
                                   NSRange enclosingRange, BOOL * _Nonnull stop) {
                  // 遍历nce4单词列表 中的单词，若文章中有，且等级对应则进行单词匹配操作
                  if ([NSString isEnglish:substring]) {// 不是中文则保存到单词列表
                      NSDictionary *d = @{@"word":substring};
                      [_normalStr addAttributes:d range:substringRange];
                  }
              }];
    }
    return _normalStr;
}

#pragma mark - View相关操作
/** 初始化操作 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForPopView];
    
    // 初始化View
    _ctView = [[LARCTDisplayView alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    
    // 添加两个按钮
    [self addRightButtons];


    // 设置文字界面Frame
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.ctView.frame = CGRectMake(0, 0, w, h);
    
    // 配置CT参数
    LARCTFrameParserConfig *config = [[LARCTFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.ctView.width;
    self.config = config;
    
    // 配置CT数据
    LARCoreTextData *data = [LARCTFrameParser paraseContent:self.normalStr config:config wordInfo:nil];
    data.length = [self.normalStr length];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = LARGlobalBg;
    
    // 设置ScrollView
    self.scrollView.frame = CGRectMake(0, 0, w, h - self.tabBarController.tabBar.height);
    self.scrollView.contentSize = CGSizeMake(w, data.height);
    
    // 添加视图
    [self.scrollView addSubview:_ctView];
    [self.view addSubview:self.scrollView];
    
    // 执行CTView初始操作
    [_ctView handleActiveRect];
    
    // 设置背景颜色
    self.view.backgroundColor = LARGlobalBg;
}

/** 设置导航栏标题 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"文章";
//    // 初始化月亮显示状态
//    UIButton *btn = self.moonButton.customView.subviews[0];
//    if (btn.isSelected) {
//        btn.selected = NO;
//    }
    // 显示月亮
    self.moonButton.customView.hidden = NO;
    // 隐藏滑动条
    self.sliderItem.customView.hidden = YES;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 隐藏滑动条和月亮
    self.sliderItem.customView.hidden = YES;
    self.moonButton.customView.hidden = YES;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    
    
}

/** 添加右侧按钮 */
- (void)addRightButtons {
    // 添加两个按钮,先添加的在右边
    self.tabBarController.navigationItem.rightBarButtonItems = @[self.moonButton,
                                                                 self.sliderItem
                                                                ];
}

#pragma mark - scrollView屏蔽操作
- (void)openScroll {
    // 开启滚动
    _scrollView.scrollEnabled = YES;
}

- (void)closeScroll {
    // 关闭用户滚动
    _scrollView.scrollEnabled = NO;
}

#pragma mark - 月亮和滑动条配置
- (void)moonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
//    UIBarButtonItem *slider = self.tabBarController.navigationItem.rightBarButtonItems[1];
    // 找出单词列表里面的单词
    NSLog(@"%@",self.sliderItem.customView);
    if (sender.selected) {
        // 高亮等级操作
        self.ctView.data = [LARCTFrameParser paraseContent:self.highlightStr config:_config wordInfo:nil];
        self.sliderItem.customView.hidden = NO;
    } else {
        // 显示正常操作
        self.ctView.data = [LARCTFrameParser paraseContent:self.normalStr config:_config wordInfo:nil];
        self.sliderItem.customView.hidden = YES;
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
    // 判断slider滑动的值是否改变，没有改变则不进行高亮操作
    if ([number intValue]!=[self.beforeNum intValue]) {
        self.beforeNum = number;
        self.ctView.data = [LARCTFrameParser paraseContent:self.highlightStr config:_config wordInfo:nil];
        [_ctView setNeedsDisplay];
        LARLog(@"sliderIndex:%lu",(unsigned long)index);
        LARLog(@"number:%@",number);
    }
}
#pragma mark - 通知中心操作
/** 注册通知中心 */
- (void)registerForPopView {
    // 注册popView出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewWillApper) name:popViewShow object:nil];
    // 注册popView消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewWillHide) name:popViewHide object:nil];
}

/** popView出现，屏蔽用户操作 */
- (void)popViewWillApper {
    // 禁用tabBar交互
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    // 禁用导航栏
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    // 禁用导航栏手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // 禁止滚动
    [self closeScroll];
}

/** popView出现，启动用户操作 */
- (void)popViewWillHide {
    // 启用tabBar交互
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    // 启用导航栏
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    // 启用导航栏手势
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    // 启用滚动
    [self openScroll];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.tabBarController.tabBar.isUserInteractionEnabled;
}

#pragma mark - 扫尾操作
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
