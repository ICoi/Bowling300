//
//  DayScore.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DayScore.h"
#import "Score.h"
@implementation DayScore

/*
 
 @property (nonatomic) NSMutableArray *todayScores;
 @property (nonatomic) NSInteger gameCnt;
 @property (nonatomic) NSInteger highScore;
 @property (nonatomic) NSInteger lowScore;
 @property (nonatomic) NSInteger averageScore;
 */
- (id)init
{
    self = [super init];
    if (self) {
        self.todayScores = [[NSMutableArray alloc] init];
        self.groupScores = [[NSMutableDictionary alloc]init];
        self.gameCnt = 0;
        self.highScore = 0;
        self.lowScore = 300;
        self.averageScore = 0;
    }
    return self;
}


- (void)addDataWithGroupNum:(NSInteger)inGroupNum withTotalScore:(NSInteger)inTotalScore withRowID:(NSInteger)inRowID{
    Score *oneScore = [[Score alloc] initWithGroupNum:inGroupNum withTotalScore:inTotalScore withRowID:inRowID];
    [self.todayScores addObject:oneScore];

    NSString *key = [NSString stringWithFormat:@"%d",(int)inGroupNum];
    NSString *groupScore = self.groupScores[key];
    if(groupScore == nil){
        [self.groupScores setObject:[NSString stringWithFormat:@"%d",(int)inTotalScore] forKey:key];
    }else{
        NSInteger tmp = ([groupScore integerValue] + inTotalScore);
        [self.groupScores setObject:[NSString stringWithFormat:@"%d",(int)tmp] forKey:key];
    }
    
    if(self.highScore < inTotalScore){
        self.highScore = inTotalScore;
    }
    if(self.lowScore > inTotalScore){
        self.lowScore = inTotalScore;
    }

    
    NSInteger beforeTotal = self.averageScore * self.gameCnt;
    self.gameCnt++;
    self.averageScore = (beforeTotal + inTotalScore)/self.gameCnt;
    
  //  NSLog(@"최고점 : %d 최소점 : %d 평균 : %d 게임수 : %d",(int)self.highScore, (int)self.lowScore, (int)self.averageScore, (int)self.gameCnt);
    
    
}
- (void)addDataWithGroupNum:(NSInteger)inGroupNum withTotalScore:(NSInteger)inTotalScore withRowID:(NSInteger)inRowID withHandy:(NSInteger)inHandy{
    Score *oneScore = [[Score alloc] initWithGroupNum:inGroupNum withTotalScore:inTotalScore withRowID:inRowID withHandy:inHandy];
    [self.todayScores addObject:oneScore];
    
    NSString *key = [NSString stringWithFormat:@"%d",(int)inGroupNum];
    NSString *groupScore = self.groupScores[key];
    if(groupScore == nil){
        [self.groupScores setObject:[NSString stringWithFormat:@"%d",(int)inTotalScore] forKey:key];
    }else{
        NSInteger tmp = ([groupScore integerValue] + inTotalScore);
        [self.groupScores setObject:[NSString stringWithFormat:@"%d",(int)tmp] forKey:key];
    }
    
    if(self.highScore < inTotalScore){
        self.highScore = inTotalScore;
    }
    if(self.lowScore > inTotalScore){
        self.lowScore = inTotalScore;
    }
    
    
    NSInteger beforeTotal = self.averageScore * self.gameCnt;
    self.gameCnt++;
    self.averageScore = (beforeTotal + inTotalScore)/self.gameCnt;
    
    //  NSLog(@"최고점 : %d 최소점 : %d 평균 : %d 게임수 : %d",(int)self.highScore, (int)self.lowScore, (int)self.averageScore, (int)self.gameCnt);
}

@end
