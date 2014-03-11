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


#define BARGRAPE_X 18
#define BARGRAPE_Y 200
#define BARGRAPE_HEIGHT 187
#define BAR_FIRST_SPACE 15
#define BAR_SPACE 18
#define BAR_WIDTH 22
#define LINEGRAPE_HEIGHT 187
#define CIRCLE_RADIUS 4

@interface BarLineChart ()
@property NSMutableArray *averageDataArr;
@property NSMutableArray *cumDataArr;
@property (strong, nonatomic) UIImageView *imageView;
@end
@implementation BarLineChart{
    BLGraphYear *thisYearData;
    DBGraphManager *dbManager;
    
    NSInteger lastDataMonth;
    NSInteger allAverage;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.averageDataArr = [[NSMutableArray alloc]init];
        self.cumDataArr = [[NSMutableArray alloc]init];
        thisYearData = [[BLGraphYear alloc] init];
        dbManager = [DBGraphManager sharedModeManager];
        thisYearData = [dbManager arrayForBarLineGraphWithYear:2014];
    }
    return self;
}

- (void)setDataForBarLineChar{
    lastDataMonth = 0;
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
            lastDataMonth = i-1;
        }
        else {
            totalAver = totalScore / totalCnt;
        }
        [self.averageDataArr addObject:[NSString stringWithFormat:@"%d",(int)totalAver]];
        
        
        allScore += totalScore;
        allCnt += totalCnt;
        NSInteger allAver;
        if (allCnt == 0){
            allAver = 0;
        }
        else{
            allAver = allScore / allCnt;
        }
       // NSLog(@"all aver : %d",allAver);
        [self.cumDataArr addObject:[NSString stringWithFormat:@"%d",(int)allAver]];
    }
}
- (void)setDataForBarLineCharWithYear:(NSInteger)inYear{
    lastDataMonth = 0;
    allAverage = 0;
    thisYearData = [dbManager arrayForBarLineGraphWithYear:inYear];
    NSString *monthStr;
    
    NSInteger allCnt = 0;
    NSInteger allScore = 0;
    self.averageDataArr = [[NSMutableArray alloc]init];
    for(int i = 1 ; i < 13 ; i++){
        monthStr = [NSString stringWithFormat:@"%02d",i];
        BLGraphMonth *nowMonth = thisYearData.months[monthStr];
        
        NSInteger totalScore =nowMonth.totalScore;
        NSInteger totalCnt = nowMonth.totalGameCnt;
        NSInteger totalAver;
        if(totalCnt == 0){
            totalAver = 0;
            
        }
        else {
            totalAver = totalScore / totalCnt;
            
            lastDataMonth = i;
        }
        
        [self.averageDataArr addObject:[NSString stringWithFormat:@"%d",(int)totalAver]];
        
        
        allScore += totalScore;
        allCnt += totalCnt;
        NSInteger allAver;
        
        
        if (allCnt == 0){
            allAver = 0;
        }
        else{
            allAver = allScore / allCnt;
        }
        [self.cumDataArr addObject:[NSString stringWithFormat:@"%d",(int)allAver]];
    }
    if(allCnt != 0){
        allAverage = allScore/allCnt;
    }
}
- (void)setDataForBarLineCharWithGroupNum:(NSInteger)inGroupNum{
    NSString *monthStr;
    NSString *groupStr;
    
    NSInteger allCnt = 0;
    NSInteger allScore = 0;
    self.averageDataArr = [[NSMutableArray alloc]init];
    for(int i = 1 ; i < 13 ; i++){
        monthStr = [NSString stringWithFormat:@"%02d",i];
        BLGraphMonth *nowMonth = thisYearData.months[monthStr];
        groupStr = [NSString stringWithFormat:@"%d",(int)inGroupNum];
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
        
        [self.averageDataArr addObject:[NSString stringWithFormat:@"%d",(int)totalAver]];
        
        
        allScore += totalScore;
        allCnt += totalCnt;
        NSInteger allAver;
        if (allCnt == 0){
            allAver = 0;
        }
        else{
            allAver = allScore / allCnt;
        }
        [self.cumDataArr addObject:[NSString stringWithFormat:@"%d",(int)allAver]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
 
 - (void)drawRect:(CGRect)rect
{
    CGFloat beforeX = BARGRAPE_X +BAR_FIRST_SPACE + (BAR_WIDTH/2);
    for(int i = 0 ; i < [self.averageDataArr count]; i++){
        // 여기 아래는 달 적는 부분
        UIFont *monthFont = [UIFont systemFontOfSize:10.0];
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSString *month = [NSString stringWithFormat:@"%d",(i+1)];
        
        CGPoint temp = CGPointMake(beforeX - (BAR_WIDTH/2)+10, BARGRAPE_Y + 5);
        [month drawAtPoint:temp withAttributes:@{NSFontAttributeName:monthFont,
                                                 NSParagraphStyleAttributeName:paragraphStyle
                                                 ,
                                                 NSForegroundColorAttributeName:[UIColor yellowColor]}];
        
        
        
        beforeX = beforeX + BAR_SPACE + BAR_WIDTH;
    }
    
    
    
    beforeX = BARGRAPE_X +BAR_FIRST_SPACE + (BAR_WIDTH/2);
    for(int i = 0 ; i < [self.averageDataArr count]; i++){
        if(lastDataMonth <= i){
            break;
        }
        UIColor * secondaryTextColor = nil;
        
        //mainTextColor = [UIColor blackColor];
        secondaryTextColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        
       
        
        // 제일 처음 막대 그래프를 그린다.
        UIBezierPath *path;
        // 여기서 길이 수정하기!!!
        NSInteger barHeight = [[self.averageDataArr objectAtIndex:i]integerValue] * BARGRAPE_HEIGHT / 300 ;
       // NSLog(@"bar : %d",barHeight);
        path = [UIBezierPath bezierPathWithRect:CGRectMake(beforeX - (BAR_WIDTH/2), BARGRAPE_Y - barHeight, BAR_WIDTH, barHeight)];
       // path = [UIBezierPath bezierPathWithRect:CGRectMake(beforeX - (BAR_WIDTH/2), [[self.averageDataArr objectAtIndex:i] integerValue], BAR_WIDTH, BARGRAPE_Y)];
        [[UIColor colorWithWhite:1.0 alpha:1.0 ] setStroke];
        [[UIColor colorWithWhite:1.0 alpha:0.5] setFill];
        [path fill];
        [path stroke];
        
        
        
        // 여기 아래는 점수 텍스트 적는ㄴ부분
        UIFont *font = [UIFont boldSystemFontOfSize:10.0];
        
        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSString *test = [self.averageDataArr objectAtIndex:i];
        CGPoint temp = CGPointMake(beforeX - (BAR_WIDTH/2)+3, BARGRAPE_Y - 10);
        [test drawAtPoint:temp withAttributes:@{ NSFontAttributeName: font,
                                                 NSParagraphStyleAttributeName: paragraphStyle }];
        
     
        
        beforeX = beforeX + BAR_SPACE + BAR_WIDTH;
    }
    
    
    beforeX = BARGRAPE_X +BAR_FIRST_SPACE + (BAR_WIDTH/2);
    
    for(int i = 1 ; i < [self.cumDataArr count] ; i++){
        if(lastDataMonth <= i){
            break;
        }
        // 그다음 선을 그림..
        UIBezierPath *path;
        NSInteger barHeight1 = [[self.cumDataArr objectAtIndex:i-1] integerValue] * BARGRAPE_HEIGHT/300;
        NSInteger barHeight2 = [[self.cumDataArr objectAtIndex:i] integerValue] * BARGRAPE_HEIGHT/300;
        path = [UIBezierPath bezierPath];
        [[UIColor colorWithWhite:1.0 alpha:1.0] setStroke];
        [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
        [path setLineWidth:2.0];
        [path fillWithBlendMode:kCGBlendModeScreen alpha:1.0 ];
        [path strokeWithBlendMode:kCGBlendModePlusDarker alpha:0.9];
        [path moveToPoint:CGPointMake(beforeX, BARGRAPE_Y - barHeight1)];
        [path setLineCapStyle:kCGLineCapRound];
        beforeX = beforeX + BAR_SPACE + BAR_WIDTH;
        [path addLineToPoint:CGPointMake(beforeX, BARGRAPE_Y - barHeight2)];
        [path stroke];
    }
    
    beforeX = BARGRAPE_X +BAR_FIRST_SPACE + (BAR_WIDTH/2);
    for(int i = 0 ; i < [self.cumDataArr count]; i++){
        if(lastDataMonth <= i){
            break;
        }
        // 그다음 해당 선에 해당하는 곳에 동그라미 점 찍음
        UIBezierPath *path;
        NSInteger barHeight =[[self.cumDataArr objectAtIndex:i] integerValue] * BARGRAPE_HEIGHT/300;
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(beforeX - (CIRCLE_RADIUS/2), BARGRAPE_Y - barHeight,CIRCLE_RADIUS, CIRCLE_RADIUS)];
        [[UIColor colorWithWhite:1.0 alpha:1.0] setStroke];
        [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
        [path setLineWidth:3.0];
        [path fillWithBlendMode:kCGBlendModeScreen alpha:1.0 ];
        [path strokeWithBlendMode:kCGBlendModePlusDarker alpha:0.9];
        
        beforeX = beforeX + BAR_SPACE + BAR_WIDTH;;
    }
    
    
    // 여기서 평균인 선 그리는거랑 그거 동그라미 그리는거 하기!!
    if(lastDataMonth >= 1){
        
        NSInteger barHeight = LINEGRAPE_HEIGHT * (float)allAverage/300;
        int YPosition = BARGRAPE_Y - (int)barHeight;
        // 이제 선을 그림
        UIBezierPath *path = [UIBezierPath bezierPath];
        [[UIColor colorWithRed:((float)60/255) green:((float)179/255) blue:((float)113/255) alpha:0.0]setFill];
        [[UIColor colorWithRed:((float)60/255) green:((float)179/255) blue:((float)113/255) alpha:2.0]setStroke];
        [path setLineWidth:1.0];
        [path fillWithBlendMode:kCGBlendModeScreen alpha:1.0];
        [path moveToPoint:CGPointMake(40, YPosition)];
        [path setLineCapStyle:kCGLineCapRound];
        [path addLineToPoint:CGPointMake(beforeX, YPosition)];
        [path stroke];
        
        
        // 일단 평균 표시하는 원을 그림
        
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(beforeX, YPosition-10, 20, 20)];
        [[UIColor colorWithRed:((float)60/255) green:((float)179/255) blue:((float)113/255) alpha:1.0] setFill];
        [[UIColor colorWithRed:((float)60/255) green:((float)179/255) blue:((float)113/255) alpha:1.0]setStroke];
        [path setLineWidth:20.0];
        [path fillWithBlendMode:kCGBlendModeScreen alpha:1.0];
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        
        // 이제 점수를 적음
        UIFont *font = [UIFont systemFontOfSize:9.0];
        
        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSString *test = @"Average";
        CGPoint temp = CGPointMake(beforeX-7, YPosition-9);
        [test drawAtPoint:temp withAttributes:@{ NSFontAttributeName: font,
                                                 NSParagraphStyleAttributeName: paragraphStyle }];
        
        test = [NSString stringWithFormat:@"%03.01f",(float)allAverage];
        temp = CGPointMake(beforeX , YPosition +1);
        [test drawAtPoint:temp withAttributes:@{NSFontAttributeName:font,
                                                NSParagraphStyleAttributeName:paragraphStyle}];
        
        
        
        /*
        UIBezierPath *path;
        NSInteger barHeight1 = LINEGRAPE_HEIGHT * ([[self.cumDataArr objectAtIndex:i-1] floatValue]/300);
        NSInteger barHeight2 = LINEGRAPE_HEIGHT * ([[self.cumDataArr objectAtIndex:i]floatValue]/300);
        path = [UIBezierPath bezierPath];
        [[UIColor colorWithWhite:1.0 alpha:1.0] setStroke];
        [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
        [path setLineWidth:2.0];
        [path fillWithBlendMode:kCGBlendModeScreen alpha:1.0 ];
        [path strokeWithBlendMode:kCGBlendModePlusDarker alpha:0.9];
        [path moveToPoint:CGPointMake(beforeX, LINEGRAPE_HEIGHT - barHeight1)];
        [path setLineCapStyle:kCGLineCapRound];
        beforeX = beforeX + BAR_SPACE + BAR_WIDTH;
        [path addLineToPoint:CGPointMake(beforeX, LINEGRAPE_HEIGHT - barHeight2)];
        [path stroke];
         */
        
        
        
    }
    
    
}


@end
