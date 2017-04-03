//
//  LARTabBarViewController.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LARArticle;
@class LARAllWords;
@interface LARTabBarViewController : UITabBarController

/** 文章 */
@property (strong, nonatomic) LARArticle *article;
/** 单词 */
@property (strong, nonatomic) LARAllWords *words;

- (instancetype)initWithAriticle:(LARArticle *)article Words:(LARAllWords *)words;;

@end
