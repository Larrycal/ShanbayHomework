//
//  LARTranslationViewController.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARTranslationViewController.h"
#import "LARCTDisplayView.h"
#import "LARCoreTextData.h"
#import "LARCTFrameParser.h"
#import "LARCTFrameParserConfig.h"

@interface LARTranslationViewController ()

/** 显示界面 */
@property (strong, nonatomic) LARCTDisplayView *ctView;
/** ScrollView */
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation LARTranslationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化操作
    _ctView = [[LARCTDisplayView alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    
    // 设置文字界面Frame
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.ctView.frame = CGRectMake(0, 0, w, h);
    
    // 进行CT配置操作
    LARCTFrameParserConfig *config = [[LARCTFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.ctView.width;
    
    // 获取翻译
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:self.translation];
    LARCoreTextData *data = [LARCTFrameParser paraseContent:s config:config wordInfo:nil];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = LARGlobalBg;
    
    // 设置ScrollView
    self.scrollView.frame = CGRectMake(0, 0, w, h - self.tabBarController.tabBar.height);
    self.scrollView.contentSize = CGSizeMake(w, data.height);
    [self.scrollView addSubview:_ctView];
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor = LARGlobalBg;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.navigationItem.title = @"翻译";
}



@end
