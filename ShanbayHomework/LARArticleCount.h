//
//  LARArticleCount.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LARArticle.h"

@interface LARArticleCount : NSObject
/** 所有文章数组 */
@property (strong, nonatomic) NSMutableArray *articles;
/** 文章数 */
@property (assign, nonatomic) int count;
@end
