//
//  LARCTDisplayView.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARCTDisplayView.h"
#import "LARCoreTextData.h"

@implementation LARCTDisplayView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 获取绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
}
@end
