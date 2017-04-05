//
//  LARPopView.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/5.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LARPopConfig;

@interface LARPopView : UIView
/** 模型 */
@property (strong, nonatomic) LARPopConfig *config;
+ (instancetype)popView;
@end
