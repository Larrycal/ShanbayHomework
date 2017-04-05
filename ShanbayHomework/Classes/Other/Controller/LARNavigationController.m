//
//  LARNavigationController.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/5.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARNavigationController.h"

@interface LARNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation LARNavigationController

+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 禁用全屏返回
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
//    [self.view addGestureRecognizer:pan];
//    pan.delegate = self;
//    self.interactivePopGestureRecognizer.enabled = NO;
}

/**
 * 在这里拦截UINavigation的push方法
 *
 * @param viewController 推进去的VC
 * @param animated       动画
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) { // >0指当前视图，即当前视图为1，进入了pushView方法证明还有下一个视图，并且需要设置左上角返回按钮
        UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnButton setImage:[UIImage imageNamed:@"icon_system_back"] forState:UIControlStateNormal];
        [returnButton setTitle:@"返回" forState:UIControlStateNormal];
        [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [returnButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [returnButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        returnButton.size = CGSizeMake(70, 30);
        // 让按钮内的所有内容左对齐
        returnButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 让按钮内的所以内容向左平移-10
        returnButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        // 设置下一个VC左上角显示
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
        
        // 隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // super的pushView需要放在后面，让viewController可以覆盖上面的LeftBarButtonItem
    [super pushViewController:viewController animated:YES];
}


/**
 设置返回按钮监听事件---->弹出当前VC
 */
- (void)back{
    [self popViewControllerAnimated:YES];
}

#pragma mark - <UIGestureRecognizerDelegate>
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    return self.childViewControllers.count > 1;
//}

@end
