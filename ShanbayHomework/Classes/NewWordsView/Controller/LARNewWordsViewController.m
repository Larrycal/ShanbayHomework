//
//  LARNewWordsViewController.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARNewWordsViewController.h"
#import "LARCTDisplayView.h"
#import "LARCoreTextData.h"
#import "LARCTFrameParser.h"
#import "LARCTFrameParserConfig.h"

@interface LARNewWordsViewController ()
/** 显示界面 */
@property (strong, nonatomic) LARCTDisplayView *ctView;
/** ScrollView */
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation LARNewWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化CTView和ScrollView
    _ctView = [[LARCTDisplayView alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    
    // 设置文字界面Frame
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.ctView.frame = CGRectMake(0, 0, w, h);
    
    // 配置默认文件
    LARCTFrameParserConfig *config = [[LARCTFrameParserConfig alloc] init];
# warning 为什么使用LARRGB会导致野指针？？？疑是AutoreleasePool的原因
    config.textColor = [UIColor blackColor];
    config.width = self.ctView.width;
    
    // 初始化生词和短语
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:self.words];
    LARCoreTextData *data = [LARCTFrameParser paraseContent:s config:config wordInfo:nil];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = LARGlobalBg;
    
    // 设置ScrollView的滚动长度
    self.scrollView.frame = CGRectMake(0, 0, w, h - self.tabBarController.tabBar.height);
    self.scrollView.contentSize = CGSizeMake(w, data.height);
    
    // 设置背景色
    self.view.backgroundColor = LARGlobalBg;
    
    // 添加View
    [self.scrollView addSubview:_ctView];
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationItem.title = @"生词";
}


@end
