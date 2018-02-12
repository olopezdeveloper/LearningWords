//
//  DataBase.h
//  Diabetes Tips
//
//  Created by ca9z on 4/18/14.
//  Copyright (c) 2014 Electronic Core Networks S.A.C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject
+(NSString *)getDataBasePath;
+(void) checkAndCreateDatabaseWithName:(NSString* )nameDataBase;
- (NSArray *)ejecutarSelect:(NSString *)select;
- (void)ejecutarInsert:(NSString *)insert;
- (void)ejecutarDelete:(NSString *)deleteString;
- (void)ejecutarUpdate:(NSString *)update;
+ (instancetype)shared;
@property (strong, nonatomic)NSString* dataBaseName;
@end
