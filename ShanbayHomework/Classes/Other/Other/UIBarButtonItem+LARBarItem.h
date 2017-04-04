//
//  UIBarButtonItem+LARBarItem.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/4.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LARBarItem)
/**
 封装自定义创建BarButtonItem
 
 @param number         slider数组
 @param frame          尺寸
 @param action         slider绑定的方法
 @param target         调用方法的对象
 
 @return               返回一个UIBarButtonItem
 */
+ (instancetype)itemWithNumber:(NSArray *)number Frame:(CGRect )frame Action:(SEL)action Target:(id)target;

/**
 封装自定义创建BarButtonItem
 
 @param normolImage    正常图片
 @param selectImage    选中状态图片
 @param action         button绑定的方法
 @param target         调用方法的对象
 
 @return               返回一个UIBarButtonItem
 */
+ (instancetype)itemWithNormalImage:(NSString *)normolImage SelectImage:(NSString *)selectImage Action:(SEL)action Target:(id)target;

@end
