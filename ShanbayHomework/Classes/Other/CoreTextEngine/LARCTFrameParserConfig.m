//
//  LARCTFrameParserConfig.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARCTFrameParserConfig.h"

@implementation LARCTFrameParserConfig

- (instancetype)init {
    if (self = [super init]) {
        _width = 200.0f;
        _fontSize = 22.0f;
        _lineSpace = 12.0f;
        _textColor = LARRGB(58, 58, 58);
    }
    return self;
}
@end
