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
@end

@implementation LARNewWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ctView = [[LARCTDisplayView alloc] init];
    
    LARCTFrameParserConfig *config = [[LARCTFrameParserConfig alloc] init];
    config.textColor = [UIColor redColor];
    
    // 设置文字界面Frame
    CGFloat y = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.ctView.frame = CGRectMake(0, y, w, 0);
    
    // 设置文字界面宽度
    self.ctView.width = [UIScreen mainScreen].bounds.size.width;
    config.width = self.ctView.width;
    
    LARCoreTextData *data = [LARCTFrameParser paraseContent:self.words config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.ctView];
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
