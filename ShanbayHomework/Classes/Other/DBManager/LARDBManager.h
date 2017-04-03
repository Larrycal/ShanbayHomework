//
//  LARDBManager.h
//  ShanbayHomework
//
//  Created by 柳钰柯 on 2017/4/1.
//  Copyright © 2017年 柳钰柯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class LARArticleCount;
@class LARAllWords;

@interface LARDBManager : NSObject

/** 获取数据库管理单例 */
+ (LARDBManager *)sharedInstance;
/** 打开数据库 */
- (sqlite3 *)LAR_openDB;
/** 关闭数据库 */
- (void)LAR_closeDB;
/** 查询第几课 */
- (LARArticleCount *)queryWithLessons;
/** 查询单词 */
- (LARAllWords *)queryWithWords;
@end
