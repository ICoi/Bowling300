//
//  DBPersonnalRecordManager.h
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DB.h"
#import "MonthScore.h"
@interface DBPersonnalRecordManager : DB
+ (id)sharedModeManager;
- (BOOL)insertDataWithDate:(NSString *)inDate withGroupNum:(NSInteger)inGroupNum withScore:(NSString *)inScore withHandy:(NSInteger)inHandy withTotalScore:(NSInteger)inTotalScore;
- (MonthScore *)showDataWithMonth:(NSInteger)inMonth withYear:(NSInteger)inYear;
@end
