//
//  DBGraphManager.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DB.h"
#import "BLGraphYear.h"
@interface DBGraphManager : DB

+ (id)sharedModeManager;

- (NSMutableArray *)arrayForCircleGraphWithYear:(NSInteger)inYear;
- (BLGraphYear *)arrayForBarLineGraphWithYear:(NSInteger)inYear;
- (NSString *)showNameWithGroupCount:(NSInteger)inNum;
@end
