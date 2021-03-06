//
//  UIView+LARFrame.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 该类用来快速获取View的frame结构体各信息
 */
@interface UIView (LARFrame)

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGSize)size;
- (void)setSize:(CGSize)size;
@end
