//
//  DB.m
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DB.h"

@implementation DB
static DB *_instance = nil;
- (BOOL)openDB{
    if (nil == _instance) {
        _instance = [[DB alloc] init];
        [_instance openDB];
    }
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFilePath = [docPath stringByAppendingPathComponent:@"db.sqlite"];
    
    NSLog(@"docPath : %@",docPath);
    NSLog(@"filePath : %@",dbFilePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existFileFlag = [fileManager fileExistsAtPath:dbFilePath];
    
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    
    if ( ret !=SQLITE_OK )
        return NO;
    
    if(existFileFlag == NO){
        char *createQuery_MODE = "CREATE TABLE IF NOT EXISTS personnalRecord (Date Text, GroupNum Integer, Score Text, TotalScore Integer)";
        char *errorMsg ;
        
        ret = sqlite3_exec(db, createQuery_MODE, NULL, NULL, &errorMsg);
        if( ret != SQLITE_OK){
            [fileManager removeItemAtPath:dbFilePath error:nil];
            NSLog(@"create MODE TABLE fail : %s", errorMsg);
            return NO;
        }
    }
    
    return YES;
}

@end
