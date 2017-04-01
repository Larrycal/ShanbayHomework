//
//  LARArticle.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LARArticle : NSObject
/** 课程名 */
@property (assign, nonatomic) int lesson;
/** 标题 */
@property (copy, nonatomic) NSString *title;
/** 文章 */
@property (copy, nonatomic) NSString *article;
/** 生词 */
@property (copy, nonatomic) NSString *words;
/** 翻译 */
@property (copy, nonatomic) NSString *translation;
@end
