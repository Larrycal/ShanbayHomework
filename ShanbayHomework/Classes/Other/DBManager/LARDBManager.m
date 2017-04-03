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
#import "LARWord.h"
#import "LARAllWords.h"

@interface LARDBManager (){
     LARArticleCount * articles;
     LARAllWords *allWords;
}

@end

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

// 查询数据库课程并保存
- (LARArticleCount *)queryWithLessons{
    if (articles != nil) {
        return articles;
    }
    
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
        articles = [[LARArticleCount alloc] init];
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

// 查询所有等级单词
- (LARAllWords *)queryWithWords {
    if (allWords != nil) {
        return allWords;
    }
    
    db = [self LAR_openDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM nce4_words"];
    LARLog(@"query :%@",sql);
    // 创建跟随指针，保存sql语句
    sqlite3_stmt *stmt = nil;
    
    // 执行语句
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        LARLog(@"查询语句正确");
        
        // 用来保存所有文章
        allWords = [[LARAllWords alloc] init];
        NSMutableArray *arry = [NSMutableArray array];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 一篇文章
            LARWord *data = [[LARWord alloc] init];
            // 查询赋值操作
            char *word = (char *)sqlite3_column_text(stmt, 0);
            int level = sqlite3_column_int(stmt, 1);
            
            // 数据模型赋值
            data.word = [NSString stringWithUTF8String:word];
            data.level = level;
            
            [arry addObject:data];
        }
        // 释放跟随指针
        sqlite3_finalize(stmt);
        allWords.allWords = [arry mutableCopy];
        return allWords;
    }else{
        LARLog(@"查询语句错误");
    }
    // 查询失败也释放跟随指针
    sqlite3_finalize(stmt);
    return nil;
}


@end
