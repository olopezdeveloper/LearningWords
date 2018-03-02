//
//  DataBase.m
//  Diabetes Tips
//
//  Created by ca9z on 4/18/14.
//  Copyright (c) 2014 Electronic Core Networks S.A.C. All rights reserved.
//

#import "DataBase.h"
#import <sqlite3.h>

@interface DataBase()
@property (readonly,nonatomic)sqlite3 *base;
@end

@implementation DataBase

+ (instancetype)shared
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}


+(void) checkAndCreateDatabaseWithName:(NSString* )nameDataBase
{
    BOOL success;
    [DataBase shared].dataBaseName = nameDataBase;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dataBasePath = [DataBase getDataBasePath];
    NSLog(@"Path DataBase: %@", dataBasePath);
    success = [fileManager fileExistsAtPath:dataBasePath];
    if(!success){
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[DataBase shared].dataBaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:dataBasePath error:nil];
    }
}

+(NSString *)getDataBasePath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *rutaPath = [documentsDir stringByAppendingPathComponent:[DataBase shared].dataBaseName];
    return rutaPath;
}

- (NSArray *)ejecutarSelect:(NSString *)select
{
    NSMutableArray *arrayResult = [[NSMutableArray alloc] init];
    [self openDataBase];
    NSString *sql = select;
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2(self.base, [sql UTF8String], -1, &compiledStatement, nil)==SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            int tot = sqlite3_column_count(compiledStatement);
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            for (int i=0; i<tot; i++) {
                NSString *obj = (char *)sqlite3_column_text(compiledStatement, i)? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)] : @"";
                NSString *key = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
                [data setObject:obj forKey:key];
            }
            [arrayResult addObject:data];
        }
    }
    [self closeDataBase];
    
    return [arrayResult copy];
}

- (void)ejecutarInsert:(NSString *)insert
{
    [self openDataBase];
    const char *sql = [insert UTF8String];
    sqlite3_stmt *stmt = nil;
    if(sqlite3_prepare_v2(self.base, sql, -1, &stmt, NULL)==SQLITE_OK){
    }
    if (sqlite3_step(stmt)!=SQLITE_DONE) {
        NSLog(@"ERROR: %s", sqlite3_errmsg(self.base));
    }
    [self closeDataBase];
}

- (void)ejecutarDelete:(NSString *)deleteString
{
    [self openDataBase];
    const char *sql = [deleteString UTF8String];
    if (sqlite3_exec(self.base, sql, NULL, NULL, NULL)!=SQLITE_OK) {
        NSLog(@"ERROR: %s", sqlite3_errmsg(self.base));
    }
    [self closeDataBase];
}

- (void)ejecutarUpdate:(NSString *)update
{
    [self openDataBase];
    const char *sql = [update UTF8String];
    sqlite3_stmt *stmt = nil;
    if(sqlite3_prepare_v2(self.base, sql, -1, &stmt, NULL)==SQLITE_OK){
    }
    if (sqlite3_step(stmt)!=SQLITE_DONE) {
        NSLog(@"ERROR: %s", sqlite3_errmsg(self.base));
    }
    [self closeDataBase];
}

#pragma mark - General Methods
-(void)openDataBase{
    NSString *dataBasePath = [DataBase getDataBasePath];
    if(sqlite3_open([dataBasePath UTF8String], &_base) != SQLITE_OK)
    {
        sqlite3_close(self.base);
    }
}

-(void)closeDataBase{
    sqlite3_close(self.base);
}

@end
