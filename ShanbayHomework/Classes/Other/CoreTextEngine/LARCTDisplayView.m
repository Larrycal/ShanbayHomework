//
//  LARCTDisplayView.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARCTDisplayView.h"
#import "LARCoreTextData.h"

@interface LARCTDisplayView ()
{
    CGRect _wordsFrame;
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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [self systemPointFromScreenPoint:[touch locationInView:self]];
//    if ([self checkIsClickOnWords:location]) {
//        return;
//    }
//    [self ClickOnStrWithPoint:location];
//}

//-(void)ClickOnStrWithPoint:(CGPoint)location
//{
//    NSArray * lines = (NSArray *)CTFrameGetLines(self.data.ctFrame);
//    CFRange ranges[lines.count];
//    CGPoint origins[lines.count];
//    CTFrameGetLineOrigins(self.data.ctFrame, CFRangeMake(0, 0), origins);
//    for (int i = 0; i < lines.count; i ++) {
//        CTLineRef line = (__bridge CTLineRef)lines[i];
//        CFRange range = CTLineGetStringRange(line);
//        ranges[i] = range;
//    }
//    for (int i = 0; i < _length; i ++) {
//        long maxLoc;
//        int lineNum;
//        for (int j = 0; j < lines.count; j ++) {
//            CFRange range = ranges[j];
//            maxLoc = range.location + range.length - 1;
//            if (i <= maxLoc) {
//                lineNum = j;
//                break;
//            }
//        }
//        CTLineRef line = (__bridge CTLineRef)lines[lineNum];        CGPoint origin = origins[lineNum];
//        CGRect CTRunFrame = [self frameForCTRunWithIndex:i CTLine:line origin:origin];
//        if ([self isFrame:CTRunFrame containsPoint:location]) {
//            NSLog(@"您点击到了第 %d 个字符，位于第 %d 行，然而他没有响应事件。",i,lineNum + 1);//点击到文字，然而没有响应的处理。可以做其他处理
//            return;
//        }
//    }
//    NSLog(@"您没有点击到文字");
//}

// 单词点击判断
-(BOOL)checkIsClickOnWords:(CGPoint)location
{
    if ([self isFrame:_wordsFrame containsPoint:location]) {
        NSLog(@"您点击到了单词");
        return YES;
    }
    return NO;
}

// 计算单词的Frame
//- (NSArray *)calculateWordsRectWithFrame:(CTFrameRef)frame {
//    NSArray *arrLines = (NSArray *)CTFrameGetLines(frame);
//    NSInteger count = [arrLines count];
//    CGPoint points[count];
//    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
//    for (int i = 0; i < count; ++i) {
//        CTLineRef line = (__bridge CTLineRef)arrLines[i];
//        NSArray *arryGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
//    }
//}

-(BOOL)isFrame:(CGRect)frame containsPoint:(CGPoint)point
{
    return CGRectContainsPoint(frame, point);
}

// 坐标转换
-(CGPoint)systemPointFromScreenPoint:(CGPoint)origin
{
    return CGPointMake(origin.x, self.bounds.size.height - origin.y);
}


-(BOOL)isIndex:(NSInteger)index inRange:(NSRange)range
{
    if ((index <= range.location + range.length - 1) && (index >= range.location)) {
        return YES;
    }
    return NO;
}

-(CGRect)frameForCTRunWithIndex:(NSInteger)index
                         CTLine:(CTLineRef)line
                         origin:(CGPoint)origin
{
    CGFloat offsetX = CTLineGetOffsetForStringIndex(line, index, NULL);
    CGFloat offsexX2 = CTLineGetOffsetForStringIndex(line, index + 1, NULL);
    offsetX += origin.x;
    offsexX2 += origin.x;
    CGFloat offsetY = origin.y;
    CGFloat lineAscent;
    CGFloat lineDescent;
    NSArray * runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
    CTRunRef runCurrent;
    for (int k = 0; k < runs.count; k ++) {
        CTRunRef run = (__bridge CTRunRef)runs[k];
        CFRange range = CTRunGetStringRange(run);
        NSRange rangeOC = NSMakeRange(range.location, range.length);
        if ([self isIndex:index inRange:rangeOC]) {
            runCurrent = run;
            break;
        }
    }
    CTRunGetTypographicBounds(runCurrent, CFRangeMake(0, 0), &lineAscent, &lineDescent, NULL);
    CGFloat height = lineAscent + lineDescent;
    return CGRectMake(offsetX, offsetY, offsexX2 - offsetX, height);
}

@end
