//
//  MonthScore.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MonthScore.h"
#import "DayScore.h"
@implementation MonthScore{
    NSInteger highScore;
    NSInteger lowScore;
    NSInteger gameCnt;
    NSInteger averageScore;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.year = 0;
        self.month = 0;
        self.days = [[NSMutableDictionary alloc] init];
        highScore = 0;
        lowScore = 300;
        gameCnt = 0;
        averageScore = 0;
    }
    return self;
}
/*
 
 @property (nonatomic) NSInteger year;
 @property (nonatomic) NSInteger month;
 @property (nonatomic) NSMutableDictionary *days;
 */

- (void)addDataWithScore:(NSInteger)inTotalScore withDate:(NSString *)inDate withGroupNum:(NSInteger)inGroupNum withRowID:(NSInteger)inRowID{
    // Dictionary에 해당 요일에 데이터가 잇는지 확인한다.
    DayScore *tmpDayScore;
    tmpDayScore = self.days[inDate];
    if(tmpDayScore == nil){
        // 해당 요일에 데이터가 없으면 키를 만들고 추가한다.
        tmpDayScore = [[DayScore alloc] init];
        [tmpDayScore addDataWithGroupNum:inGroupNum withTotalScore:inTotalScore withRowID:inRowID];
        [self.days setObject:tmpDayScore forKey:inDate];
        
    }
    else{
        // 해당 요일에 데이터가 있으면 그냥 추가한다.
        [tmpDayScore addDataWithGroupNum:inGroupNum withTotalScore:inTotalScore withRowID:inRowID];
    }
    //
    
    
    if(highScore < inTotalScore){
        highScore = inTotalScore;
    }
    if(lowScore > inTotalScore){
        lowScore = inTotalScore;
    }
    
    NSInteger beforeTotal = averageScore * gameCnt;
    gameCnt++;
    averageScore = (beforeTotal + inTotalScore)/gameCnt;

    
}

- (NSInteger)getDailyHighScoreWithDate:(NSString *)inDate{
    DayScore *tmpDayScore = self.days[inDate];
    return tmpDayScore.highScore;
    
}
- (NSInteger)getDailyLowScoreWithDate:(NSString *)inDate{
    DayScore *tmpDayScore = self.days[inDate];
    return tmpDayScore.lowScore;
}
- (NSInteger)getDailyAverageScoreWithDate:(NSString *)inDate{
    DayScore *tmpDayScore = self.days[inDate];
    return tmpDayScore.averageScore;
}
-(NSInteger)getDailyGameCnt:(NSString *)inDate{
    DayScore *tmpDayScore = self.days[inDate];
    return  tmpDayScore.gameCnt;
}
- (NSInteger)getMonthlyGameCnt{
    return gameCnt;
}
- (NSInteger)getMonthlyHighScore{
    return highScore;
}
- (NSInteger)getMonthlyLowScore{
    return lowScore;
}
- (NSInteger)getMonthlyAverageScore{
    return averageScore;
}
@end
