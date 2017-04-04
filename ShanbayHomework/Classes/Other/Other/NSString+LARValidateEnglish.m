//
//  NSString+LARValidateEnglish.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/4.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "NSString+LARValidateEnglish.h"

@implementation NSString (LARValidateEnglish)
+ (BOOL)isEnglish:(NSString *)str {
    for (int i = 0; i< [str length]; ++i) {
         int asiic = [str characterAtIndex:i];
        if ((asiic >= 65 && asiic <= 90) || (asiic >= 97 && asiic <= 122)) {
            return YES;
        }
    }
    return NO;
}
@end
