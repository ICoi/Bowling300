//
//  DBPersonnalRecordManager.m
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DBPersonnalRecordManager.h"
#import "MonthScore.h"

#define USERINFO 11

@implementation DBPersonnalRecordManager
static DBPersonnalRecordManager *_instance = nil;
+ (id)sharedModeManager{
    if (nil == _instance) {
        _instance = [[DBPersonnalRecordManager alloc] init];
        [_instance openDB];
    }
    return _instance;
}

- (BOOL)insertDataWithDate:(NSString *)inDate withGroupNum:(NSInteger)inGroupNum withScore:(NSString *)inScore withHandy:(NSInteger)inHandy withTotalScore:(NSInteger)inTotalScore{
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO personnalRecord(User, Date , GroupNum , Score , Handy, TotalScore) VALUES (%d, '%@', %d, '%@', %d ,%d)", USERINFO, inDate, (int)inGroupNum, inScore,(int)inHandy ,(int)inTotalScore];
    
    NSLog(@"insertQuery : %@", insertQuery);
    char *errorMsg;
    int ret = sqlite3_exec(db, [insertQuery UTF8String], nil, nil, &errorMsg);
    
    if(ret != SQLITE_OK){
        NSLog(@"Error on InsertQuery : %s", errorMsg);
        return NO;
    }
    
    sqlite3_last_insert_rowid(db);
    return YES;
    return YES;
}


- (MonthScore *)showDataWithMonth:(NSInteger)inMonth withYear:(NSInteger)inYear{
    MonthScore *tmpMonthScore = [[MonthScore alloc] init];
    
    NSString *queryStr = @"SELECT Date, GroupNum, TotalScore FROM personnalRecord";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    //모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *date = (char *)sqlite3_column_text(stmt, 0);
        int groupNum = (int)sqlite3_column_int(stmt, 1);
        int score = (int)sqlite3_column_int(stmt, 2);
        
        NSString *nsDate = [NSString stringWithCString:date encoding:NSUTF8StringEncoding];
        
        NSLog(@"showTest : %@ %d %d",nsDate, groupNum, score);
        // NSString *nsDate = [NSString stringWithCString:date encoding:NSUTF8StringEncoding];
        
        // 년도와 월을 비교해서 저장할 정보만 걸러낸다
        NSString *nowYearAndMonth = [NSString stringWithFormat:@"%04d%02d",(int)inYear,(int)inMonth];
        NSString *stmtYearAndMonth = [nsDate substringWithRange:NSMakeRange(0, 6)];
        NSLog(@"sub : %@",stmtYearAndMonth);
        
        if([nowYearAndMonth isEqualToString:stmtYearAndMonth]){
            // TODO
            NSString *date = [nsDate substringWithRange:NSMakeRange(6, 2)];
            NSLog(@"date : %@",date);
            [tmpMonthScore addDataWithScore:score withDate:date withGroupNum:groupNum];
        }
    }
    return  tmpMonthScore;
}
@end
