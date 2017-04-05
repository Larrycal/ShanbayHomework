//
//  LARPopView.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/5.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARPopView.h"
#import "LARPopConfig.h"


@interface LARPopView ()
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;

@end

@implementation LARPopView

//- (instancetype)init {
//    if (self = [super init]) {
////        _wordLabel.text = @"No Word!";
////        _messageLabel.text = @"不要看啦。没有翻译！";
////        _picView.image = nil;
//    }
//    return self;
//}

+ (instancetype)popView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    LARLog(@"show");
    // Initialization code
    NSNotification *notice = [NSNotification notificationWithName:popViewShow object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}

- (void)setConfig:(LARPopConfig *)config {
    _config = config;
    _wordLabel.text = config.word;
    _messageLabel.text = config.message;
    if (config.pic) {
        _picView.image = [UIImage imageNamed:config.pic];
    }
}
- (IBAction)removeButton:(UIButton *)sender {
    NSNotification *notice = [NSNotification notificationWithName:popViewHide object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    [self removeFromSuperview];
}

- (void)dealloc {
    LARLog(@"POPView销毁了");
}

@end
