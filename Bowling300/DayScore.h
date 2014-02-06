//
//  DayScore.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayScore : NSObject
- (id)init;
- (void)addDataWithGroupNum:(NSInteger)inGroupNum withTotalScore:(NSInteger)inTotalScore withRowID:(NSInteger)inRowID;
@property (nonatomic) NSMutableArray *todayScores;
@property (nonatomic) NSInteger gameCnt;
@property (nonatomic) NSInteger highScore;
@property (nonatomic) NSInteger lowScore;
@property (nonatomic) NSInteger averageScore;
@end
