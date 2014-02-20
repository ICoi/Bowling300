//
//  DBPersonnalRecordManager.m
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DBPersonnalRecordManager.h"
#import "MonthScore.h"
#import "AppDelegate.h"


@implementation DBPersonnalRecordManager{
    AppDelegate *ad;
}
static DBPersonnalRecordManager *_instance = nil;
+ (id)sharedModeManager{
    if (nil == _instance) {
        _instance = [[DBPersonnalRecordManager alloc] init];
        [_instance openDB];
    }
    return _instance;
}

- (BOOL)insertDataWithDate:(NSString *)inDate withGroupNum:(NSInteger)inGroupNum withScore:(NSString *)inScore withHandy:(NSInteger)inHandy withTotalScore:(NSInteger)inTotalScore{
    
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO personnalRecord(User, Date , GroupNum , Score , Handy, TotalScore) VALUES (%d, '%@', %d, '%@', %d ,%d)",ad.myIDX , inDate, (int)inGroupNum, inScore,(int)inHandy ,(int)inTotalScore];
    
    NSLog(@"insertQuery : %@", insertQuery);
    char *errorMsg;
    int ret = sqlite3_exec(db, [insertQuery UTF8String], nil, nil, &errorMsg);
    
    if(ret != SQLITE_OK){
        NSLog(@"Error on InsertQuery : %s", errorMsg);
        return NO;
    }
    
    sqlite3_last_insert_rowid(db);
    return YES;
}
- (void)setDefaultData{
    
    AppDelegate *ad = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSInteger highScore = 0;
    NSInteger allScore = 0;
    NSInteger gameCnt =0;
    
    NSString *queryStr = @"SELECT TotalScore FROM personnalRecord";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db,[queryStr UTF8String],-1, &stmt,NULL);
    
    NSAssert2(SQLITE_OK == ret , @"ERROR(%d) on resolving data :%s",ret,sqlite3_errmsg(db));
    
    while(SQLITE_ROW == sqlite3_step(stmt)){
        int score = (int)sqlite3_column_int(stmt, 0);
        
        gameCnt++;
        allScore += score;
        if(highScore < score){
            highScore = score;
        }
    }
    ad.myHighScore = highScore;
    ad.myAllScore = allScore;
    ad.myGameCnt = gameCnt;
    sqlite3_finalize(stmt);
    
}

- (MonthScore *)showDataWithMonth:(NSInteger)inMonth withYear:(NSInteger)inYear{
    MonthScore *tmpMonthScore = [[MonthScore alloc] init];
    
    NSString *queryStr = @"SELECT Date, GroupNum, TotalScore ,rowid FROM personnalRecord";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    //모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *date = (char *)sqlite3_column_text(stmt, 0);
        int groupNum = (int)sqlite3_column_int(stmt, 1);
        int score = (int)sqlite3_column_int(stmt, 2);
        int rowID = (int)sqlite3_column_int(stmt, 3);
        
        NSString *nsDate = [NSString stringWithCString:date encoding:NSUTF8StringEncoding];
        
       // NSLog(@"showTest : %@ %d %d",nsDate, groupNum, score);
        // NSString *nsDate = [NSString stringWithCString:date encoding:NSUTF8StringEncoding];
        
        // 년도와 월을 비교해서 저장할 정보만 걸러낸다
        NSString *nowYearAndMonth = [NSString stringWithFormat:@"%04d%02d",(int)inYear,(int)inMonth];
        NSString *stmtYearAndMonth = [nsDate substringWithRange:NSMakeRange(0, 6)];
        //NSLog(@"sub : %@",stmtYearAndMonth);
        
        if([nowYearAndMonth isEqualToString:stmtYearAndMonth]){
            // TODO
            NSString *date = [nsDate substringWithRange:NSMakeRange(6, 2)];
            //NSLog(@"date : %@",date);
            [tmpMonthScore addDataWithScore:score withDate:date withGroupNum:groupNum withRowID:rowID];
        }
    }
    sqlite3_finalize(stmt);
    return  tmpMonthScore;
}

- (DayScore *)showDataWithDate:(NSInteger)inDate withMonth:(NSInteger)inMonth withYear:(NSInteger)inYear{
    DayScore *tmpDayScore = [[DayScore alloc]init];
    
    NSString *queryStr = @"SELECT Date, GroupNum, TotalScore, rowid, handy FROM personnalRecord";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data  : %s", ret, sqlite3_errmsg(db));
    
    //모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *date = (char *)sqlite3_column_text(stmt,0);
        int groupNum = (int)sqlite3_column_int(stmt, 1);
        int score = (int)sqlite3_column_int(stmt, 2);
        int rowID = (int)sqlite3_column_int(stmt, 3);
        int handy = (int)sqlite3_column_int(stmt, 4);
        
        NSString *nsDate = [NSString stringWithCString:date encoding:NSUTF8StringEncoding];
        NSString *searchDate = [NSString stringWithFormat:@"%04d%02d%02d",inYear,inMonth,inDate];
        
        if([searchDate isEqualToString:nsDate]){
            [tmpDayScore addDataWithGroupNum:groupNum withTotalScore:score withRowID:rowID withHandy:handy];
        }
    }
    sqlite3_finalize(stmt);
    return  tmpDayScore;
    
}


- (BOOL)deleteDateWithRowID:(NSInteger)inRowID{
    //여기 지우는거 구현하기
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM personnalRecord WHERE rowid = %d",inRowID];
    
    NSLog(@"Delete Query : %@",queryStr);
    char *errMsg;
    int ret = sqlite3_exec(db, [queryStr UTF8String], NULL, NULL, &errMsg);
    
    if (SQLITE_OK != ret){
        NSLog(@"Error(%d) on deleting data : %s",ret,errMsg);
    }
    return false;
}


- (NSMutableDictionary *)shownByGroupRecordWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate{
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc]init];
    
    NSString *queryStr = @"SELECT Date, GroupNum, TotalScore FROM personnalRecord";
    
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s'", ret, sqlite3_errmsg(db));
    
    int myPeriodAllScore = 0;
    int myPeroidGameCnt = 0;
    //모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *date = (char *)sqlite3_column_text(stmt, 0);
        int groupNum = (int)sqlite3_column_int(stmt, 1);
        int totalScore = (int)sqlite3_column_int(stmt, 2);
        
        
        NSInteger dateInt = [[NSString stringWithCString:date encoding:NSUTF8StringEncoding] integerValue];
        NSInteger startD = [startDate integerValue];
        NSInteger endD = [endDate integerValue];
        
        if((dateInt >= startD) && (dateInt <= endD)){
            NSLog(@"%d 기간 안에 들은 값이지롱!!",dateInt);
            NSString *groupKey = [NSString stringWithFormat:@"%d",groupNum];
            NSMutableDictionary *tmpDic = returnDic[groupKey];
            
            // 일단 총 값을 더해서 보내줘야됨..? ;; ㅠㅠ
            myPeroidGameCnt++;
            myPeriodAllScore += totalScore;
            
            
            if(tmpDic == nil){
                tmpDic = [[NSMutableDictionary alloc]init];
                [tmpDic setObject:[NSString stringWithFormat:@"%d",totalScore] forKey:@"score"];
                [tmpDic setObject:@"1" forKey:@"cnt"];
                
                [returnDic setObject:tmpDic forKey:groupKey];
            }
            else{
                NSInteger nowTotalScore = [tmpDic[@"score"] integerValue];
                NSInteger nowCnt = [tmpDic[@"cnt"] integerValue];
                
                nowTotalScore += totalScore;
                nowCnt++;
                
                [tmpDic setObject:[NSString stringWithFormat:@"%d",nowTotalScore] forKey:@"score"];
                [tmpDic setObject:[NSString stringWithFormat:@"%d",nowCnt] forKey:@"cnt"];
                
                [returnDic setObject:tmpDic forKey:groupKey];
            }
        }
    }
    sqlite3_finalize(stmt);
    
    
    // 여기서 return Dic에 총점 총게임수 보내면 될거 같당!! 그걸 -1키로 해서 보내면 될ㄷ스..
    
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]init];
    [tmpDic setObject:[NSString stringWithFormat:@"%d", myPeriodAllScore] forKey:@"score"];
    [tmpDic setObject:[NSString stringWithFormat:@"%d",myPeroidGameCnt] forKey:@"cnt"];
    
    [returnDic setObject:tmpDic forKey:@"-1"];
    return returnDic;
    
}
@end
