//
//  LARCTDisplayView.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARCTDisplayView.h"
#import "LARCoreTextData.h"
#import "LARArticleWordInfo.h"

@interface LARCTDisplayView ()
{
    NSMutableArray *arrText;
}
@end

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


// 给单词绑定CTFrame
- (void)handleActiveRect{
    if (!arrText) {
        arrText = [NSMutableArray array];
    }
    NSArray *arrLines = (NSArray *)CTFrameGetLines(self.data.ctFrame);
    NSInteger count = [arrLines count];//获取线的数量
    CGPoint points[count];//建立起点的数组（cgpoint类型为结构体，故用C语言的数组）
    CTFrameGetLineOrigins(self.data.ctFrame, CFRangeMake(0, 0), points);//获取起点
    for (int i = 0; i < arrLines.count; i ++) {//遍历线的数组
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray *arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);//获取GlyphRun数组（GlyphRun：高效的字符绘制方案）
        for (int j = 0; j < arrGlyphRun.count; ++j) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            CGPoint point = points[i];//获取一个起点
            NSString *str = attributes[@"word"];
            if (str) {
                LARLog(@"%@",str);
                LARArticleWordInfo *info = [[LARArticleWordInfo alloc] init];
                CGRect rect = [self getLocWithFrame:self.data.ctFrame CTLine:line CTRun:run origin:point];
                LARLog(@"%@",NSStringFromCGRect(rect));
                info.wordFrame =[self getLocWithFrame:self.data.ctFrame CTLine:line CTRun:run origin:point];
                info.word = str;
                [arrText addObject:info];
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    for (LARArticleWordInfo *info in arrText) {
        CGRect textFrmToScreen = [self convertRectFromLoc:info.wordFrame];
        if (CGRectContainsPoint(textFrmToScreen, location)) {
            [self clickAndChangeColor:info.word];
            break;
        }
    }
}

///将系统坐标转换为屏幕坐标
- (CGRect)convertRectFromLoc:(CGRect)rect
{
    return CGRectMake(rect.origin.x, self.bounds.size.height - rect.origin.y - rect.size.height , rect.size.width, rect.size.height);
}

- (void)clickAndChangeColor:(NSString *)word {
    LARLog(@"点击了单词:%@",word);
}

-(CGRect)getLocWithFrame:(CTFrameRef)frame CTLine:(CTLineRef)line CTRun:(CTRunRef)run origin:(CGPoint)origin
{
    CGFloat ascent;//获取上距
    CGFloat descent;//获取下距
    CGRect boundsRun;//创建一个frame
    boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
    boundsRun.size.height = ascent + descent;
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);//获取x偏移量
    boundsRun.origin.x = origin.x + xOffset;//point是行起点位置，加上每个字的偏移量得到每个字的x
    boundsRun.origin.y = origin.y - descent;
    CGPathRef path = CTFrameGetPath(frame);//获取绘制区域
    CGRect colRect = CGPathGetBoundingBox(path);//获取剪裁区域边框
    CGRect deleteBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);//获取绘制区域
    return deleteBounds;
}

# warning 进行Data中的wordInfoRange信息判断

# warning 遍历所有文章中单词的range，判断点击地点是否击中







@end
