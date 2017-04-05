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
#import "LARAllWords.h"
#import "LARWord.h"
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
/** Model->单词 */
@property (strong, nonatomic) LARAllWords *words;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏设置
    self.navigationController.navigationBar.barTintColor = LARRGB(58, 158, 138);
    self.navigationItem.title = @"扇贝Homework";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // tableView设置
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.frame = [UIScreen mainScreen].bounds;
    self.tableView = tableView;
    [self.view addSubview:_tableView];
    
    // 保存数据库单例连接
    self.db = [LARDBManager sharedInstance];
}

#pragma mark - 懒加载
- (LARArticleCount *)count {
    if (!_count) {
        _count = [self.db queryWithLessons];
    }
    return _count;
}

- (LARAllWords *)words {
    if (!_words) {
        _words = [self.db queryWithWords];
    }
    return _words;
}

#pragma mark - <UITableViewDelegate>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 根据重生池取出Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // 设置Cell标题
    LARArticle *article = _count.articles[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Lesson %d",article.lesson];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 根据模型获取Cell长度
    return self.count.articles.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 进入文章详细列表
    LARTabBarViewController *vc = [[LARTabBarViewController alloc] initWithAriticle:_count.articles[indexPath.row] Words:self.words];
    [self.navigationController pushViewController:vc animated:YES];
    
    return indexPath;
}

// 设置一个估计高度，优化TableView
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
