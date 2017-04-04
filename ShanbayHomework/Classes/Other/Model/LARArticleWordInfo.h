//
//  LARArticleWordInfo.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/4.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LARArticleWordInfo : NSObject
/** 分割出来的单词 */
@property (copy, nonatomic) NSString *word;
/** frame */
@property (assign, nonatomic) CGRect wordFrame;
@end
