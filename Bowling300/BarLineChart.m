//
//  BarLineChart.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "BarLineChart.h"
#import "BLGraphYear.h"
#import "DBGraphManager.h"
#define BARGRAPE_X 30
#define BARGRAPE_Y 200
#define BARGRAPE_HEIGHT 170
#define BAR_SPACE 30
#define BAR_WIDTH 15
#define LINEGRAPE_HEIGHT 250
#define CIRCLE_RADIUS 4

@interface BarLineChart ()
@property NSMutableArray *averageDataArr;
@property NSMutableArray *cumDataArr;

@end
@implementation BarLineChart{
    BLGraphYear *thisYearData;
    DBGraphManager *dbManager;
}
- (id)init
{
    self = [super init];
    if (self) {
        
        // Initialization code
        self.averageDataArr = [[NSMutableArray alloc]init];
        self.cumDataArr = [[NSMutableArray alloc]init];
        thisYearData = [[BLGraphYear alloc] init];
        dbManager = [DBGraphManager sharedModeManager];
        thisYearData = [dbManager arrayForBarLineGraphWithYear:2014];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.averageDataArr = [[NSMutableArray alloc]init];
        self.cumDataArr = [[NSMutableArray alloc]init];

    }
    return self;
}

- (void)setDataForBarLineChar{
    NSString *monthStr;
    
    NSInteger allCnt = 0;
    NSInteger allScore = 0;
    
    self.averageDataArr = [[NSMutableArray alloc]init];
    for(int i = 1 ; i < 13 ; i++){
        monthStr = [NSString stringWithFormat:@"%02d",i];
        BLGraphMonth *nowMonth = thisYearData.months[monthStr];
        NSInteger totalScore = nowMonth.totalScore;
        NSInteger totalCnt = nowMonth.totalGameCnt;
        NSInteger totalAver;
        
        
        if(totalCnt == 0){
            totalAver = 0;
        }
        else {
            totalAver = totalScore / totalCnt;
        }
        [self.averageDataArr addObject:[NSString stringWithFormat:@"%d",totalAver]];
        
        
        allScore += totalScore;
        allCnt += totalCnt;
        NSInteger allAver;
        if (allCnt == 0){
            allAver = 0;
        }
        else{
            allAver = allScore / allCnt;
        }
        NSLog(@"all aver : %d",allAver);
        [self.cumDataArr addObject:[NSString stringWithFormat:@"%d",allAver]];
    }
}
- (void)setDataForBarLineCharWithGroupNum:(NSInteger)inGroupNum{
    NSString *monthStr;
    NSString *groupStr;
    self.averageDataArr = [[NSMutableArray alloc]init];
    for(int i = 1 ; i < 13 ; i++){
        monthStr = [NSString stringWithFormat:@"%02d",i];
        BLGraphMonth *nowMonth = thisYearData.months[monthStr];
        groupStr = [NSString stringWithFormat:@"%d",inGroupNum];
        BLGraphScore *nowScore = nowMonth.scores[groupStr];
        
        NSInteger totalScore = nowScore.score;
        NSInteger totalCnt = nowScore.gameCnt;
        NSInteger totalAver;
        if(totalCnt == 0){
            totalAver = 0;
        }
        else {
            totalAver = totalScore / totalCnt;
        }
        
        [self.averageDataArr addObject:[NSString stringWithFormat:@"%d",totalAver]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
 
 - (void)drawRect:(CGRect)rect
{
   
    CGFloat beforeX = BARGRAPE_X;
    for(int i = 0 ; i < [self.averageDataArr count]; i++){
        // 제일 처음 막대 그래프를 그린다.
        UIBezierPath *path;
        // 여기서 길이 수정하기!!!
        NSInteger barHeight = [[self.averageDataArr objectAtIndex:i]integerValue] * BARGRAPE_HEIGHT / 300 ;
       // NSLog(@"bar : %d",barHeight);
        path = [UIBezierPath bezierPathWithRect:CGRectMake(beforeX - (BAR_WIDTH/2), BARGRAPE_HEIGHT - barHeight, BAR_WIDTH, barHeight)];
       // path = [UIBezierPath bezierPathWithRect:CGRectMake(beforeX - (BAR_WIDTH/2), [[self.averageDataArr objectAtIndex:i] integerValue], BAR_WIDTH, BARGRAPE_Y)];
        [[UIColor colorWithWhite:1.0 alpha:1.0 ] setStroke];
        [[UIColor colorWithWhite:1.0 alpha:0.7] setFill];
        [path fill];
        [path stroke];
        beforeX = beforeX + BAR_SPACE;
    }
    
    
    beforeX = BARGRAPE_X;
    
    for(int i = 1 ; i < [self.cumDataArr count] ; i++){
        // 그다음 선을 그림..
        UIBezierPath *path;
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
        [path moveToPoint:CGPointMake(beforeX, LINEGRAPE_HEIGHT - [[self.cumDataArr objectAtIndex:i-1] integerValue])];
        [path setLineCapStyle:kCGLineCapRound];
        beforeX = beforeX + BAR_SPACE;
        [path addLineToPoint:CGPointMake(beforeX, LINEGRAPE_HEIGHT - [[self.cumDataArr objectAtIndex:i] integerValue])];
        [path stroke];
                            
    }
    
    beforeX = BARGRAPE_X;
    for(int i = 0 ; i < [self.cumDataArr count]; i++){
        // 그다음 해당 선에 해당하는 곳에 동그라미 점 찍음
        UIBezierPath *path;
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(beforeX - (CIRCLE_RADIUS/2), LINEGRAPE_HEIGHT - (CIRCLE_RADIUS/2)- [[self.cumDataArr objectAtIndex:i] integerValue],CIRCLE_RADIUS, CIRCLE_RADIUS)];
        [[UIColor colorWithWhite:1.0 alpha:1.0] setStroke];
        [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
        [path setLineWidth:3.0];
        [path fillWithBlendMode:kCGBlendModeScreen alpha:1.0 ];
        [path strokeWithBlendMode:kCGBlendModePlusDarker alpha:0.9];
        
        beforeX = beforeX + BAR_SPACE;
    }
    
}


@end
