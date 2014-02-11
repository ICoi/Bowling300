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
-(BOOL)isLoggined{
    NSString *queryStr = @"SELECT * FROM myInfo";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s",ret, sqlite3_errmsg(db));
    //모든 행의 정보를 얻어온다
    while(SQLITE_ROW == sqlite3_step(stmt)){
        return  YES;
    }
    
    return NO;
}
-(BOOL)logOut{
    NSString *queryStr = @"DELETE FROM myInfo";
    sqlite3_stmt *stmt;
    
    sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        return  YES;
        
    } else {
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
        return idx;
    }
    return 0;
}
@end
