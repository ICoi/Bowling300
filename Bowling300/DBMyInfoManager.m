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

- (BOOL)joinMemberWithName:(NSString *)inName withGender:(BOOL)inGender withCountry:(NSString *)inCountry withEmail:(NSString *)inEmail withPwd:(NSString *)inPwd withHand:(BOOL)inHand withImage:(NSString *)inImage{
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO myInfo (Name, Gender, Country, Email, Password, Hand, Image) VALUES ('%@',%d, '%@', '%@', '%@', '%@', %d, '%@'",inName, inGender, inCountry, inEmail, inPwd, inHand, inImage];
    
    NSLog(@"InsertQuery : %@",insertQuery);
    char *errorMsg;
    int ret = sqlite3_exec(db, [insertQuery UTF8String], nil, nil, &errorMsg);
    
    if(ret != SQLITE_OK){
        NSLog(@"Error on InsertQuery : %@", errorMsg);
        return NO;
    }
    
    sqlite3_last_insert_rowid(db);
    return YES;
}
-(BOOL)isLoggined{
    
}
-(BOOL)logOut{
    
}
@end
