//
//  Score.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "Score.h"
#import "DBGroupManager.h"
@implementation Score{
    
}
- (id)init
{
    self = [super init];
    if (self) {
        self.groupNum = 0;
        self.score = @"";
        self.totalScore = 0;
    }
    return self;
}


- (id)initWithGroupNum:(NSInteger)inGroupNum withTotalScore:(NSInteger)inTotalScore withRowID:(NSInteger)inRowID{
    self = [super init];
    if(self){
        DBGroupManager *dbManager = [DBGroupManager sharedModeManager];
        self.groupNum = inGroupNum;
        self.totalScore = inTotalScore;
        self.rowID = inRowID;
        self.groupColor = [dbManager showGroupColorWithGroupIdx:inGroupNum];
    }
    return self;
}

- (id)initWithGroupNum:(NSInteger)inGroupNum withTotalScore:(NSInteger)inTotalScore withRowID:(NSInteger)inRowID withHandy:(NSInteger)inHandy{
    self = [super init];
    if(self){
        DBGroupManager *dbManager = [DBGroupManager sharedModeManager];
        self.groupNum = inGroupNum;
        self.totalScore = inTotalScore;
        self.rowID = inRowID;
        self.groupColor = [dbManager showGroupColorWithGroupIdx:inGroupNum];
        self.handy = inHandy;
    }
    return self;
}
@end
