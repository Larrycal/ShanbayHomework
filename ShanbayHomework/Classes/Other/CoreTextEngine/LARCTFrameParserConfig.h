//
//  LARCTFrameParserConfig.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LARCTFrameParserConfig : NSObject
/** 配置宽度 */
@property (assign, nonatomic) CGFloat width;
/** 配置字体大小 */
@property (assign, nonatomic) CGFloat fontSize;
/** 行间距 */
@property (assign, nonatomic) CGFloat lineSpace;
/** 颜色 */
@property (assign, nonatomic) UIColor *textColor;
@end
