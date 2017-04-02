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
    
    _ctView = [[LARCTDisplayView alloc] init];
    _scrollView = [[UIScrollView alloc] init];
    
    // 设置文字界面Frame
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.ctView.frame = CGRectMake(0, 0, w, h);
    
    LARCTFrameParserConfig *config = [[LARCTFrameParserConfig alloc] init];
    config.textColor = [UIColor redColor];
    config.width = self.ctView.width;
    
    LARCoreTextData *data = [LARCTFrameParser paraseContent:self.translation config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor yellowColor];
    
    self.scrollView.frame = CGRectMake(0, 0, w, h-self.tabBarController.tabBar.height);
    self.scrollView.contentSize = CGSizeMake(w, data.height);
    [self.scrollView addSubview:_ctView];
    [self.view addSubview:self.scrollView];
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
