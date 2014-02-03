//
//  DBPersonnalRecordManager.h
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DB.h"

@interface DBPersonnalRecordManager : DB
+ (id)sharedModeManager;
- (BOOL)insertDataWithDate:(NSString *)inDate withGroupNum:(NSInteger)inGroupNum withScore:(NSString *)inScore withTotalScore:(NSInteger)inTotalScore;
- (void)showAllData;
@end
