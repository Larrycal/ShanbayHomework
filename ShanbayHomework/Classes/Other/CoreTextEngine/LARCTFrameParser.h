//
//  LARCTFrameParser.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LARCoreTextData;
@class LARArticleWordInfo;
@class LARCTFrameParserConfig;

@interface LARCTFrameParser : NSObject

+ (LARCoreTextData *)paraseContent:(NSAttributedString *)content config:(LARCTFrameParserConfig *)config wordInfo:(NSArray *)wordInfos;

@end
