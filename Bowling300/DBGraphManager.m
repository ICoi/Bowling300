//
//  DBGraphManager.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DBGraphManager.h"
#import <sqlite3.h>
#import "BLGraphYear.h"
#define GROUPCNT 3

@implementation DBGraphManager
static DBGraphManager *_instance = nil;
+ (id)sharedModeManager{
    if (nil == _instance){
        _instance = [[DBGraphManager alloc]init];
        [_instance openDB];
    }
    return _instance;
}
- (NSMutableArray *)arrayForCircleGraphWithYear:(NSInteger)inYear{
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    int groupCnt[GROUPCNT] = {0};
    
    NSString *queryStr = @"SELECT Date, GroupNum FROM personnalRecord";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s",ret,sqlite3_errmsg(db));
    // 모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *date = (char *)sqlite3_column_text(stmt,0);
        int groupNum = (int)sqlite3_column_int(stmt, 1);
        
        NSString *nsDate = [NSString stringWithCString:date encoding:NSUTF8StringEncoding];
        
        NSString *nowYear = [NSString stringWithFormat:@"%d",(int)inYear];
        NSString *stmtYear = [nsDate substringWithRange:NSMakeRange(0, 4)];
     //   NSLog(@"sub : %@",stmtYear);
        
        if([nowYear isEqualToString:stmtYear]){
            groupCnt[groupNum]++;
        }
    }
    
    for(int i = 0 ; i < GROUPCNT; i++){
        [returnArr addObject:[NSNumber numberWithInt:groupCnt[i]]];
    }
    return returnArr;
}
- (BLGraphYear *)arrayForBarLineGraphWithYear:(NSInteger)inYear{
    
    BLGraphYear *returnBLGYear = [[BLGraphYear alloc]init];
    
    NSString *queryStr = @"SELECT Date, TotalScore, GroupNum FROM personnalRecord";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s",ret,sqlite3_errmsg(db));
    
    //모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char * date = (char *)sqlite3_column_text(stmt, 0);
        int totalScore = (int)sqlite3_column_int(stmt, 1);
        int groupNum = (int)sqlite3_column_int(stmt, 2);
        
        NSString *nsDateStr = [NSString stringWithCString:date encoding:NSUTF8StringEncoding];
        NSString *month = [nsDateStr substringWithRange:NSMakeRange(4, 2)];
        [returnBLGYear addDataWithMonth:month withGroup:groupNum withScore:totalScore];
    }
    
    // 저장한 값을 바탕으로 리턴할 어레이 만듬.
    return returnBLGYear;
}
@end
