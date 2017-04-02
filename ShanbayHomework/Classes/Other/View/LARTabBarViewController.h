//
//  LARTabBarViewController.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LARArticle;
@interface LARTabBarViewController : UITabBarController

/** 文章 */
@property (strong, nonatomic) LARArticle *article;

- (instancetype)initWithAriticle:(LARArticle *)article;

@end
