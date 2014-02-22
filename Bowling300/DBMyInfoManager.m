//
//  DBMyInfoManager.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 7..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DBMyInfoManager.h"

@implementation DBMyInfoManager
static DBMyInfoManager *_instance = nil;
+ (id)sharedModeManager{
    if (nil == _instance){
        _instance = [[DBMyInfoManager alloc] init];
        [_instance openDB];
    }
    return _instance;
}
- (BOOL)joinMemberWithIdx:(NSInteger)inIdx WithName:(NSString *)inName withGender:(BOOL)inGender withCountry:(NSString *)inCountry withEmail:(NSString *)inEmail withPwd:(NSString *)inPwd withHand:(BOOL)inHand withImage:(NSString *)inImage{
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO myInfo (MyIdx, Name, Gender, Country, Email, Password, Hand, Image) VALUES (%d, '%@',%d, '%@', '%@', '%@', %d, '%@')",inIdx,inName, inGender, inCountry, inEmail, inPwd, inHand, inImage];
    
    NSLog(@"InsertQuery : %@",insertQuery);
    char *errorMsg;
    int ret = sqlite3_exec(db, [insertQuery UTF8String], nil, nil, &errorMsg);
    
    if(ret != SQLITE_OK){
        NSLog(@"Error on InsertQuery : %s", errorMsg);
        return NO;
    }
    
    sqlite3_last_insert_rowid(db);
    return YES;
}
- (NSString *)showUsername{
    NSString *queryStr = @"SELECT Name FROM myInfo";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *name = (char *)sqlite3_column_text(stmt, 0);
        
        NSString *returnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        sqlite3_finalize(stmt);
        return returnName;
    }
    return nil;
}

- (NSString *)showUserProfile{
    NSString *queryStr = @"SELECT Image FROM myInfo";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s", ret, sqlite3_errmsg(db));
    
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *image = (char *)sqlite3_column_text(stmt, 0);
        
        NSString *returnName = [NSString stringWithCString:image encoding:NSUTF8StringEncoding];
        sqlite3_finalize(stmt);
        return returnName;
    }
    return nil;
}
-(BOOL)isLoggined{
    NSString *queryStr = @"SELECT * FROM myInfo";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s",ret, sqlite3_errmsg(db));
    //모든 행의 정보를 얻어온다
    while(SQLITE_ROW == sqlite3_step(stmt)){
        sqlite3_finalize(stmt);
        return  YES;
    }
    sqlite3_finalize(stmt);
    
    return NO;
}
-(BOOL)logOut{
    NSString *queryStr = @"DELETE FROM myInfo";
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
-(NSInteger)showMyIdx{
    NSString *queryStr = @"SELECT MyIdx FROM myInfo";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s",ret,sqlite3_errmsg(db));
    
    while(SQLITE_ROW == sqlite3_step(stmt)){
        int idx = (int)sqlite3_column_int(stmt, 0);
        sqlite3_finalize(stmt);
        return idx;
    }
    sqlite3_finalize(stmt);
    return 0;
}


-(void)setMyDataWhenLoginedWithDic:(NSDictionary *)inDic{
    [self joinMemberWithIdx:[inDic[@"aidx"] integerValue]WithName:inDic[@"name"] withGender:[inDic[@"sex"]integerValue ] withCountry:inDic[@"country"] withEmail:inDic[@"email"] withPwd:@"" withHand:[inDic[@"hand"]integerValue ] withImage:inDic[@"proPhoto"]];
}
@end
