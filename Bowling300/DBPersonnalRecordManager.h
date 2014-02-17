//
//  DBPersonnalRecordManager.h
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DB.h"
#import "MonthScore.h"
#import "DayScore.h"
@interface DBPersonnalRecordManager : DB
+ (id)sharedModeManager;
- (BOOL)insertDataWithDate:(NSString *)inDate withGroupNum:(NSInteger)inGroupNum withScore:(NSString *)inScore withHandy:(NSInteger)inHandy withTotalScore:(NSInteger)inTotalScore;
- (void)setDefaultData;
- (MonthScore *)showDataWithMonth:(NSInteger)inMonth withYear:(NSInteger)inYear;
- (DayScore *)showDataWithDate:(NSInteger)inDate withMonth:(NSInteger)inMonth withYear:(NSInteger)inYear;
- (BOOL)deleteDateWithRowID:(NSInteger)inRowID;
- (NSMutableDictionary *)shownByGroupRecordWithStartDate:(NSString *)startDate withEndDate:(NSString *)endDate;

@end
