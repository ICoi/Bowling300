//
//  BLGraphMonth.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 5..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "BLGraphMonth.h"
#import "BLGraphScore.h"
@implementation BLGraphMonth
- (id)init{
    self = [super init];
    if (self ) {
        self.scores = [[NSMutableDictionary alloc]init];
        self.totalScore = 0;
        self.totalGameCnt = 0 ;
    }
    return  self;
}
- (void)addDataWithGroup:(NSInteger)inGroupNum withScore:(NSInteger)inScore{
    self.totalScore += inScore;
    self.totalGameCnt++;
    NSString *keyMonth = [NSString stringWithFormat:@"%d",(int)inGroupNum];
    BLGraphScore *tmpScore = self.scores[keyMonth];
    if(tmpScore == nil){
        // 해당 그룹에 데이터가 없으면 키를 만들고 추가한다.
        tmpScore = [[BLGraphScore alloc]init];
        tmpScore.score = inScore;
        tmpScore.gameCnt = 1;
        [self.scores setObject:tmpScore forKey:keyMonth];
    }
    else{
        //해당 그룹의 점수가 있으면 그 점수에 더해서 추가한다.
        tmpScore.score += inScore;
        tmpScore.gameCnt++;
    }
    
    
}
@end
