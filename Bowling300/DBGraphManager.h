//
//  DBGraphManager.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DB.h"

@interface DBGraphManager : DB
+ (id)sharedModeManager;

- (NSMutableArray *)arrayForCircleGraphWithYear:(NSInteger)inYear;
@end
