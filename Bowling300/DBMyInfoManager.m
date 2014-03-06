//
//  DBMyInfoManager.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 7..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DBMyInfoManager.h"
#import "AppDelegate.h"
#import "Person.h"
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
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self joinMemberWithIdx:[inDic[@"aidx"] integerValue]WithName:inDic[@"name"] withGender:[inDic[@"sex"]integerValue ] withCountry:inDic[@"country"] withEmail:inDic[@"email"] withPwd:@"" withHand:[inDic[@"hand"]integerValue ] withImage:inDic[@"proPhoto"]];
    ad.myIDX = [inDic[@"aidx"] integerValue];
}
//MyIdx Integer, Name Text, Gender Integer, Country Text, Email Text, Password Text, Hand Integer, Image Text, FromYear Integer, Ball Integer, Series300 Integer, Series800 Integer, Step Integer, Style Integer

-(Person *)getMyData{
    NSString *queryStr = @"SELECT * FROM myInfo";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"ERROR(%d) on resolving data : %s",ret,sqlite3_errmsg(db));
    
    while(SQLITE_ROW == sqlite3_step(stmt)){
        char *name = (char*)sqlite3_column_text(stmt, 1);
        int gender = (int)sqlite3_column_int(stmt, 2);
        char *country = (char*)sqlite3_column_text(stmt, 3);
        char *email = (char*)sqlite3_column_text(stmt, 4);
        char *pwd = (char *)sqlite3_column_text(stmt, 5);
        int hand = (int)sqlite3_column_int(stmt, 6);
        char *profileImg = (char*)sqlite3_column_text(stmt, 7);
        int fromYear = (int)sqlite3_column_int(stmt, 8);
        int ball = (int)sqlite3_column_int(stmt, 9);
        int series300 = (int)sqlite3_column_int(stmt, 10);
        int series800 = (int)sqlite3_column_int(stmt, 11);
        int step = (int)sqlite3_column_int(stmt, 12);
        int style = (int)sqlite3_column_int(stmt, 13);
        
        Person *one = [[Person alloc]init];
        [one setValueWithName:[NSString stringWithCString:name encoding:NSUTF8StringEncoding] withGender:gender withCountry:[NSString stringWithCString:country encoding:NSUTF8StringEncoding] withEmail:[NSString stringWithCString:email encoding:NSUTF8StringEncoding] withPWD:[NSString stringWithCString:pwd encoding:NSUTF8StringEncoding] withHand:hand withProfileImg:[NSString stringWithCString:profileImg encoding:NSUTF8StringEncoding] withFromyear:fromYear withBallPound:ball withSeries300:series300 withSeries800:series800 withStep:step withStyle:style];
        sqlite3_finalize(stmt);
        return one;
    }
    return nil;
}
-(BOOL)setMyDataWithPerson:(Person *)me{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *queryStr = @"DELETE FROM myInfo";
    sqlite3_stmt *stmt;
    
    sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    if (sqlite3_step(stmt) == SQLITE_DONE)
    {
        sqlite3_finalize(stmt);
        
    } else {
        sqlite3_finalize(stmt);
    }
    sqlite3_finalize(stmt);
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO myInfo (MyIdx, Name, Gender, Country, Email, Password, Hand, Image,FromYear, Ball, Series300, Series800, Step, Style) VALUES (%d, '%@',%d, '%@', '%@', '%@', %d, '%@', %d, %d, %d, %d, %d, %d)",ad.myIDX,me.name,me.gender,me.countryName,me.email,me.pwd,me.hand,me.profileImage,me.fromYear,me.ballPound,me.series300,me.series800,me.step,me.style];
    
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
@end
