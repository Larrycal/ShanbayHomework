//
//  LARDBManager.m
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import "LARDBManager.h"
#import "LARArticle.h"
#import "LARArticleCount.h"


@implementation LARDBManager
static sqlite3 *db = nil;

+ (LARDBManager *)sharedInstance{
    static LARDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LARDBManager alloc] init];
    });
    return manager;
}

- (sqlite3 *)LAR_openDB{
    if (db!=nil) {
        return db;
    }
    // 获取数据库路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shanbay" ofType:@"sqlite"];
    LARLog(@"%@",path);
    // 打开数据库
    int result = sqlite3_open(path.UTF8String, &db);
    if (result == SQLITE_OK) {
        LARLog(@"打开数据库成功");
    }else{
        LARLog(@"打开数据库失败");
    }
    return db;
}

- (void)LAR_closeDB{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        LARLog(@"关闭数据库成功");
    }else {
        LARLog(@"关闭数据库失败");
    }
}

// 查询数据库第几课
- (LARArticleCount *)queryWithLessonNum:(int)num{
    db = [self LAR_openDB];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ARTICLES"];
    LARLog(@"query :%@",sql);
    // 创建跟随指针，保存sql语句
    sqlite3_stmt *stmt = nil;
    
    // 执行语句
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        LARLog(@"查询语句正确");
    
        // 用来保存所有文章
        LARArticleCount *articles = [[LARArticleCount alloc] init];
        NSMutableArray *arry = [NSMutableArray array];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 一篇文章
            LARArticle *data = [[LARArticle alloc] init];
            // 查询赋值操作
            char *title = (char *)sqlite3_column_text(stmt, 0);
            char* article = (char *)sqlite3_column_text(stmt, 1);
            int lesson = sqlite3_column_int(stmt, 2);
            char *words = (char *)sqlite3_column_text(stmt, 3);
            char *translation = (char *)sqlite3_column_text(stmt, 4);
            
            // 数据模型赋值
            data.lesson = lesson;
            data.title = [NSString stringWithUTF8String:title];
            data.article = [NSString stringWithUTF8String:article];
            data.words = [NSString stringWithUTF8String:words];
            data.translation = [NSString stringWithUTF8String:translation];
            
            [arry addObject:data];
        }
        // 释放跟随指针
        sqlite3_finalize(stmt);
        articles.articles = [arry mutableCopy];
        return articles;
    }else{
        LARLog(@"查询语句错误");
    }
    // 查询失败也释放跟随指针
    sqlite3_finalize(stmt);
    return nil;
}

// 查询文章总数
- (LARArticleCount *)queryForArticleNumber{
    db = [self LAR_openDB];
    
    NSString *sql = [NSString stringWithFormat:@"select count from number_article"];
    LARLog(@"query :%@",sql);
    // 创建跟随指针，保存sql语句
    sqlite3_stmt *stmt = nil;
    
    // 执行语句
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil);
    if (result == SQLITE_OK) {
        LARLog(@"查询语句正确");
        LARArticleCount *count = [[LARArticleCount alloc] init];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 查询赋值操作
            int lesson = (int)sqlite3_column_text(stmt, 0);
            // 数据模型赋值
            count.count = lesson;
            // 释放跟随指针
            sqlite3_finalize(stmt);
            return count;
        }
    }else{
        LARLog(@"查询语句错误");
    }
    // 查询失败也释放跟随指针
    sqlite3_finalize(stmt);
    return nil;

}

@end
