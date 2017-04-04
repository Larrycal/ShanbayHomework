//
//  LARTabBarViewController.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARTabBarViewController.h"
#import "LARArticleViewController.h"
#import "LARNewWordsViewController.h"
#import "LARTranslationViewController.h"
#import "LARArticle.h"
#import "LARAllWords.h"

@interface LARTabBarViewController ()

@end

@implementation LARTabBarViewController

- (instancetype)initWithAriticle:(LARArticle *)article Words:(LARAllWords *)words{
    if (self = [super init]) {
        self.article = article;
        self.words = words;
        [self loadData];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)loadData {
    /** 添加子控制器 */
    LARArticleViewController *articleVC = [[LARArticleViewController alloc] init];
    articleVC.article = [_article.title stringByAppendingFormat:@"\r\n%@",_article.article];
    articleVC.words = _words.allWords;
    
    [self setUpChildVC:articleVC Title:@"文章" Image:@"tabBar_essence_icon" SelectImage:@"tabBar_essence_click_icon"];
    
    LARNewWordsViewController *newWordsVC = [[LARNewWordsViewController alloc] init];
    newWordsVC.words = _article.words;
    [self setUpChildVC:newWordsVC Title:@"生词" Image:@"tabBar_new_icon" SelectImage:@"tabBar_new_click_icon"];
    
    LARTranslationViewController *translationVC = [[LARTranslationViewController alloc] init];
    translationVC.translation = _article.translation;
    [self setUpChildVC:translationVC Title:@"翻译" Image:@"tabBar_friendTrends_icon" SelectImage:@"tabBar_me_click_icon"];

}
/**
 * 添加子控制器
 */
- (void)setUpChildVC:(UIViewController *)vc Title:(NSString *)title Image:(NSString *)image SelectImage:(NSString *)selectImage {
    
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    
    // 设置导航栏颜色
    [self addChildViewController:vc];
}


@end
