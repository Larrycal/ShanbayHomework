//
//  LARCTDisplayView.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LARCoreTextData.h"

@interface LARCTDisplayView : UIView
/** 数据 */
@property (strong, nonatomic) LARCoreTextData *data;
- (void)handleActiveRect;
@end
