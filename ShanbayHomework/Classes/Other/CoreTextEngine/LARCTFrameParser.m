//
//  LARCTFrameParser.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "LARCTFrameParser.h"
#import "LARCTFrameParserConfig.h"
#import "LARCoreTextData.h"

@implementation LARCTFrameParser

/** 初始化CT配置信息 */
+ (NSDictionary *)attributesWithConfig:(LARCTFrameParserConfig *)config {
    // 字体、行间距等设置
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberofSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberofSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing},
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberofSettings);
    
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[(id)kCTForegroundColorAttributeName] =  (id)(textColor.CGColor);
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

/** 配置Data信息 */
+ (LARCoreTextData *)paraseContent:(NSAttributedString *)content config:(LARCTFrameParserConfig *)config wordInfo:(NSArray *)wordInfos{
    
    NSDictionary *attributes = [self attributesWithConfig:config];
    
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithAttributedString:content];
    [contentString addAttributes:attributes range:NSMakeRange(0, [contentString length])];
    
    // 创建 CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    // 获得要绘制的区域高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef 实例和计算好的绘制高度保存到CoreTextData实例中，最会返回LARCoreTextData实例
    LARCoreTextData *data = [[LARCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.wordInfos = wordInfos;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

/** 计算CTView需要的高度 */
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(LARCTFrameParserConfig *)config
                                  height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}
@end
