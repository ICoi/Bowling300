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
        one.color = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1.0];
        
        [groups addObject:one];
    }
    sqlite3_finalize(stmt);
    
    
    return  groups;
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
@end
