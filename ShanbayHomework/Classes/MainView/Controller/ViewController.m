//
//  ViewController.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "ViewController.h"
#import "LARArticle.h"
#import "LARDBManager.h"
#import "LARArticleCount.h"
#import "LARTabBarViewController.h"

static NSString *const ID = @"cell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (strong, nonatomic) UITableView *tableView;
/** DBManager */
@property (strong, nonatomic) LARDBManager *db;
/** Model->文章细节 */
@property (strong, nonatomic) LARArticle *articleData;
/** Model->文章总数 */
@property (strong, nonatomic) LARArticleCount *count;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    self.navigationItem.title = @"扇贝Homework";
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.frame = [UIScreen mainScreen].bounds;
    self.tableView = tableView;
    [self.view addSubview:_tableView];
    // 保存单例连接
    self.db = [LARDBManager sharedInstance];
//    [self.db LAR_openDB];
//    self.articleData = [self.db queryWithLessonNum:1];
}

#pragma mark - 懒加载
- (LARArticleCount *)count{
    if (!_count) {
        _count = [self.db queryWithLessonNum:1];
    }
    return _count;
}


#pragma mark - <UITableViewDelegate>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    LARArticle *article = _count.articles[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Lesson %d",article.lesson];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count.articles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 进入文章详细列表
    
    LARTabBarViewController *vc = [[LARTabBarViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

// 设置一个估计高度，优化计算
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
