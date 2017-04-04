//
//  UIBarButtonItem+LARBarItem.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/4.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "UIBarButtonItem+LARBarItem.h"

@implementation UIBarButtonItem (LARBarItem)
+ (instancetype)itemWithNumber:(NSArray *)number Frame:(CGRect )frame Action:(SEL)action Target:(id)target{
    // 创建自定义按钮
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    slider.minimumValue = 0;
    slider.maximumValue = ((float)[number count] - 1);
    slider.value = 0;
    slider.continuous = YES;
    [slider addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    UIView *containView = [[UIView alloc] initWithFrame:slider.bounds];
    [containView addSubview:slider];
    containView.hidden = YES;
    // 包装为UIBarButtonItem并返回
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+ (instancetype)itemWithNormalImage:(NSString *)normolImage SelectImage:(NSString *)selectImage Action:(SEL)action Target:(id)target{
    // 创建自定义按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normolImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:button.bounds];
    [containView addSubview:button];
    // 包装为UIBarButtonItem并返回
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

@end
