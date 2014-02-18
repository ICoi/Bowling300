//
//  DBMyInfoManager.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 7..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DB.h"

@interface DBMyInfoManager : DB
+ (id)sharedModeManager;
- (BOOL)isLoggined;
- (NSString *)showUsername;
- (BOOL)joinMemberWithIdx:(NSInteger)inIdx WithName:(NSString *)inName withGender:(BOOL)inGender withCountry:(NSString *)inCountry withEmail:(NSString *)inEmail withPwd:(NSString *)inPwd withHand:(BOOL)inHand withImage:(NSString *)inImage;
- (BOOL)logOut;
-(NSInteger)showMyIdx;
@end
