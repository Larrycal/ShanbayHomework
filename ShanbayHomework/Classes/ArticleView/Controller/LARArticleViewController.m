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

@interface LARArticleViewController ()

@property (strong, nonatomic)  LARCTDisplayView *ctView;
/** ScrollView */
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation LARArticleViewController

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
    
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:_article];
    // 找出单词列表里面的单词
    [_article enumerateSubstringsInRange:NSMakeRange(0, [_article length])
                                 options:NSStringEnumerationByWords
                              usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                                  for (int i = 0; i < _words.count; ++i) {
                                      if ([[_words[i] valueForKey:@"word"] isEqualToString:substring]) {
                                          UIColor *cor = [UIColor greenColor];
                                          NSDictionary *d = @{(NSString *)kCTBackgroundColorAttributeName:(id)cor.CGColor};
                                          [s addAttributes:d range:substringRange];
                                      }
                                  }
    }];
    
    
    LARCoreTextData *data = [LARCTFrameParser paraseContent:s config:config];
    self.ctView.data = data;
    self.ctView.height =data.height;
    self.ctView.backgroundColor = [UIColor yellowColor];
    
    self.scrollView.frame = CGRectMake(0, 0, w, h-self.tabBarController.tabBar.height);
    self.scrollView.contentSize = CGSizeMake(w, data.height);
    [self.scrollView addSubview:_ctView];
    [self.view addSubview:self.scrollView];
}
@end
