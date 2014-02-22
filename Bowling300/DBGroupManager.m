//
//  DBGroupManager.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 5..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DBGroupManager.h"
#import "Group.h"
@implementation DBGroupManager
static DBGroupManager *_instance = nil;
+ (id)sharedModeManager{
    if (nil == _instance){
        _instance = [[DBGroupManager alloc] init];
        [_instance openDB];
    }
    return _instance;
}


- (BOOL)addDataInGroupTableWithGroupIdx:(NSInteger)inIdx withGroupName:(NSString *)inGroupName withGroupRedColor:(NSInteger)inRed withGroupGreenColor:(NSInteger)inGreen withGroupBlueColor:(NSInteger)inBlue{
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO myGroup(groupIdx, groupName, groupRColor, groupGColor, groupBColor) VALUES (%d, '%@', %d, %d, %d )",(int)inIdx,inGroupName,(int)inRed,(int)inGreen,(int)inBlue];
    
    NSLog(@"insertQuery : %@",insertQuery);
    char *errorMsg;
    int ret = sqlite3_exec(db, [insertQuery UTF8String], nil, nil, &errorMsg);
    
    if (ret != SQLITE_OK){
        NSLog(@"Error on Insert Query : %s",errorMsg);
        return NO;
    }
    
    sqlite3_last_insert_rowid(db);
    return YES;
}

- (NSMutableArray *)showAllGroups{
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    NSString *queryStr = @"SELECT groupIdx, groupName, groupRColor, groupGColor, groupBColor FROM myGroup";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s",ret,sqlite3_errmsg(db));
    
    //모든 행의 정보를 얻어온다.
    while(SQLITE_ROW == sqlite3_step(stmt)){
        int groupIdx = (int)sqlite3_column_int(stmt, 0);
        char *groupName = (char *)sqlite3_column_text(stmt, 1);
        int redColor = (int)sqlite3_column_int(stmt, 2);
        int greenColor = (int)sqlite3_column_int(stmt, 3);
        int blueColor = (int)sqlite3_column_int(stmt, 4);
        
        NSString *nsGroupName = [NSString stringWithCString:groupName encoding:NSUTF8StringEncoding];
        
        Group *one = [[Group alloc]init];
        one.idx = groupIdx;
        one.name = nsGroupName;
        one.color = [UIColor colorWithRed:((float)redColor/255) green:((float)greenColor/255) blue:((float)blueColor/255) alpha:1.0];
        
        [groups addObject:one];
    }
    sqlite3_finalize(stmt);
    
    
    return  groups;
}
- (NSInteger)showRepresentiveGroupIdx{
    //"CREATE TABLE IF NOT EXISTS myGroup(groupIdx Integer, groupName Text, groupRColor Integer, groupGColor Integer, groupBColor Integer, Represent BOOL)"
    NSString *queryStr = @"SELECT groupIdx FROM myGroup where Represent = 1";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR (%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    while(SQLITE_ROW == sqlite3_step(stmt)){
        int groupIdxd = (int)sqlite3_column_int(stmt, 0);
        sqlite3_finalize(stmt);
        return  groupIdxd;
    }
    return  0;
}


- (void)setRepresentiveGroupWithGroupIdx:(NSInteger)inGroupIdx{
    
    // 일단 기존의 대표 그룹을 해제시킨다
    sqlite3_stmt *stmt;
    NSString *queryString = [NSString stringWithFormat:@"UPDATE myGroup SET Represent=0"];
    int ret = sqlite3_prepare_v2(db, [queryString UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    
    // 새로운 것을 대표그룹으로 설정한다.
    queryString = [NSString stringWithFormat:@"UPDATE myGroup SET Represent=1 WHERE groupIdx=%d",(int)inGroupIdx];
    ret = sqlite3_prepare_v2(db, [queryString UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR (%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}
- (UIColor *)showGroupColorWithGroupIdx:(NSInteger)inGroupIdx{
    NSString *queryStr = [NSString stringWithFormat: @"SELECT groupRColor, groupGColor, groupBColor FROM myGroup where groupIdx = %d",inGroupIdx ];;
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR (%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    while(SQLITE_ROW == sqlite3_step(stmt)){
        int groupRColor = (int)sqlite3_column_int(stmt, 0);
        int groupGColor = (int)sqlite3_column_int(stmt, 1);
        int groupBColor = (int)sqlite3_column_int(stmt, 2);
        float rColor = (float)groupRColor/255;
        float gColor = (float)groupGColor/255;
        float bColor = (float)groupBColor/255;
        UIColor *tmpColor = [UIColor colorWithRed:rColor green:gColor blue:bColor alpha:0.7];
        sqlite3_finalize(stmt);
        return  tmpColor;
    }
    return  [UIColor blackColor];
}
- (NSString *)showGroupNameWithGroupIdx:(NSInteger)inGroupIdx{
    NSString *queryStr = [NSString stringWithFormat: @"SELECT groupName FROM myGroup where groupIdx = %d",inGroupIdx ];;
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR (%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *groupName = (char *)sqlite3_column_text(stmt, 0 );
        
        NSString *name = [NSString stringWithCString:groupName encoding:NSUTF8StringEncoding];
        sqlite3_finalize(stmt);
        return  name;
    }
    return  nil;
}

- (BOOL)deleteGroupDataWithGroupIdx:(NSInteger)inIdx{
    //여기 지우는거 구현하기
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM myGroup WHERE groupIdx = %d", inIdx];
    
    NSLog(@"Delete Query : %@",queryStr);
    char *errMsg;
    int ret = sqlite3_exec(db, [queryStr UTF8String], NULL, NULL, &errMsg);
    
    if (SQLITE_OK != ret){
        NSLog(@"Error(%d) on deleting data : %s",ret,errMsg);
    }
    return false;
}
-(BOOL)logOut{
    NSString *queryStr = @"DELETE FROM myGroup";
    sqlite3_stmt *stmt;
    
    sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        sqlite3_finalize(stmt);
        return  YES;
        
    } else {
        sqlite3_finalize(stmt);
        return  NO;
    }
    sqlite3_finalize(stmt);
    return NO;
    
}


- (NSMutableArray *)showGroupNameWithGroupsArray:(NSMutableArray *)inGroups{
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    int arrLen = inGroups.count;
    for(int i = 0 ; i < arrLen ; i++){
        Group *one = [inGroups objectAtIndex:i];
        [returnArr addObject:one.name];
    }
    return returnArr;
}
- (NSMutableArray *)showGroupIdxWithGroupsArray:(NSMutableArray *)inGroups{
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    int arrLen = inGroups.count;
    for(int i = 0 ; i < arrLen ; i++){
        Group *one = [inGroups objectAtIndex:i];
        [returnArr addObject:[NSString stringWithFormat:@"%d",one.idx]];
    }
    return returnArr;
}
- (NSMutableArray *)showGroupColorWithGroupsArray:(NSMutableArray *)inGroups{
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    int arrLen = inGroups.count;
    for(int i = 0 ; i < arrLen ; i++){
        Group *one = [inGroups objectAtIndex:i];
        [returnArr addObject:one.color];
    }
    return returnArr;
}


- (void)setGroupDataWhenLoginedWithJSON:(NSArray *)inArr{
    for(int i = 0 ; i < inArr.count ; i++){
        NSDictionary *one = [inArr objectAtIndex:i];
        NSInteger rColor = arc4random()%255;
        NSInteger gColor = arc4random()%255;
        NSInteger bColor= arc4random()%255;
        [self addDataInGroupTableWithGroupIdx:one[@"gidx"] withGroupName:one[@"gname"] withGroupRedColor:rColor withGroupGreenColor:gColor withGroupBlueColor:bColor];
    }
    
    //
}
@end
