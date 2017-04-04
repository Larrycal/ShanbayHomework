//
//  LARCoreTextData.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class LARArticleWordInfo;

@interface LARCoreTextData : NSObject
/** 这是一个Frame对象，用于表示一个绘制区域，它是由CTFramesetterRef生成 */
@property (assign, nonatomic) CTFrameRef ctFrame;
/** 高度 */
@property (assign, nonatomic) CGFloat height;
/** 单词信息 */
@property (strong, nonatomic) NSArray *wordInfos;
/** 文章长度 */
@property (assign, nonatomic) NSInteger length;
@end
