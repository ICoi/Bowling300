//
//  DBPersonnalRecordManager.m
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DBPersonnalRecordManager.h"

@implementation DBPersonnalRecordManager
static DBPersonnalRecordManager *_instance = nil;
+ (id)sharedModeManager{
    if (nil == _instance) {
        _instance = [[DBPersonnalRecordManager alloc] init];
        [_instance openDB];
    }
    return _instance;
}

- (BOOL)insertDataWithDate:(NSString *)inDate withGroupNum:(NSInteger)inGroupNum withScore:(NSString *)inScore withTotalScore:(NSInteger)inTotalScore{
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO personnalRecord(Date , GroupNum , Score , TotalScore) VALUES ('%@', %d, '%@', %d)", inDate, (int)inGroupNum, inScore, (int)inTotalScore];
    
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
- (void)showAllData{
    NSString *queryStr = @"SELECT * FROM personnalRecord";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    //모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        NSLog(@"%@",stmt);
    }
    
}
@end
