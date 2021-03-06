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
        
        // 점수 저장하는 DB 만들기
        char *createQuery_MODE = "CREATE TABLE IF NOT EXISTS personnalRecord (User Integer, Date Text, GroupNum Integer, Score Text, Handy Integer, TotalScore Integer, League Integer)";
        char *errorMsg ;
        
        ret = sqlite3_exec(db, createQuery_MODE, NULL, NULL, &errorMsg);
        if( ret != SQLITE_OK){
            [fileManager removeItemAtPath:dbFilePath error:nil];
            NSLog(@"create personnalRecord TABLE fail : %s", errorMsg);
            return NO;
        }
        
        
        // 개인정보 저장하는 DB 만들기
        createQuery_MODE = "CREATE TABLE IF NOT EXISTS myInfo (MyIdx Integer, Name Text, Gender Integer, Country Text, Email Text, Password Text, Hand Integer, Image Text, FromYear Integer, Ball Integer, Series300 Integer, Series800 Integer, Step Integer, Style Integer)";
        
        ret = sqlite3_exec(db, createQuery_MODE, NULL, NULL, &errorMsg);
        if( ret != SQLITE_OK){
            [fileManager removeItemAtPath:dbFilePath error:nil];
            NSLog(@"create myInfo TABLE fail : %s", errorMsg);
            return NO;
        }
        
        // 그룹정보 저장하는 DB 만들기
        createQuery_MODE = "CREATE TABLE IF NOT EXISTS myGroup(groupIdx Integer, groupName Text, groupRColor Integer, groupGColor Integer, groupBColor Integer, Represent BOOL)";
        
        ret = sqlite3_exec(db, createQuery_MODE, NULL, NULL, &errorMsg);
        if( ret != SQLITE_OK){
            [fileManager removeItemAtPath:dbFilePath error:nil];
            NSLog(@"create myGroup TABLE fail : %s", errorMsg);
            return NO;
        }
        
        
        
        NSString *insertQuery = @"INSERT INTO myGroup(groupIdx, groupName , groupRColor , GroupGColor , GroupBColor,Represent) VALUES (-1, 'solo', 0, 0, 0, 0)";
        
        NSLog(@"insertQuery : %@", insertQuery);
        int ret = sqlite3_exec(db, [insertQuery UTF8String], nil, nil, &errorMsg);
        
        if(ret != SQLITE_OK){
            NSLog(@"Error on InsertQuery : %s", errorMsg);
            return NO;
        }
        
        sqlite3_last_insert_rowid(db);
        return YES;
        
    }
    
    return YES;
}

- (BOOL)closeDB{
    return  YES;
    
}
@end
