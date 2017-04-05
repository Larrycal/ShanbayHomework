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
#import "LARPopView.h"
#import "LARPopConfig.h"


@interface LARCTDisplayView ()
{
    BOOL isHit;
    NSMutableArray *arrText;// 存放每一个单词的CTRun
    UIView *colorView; // 高亮单词view
    UIVisualEffectView *effectview; // 毛玻璃view
    LARPopView *popView; // HUDview
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
   
    for (LARArticleWordInfo *info in arrText) {
        CGRect textFrmToScreen = [self convertRectFromLoc:info.wordFrame];
        if (CGRectContainsPoint(textFrmToScreen, location)) {
            [self highlightString:info.word AndShowHudWithFrame:textFrmToScreen];
            isHit = YES;
            break;
        }
    }
}


#pragma mark - 通知中心操作
/** 注册通知中心 */
- (void)registerForPopView {
    // 注册popView出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewWillApper) name:popViewShow object:nil];
    // 注册popView消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewWillHide) name:popViewHide object:nil];
}

/** popView出现，屏蔽用户操作 */
- (void)popViewWillApper {
    [self setUserInteractionEnabled:NO];
}

/** popView出现，启动用户操作 */
- (void)popViewWillHide {
    [colorView removeFromSuperview];
    [effectview removeFromSuperview];
    [self setUserInteractionEnabled:YES];
}


#pragma mark - HUD显示操作
/** 高亮单词，显示HUD */
- (void)highlightString:(NSString *)word AndShowHudWithFrame:(CGRect)frame {
    LARPopConfig *config = [[LARPopConfig alloc] init];
    config.word = word;
    config.message = @"抱歉，没有找到翻译!";
    [self popViewShowWithConfig:config];
    [self colorViewShowWithFrame:frame];
}

/** 显示colorView */
- (void)colorViewShowWithFrame:(CGRect)frame {
    if (colorView) {// 移除原有colorView，添加新的坐标的colorView
        [colorView removeFromSuperview];
        colorView = nil;
    }
    colorView = [[UIView alloc] initWithFrame:frame];
    // LARRGB(41, 157, 133);
    colorView.backgroundColor = [UIColor colorWithRed:41/255.0 green:157/255.0 blue:133/255.0 alpha:0.4];
    [self addSubview:colorView];
}

/** 显示popView */
- (void)popViewShowWithConfig:(LARPopConfig *)config {
    // 显示之前先移除
    if (popView) {
        [popView removeFromSuperview];
        popView = nil;
    }

    // 创建popView
    popView = [LARPopView popView];
    CGFloat w = UIApplication.sharedApplication.keyWindow.frame.size.width;
    CGFloat h = UIApplication.sharedApplication.keyWindow.frame.size.height;
    CGFloat popSize = 200;
    popView.config = config;
    popView.frame = CGRectMake((w - popSize)/2,(h - popSize)/2 ,popSize,popSize );
    
    // 先添加毛玻璃View
    [self effectViewShow];
    
    // 添加PopView到Keywindow
    [UIApplication.sharedApplication.keyWindow addSubview:popView];
}

/** 显示毛玻璃View */
- (void)effectViewShow {
    if (!effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = [UIScreen mainScreen].bounds;
        effectview.height = self.data.height;
        effectview.alpha = 0.6;
    }
    [self addSubview:effectview];
}

#pragma mark - CoreText核心操作
// 给单词绑定CTFrame
- (void)handleActiveRect{
    // 注册通知中心
    [self registerForPopView];
    
    if (!arrText) {
        arrText = [NSMutableArray array];
    }
    NSArray *arrLines = (NSArray *)CTFrameGetLines(self.data.ctFrame);
    NSInteger count = [arrLines count];//获取线的数量
    CGPoint points[count];//建立起点的数组（cgpoint类型为结构体，故用C语言的数组）
    CTFrameGetLineOrigins(self.data.ctFrame, CFRangeMake(0, 0), points);//获取起点
    for (int i = 0; i < arrLines.count; i ++) {//遍历线的数组
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray *arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);//获取CTRun数组
        for (int j = 0; j < arrGlyphRun.count; ++j) { // 遍历每一个CRun来获取每一个单词的CTRun,并保存到数组
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            CGPoint point = points[i];//获取一个起点
            NSString *str = attributes[@"word"]; // 利用已经绑定了word标志的富文本进行识别单词
            if (str) {
                LARArticleWordInfo *info = [[LARArticleWordInfo alloc] init];
                info.wordFrame =[self getLocWithFrame:self.data.ctFrame CTLine:line CTRun:run origin:point];
                info.word = str;
                [arrText addObject:info];
            }
        }
    }
}

/** 获取每一个CTRun的绘制区域 */
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

/** 将系统坐标系转换为屏幕坐标系 */
- (CGRect)convertRectFromLoc:(CGRect)rect
{
    return CGRectMake(rect.origin.x, self.bounds.size.height - rect.origin.y - rect.size.height , rect.size.width, rect.size.height);
}

#pragma mark - 扫尾工作
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    LARLog(@"CTDisplayView销毁了");
}

@end
