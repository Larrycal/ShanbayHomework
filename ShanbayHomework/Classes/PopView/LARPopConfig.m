//
//  LARPopConfig.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/5.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARPopConfig.h"

@implementation LARPopConfig
- (instancetype)init {
    if (self = [super init]) {
        _word = @"你还没有给我单词呢！";
        _message = @"你还没有给我翻译呢！";
        _pic = nil;
    }
    return self;
}
@end
