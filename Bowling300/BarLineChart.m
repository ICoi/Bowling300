//
//  BarLineChart.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "BarLineChart.h"

#define BARGRAPE_X 30
#define BARGRAPE_Y 200
#define BARGRAPE_HEIGHT 200
#define BAR_SPACE 30
#define BAR_WIDTH 20

#define CIRCLE_RADIUS 4

@interface BarLineChart ()
@property NSMutableArray *averageDataArr;
@property NSMutableArray *cumDataArr;

@end
@implementation BarLineChart
- (id)init
{
    self = [super init];
    if (self) {
        
        // Initialization code
        self.averageDataArr = [[NSMutableArray alloc]init];
        self.cumDataArr = [[NSMutableArray alloc]init];
        
        // 일단은 여기서 데이터를 넣음
        for(int i = 0 ; i < 5 ; i++){
            //make dummy data
            NSNumber *number = [NSNumber numberWithInteger:(rand() %100 + 50)];
            [self.averageDataArr addObject:number];
        }
        
        for(int i = 0 ; i < 5 ; i++){
            NSNumber *number = [NSNumber numberWithInteger:(rand() % 100 + 50)];
            [self.cumDataArr addObject:number];
        }
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

// initialize data
- (void)initAverageDataWithArray:(NSArray *)inAverageData{
    [self.averageDataArr addObjectsFromArray:inAverageData];
}
- (void)initMaxDataWithArray:(NSArray *)inMaxData{
    [self.cumDataArr addObjectsFromArray:inMaxData];
}
- (void)addDataWithAverage:(NSNumber *)averageNum withMax:(NSNumber*)maxNum{
    [self.averageDataArr addObject:averageNum];
    [self.cumDataArr addObject:maxNum];
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
        path = [UIBezierPath bezierPathWithRect:CGRectMake(beforeX - (BAR_WIDTH/2), [[self.averageDataArr objectAtIndex:i] integerValue], BAR_WIDTH, BARGRAPE_Y)];
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
        [path moveToPoint:CGPointMake(beforeX, [[self.cumDataArr objectAtIndex:i-1] integerValue])];
        [path setLineCapStyle:kCGLineCapRound];
        beforeX = beforeX + BAR_SPACE;
        [path addLineToPoint:CGPointMake(beforeX, [[self.cumDataArr objectAtIndex:i] integerValue])];
        [path stroke];
                            
    }
    
    beforeX = BARGRAPE_X;
    for(int i = 0 ; i < [self.cumDataArr count]; i++){
        // 그다음 해당 선에 해당하는 곳에 동그라미 점 찍음
        UIBezierPath *path;
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(beforeX - (CIRCLE_RADIUS/2), [[self.cumDataArr objectAtIndex:i] integerValue] - (CIRCLE_RADIUS/2),CIRCLE_RADIUS, CIRCLE_RADIUS)];
        [[UIColor colorWithWhite:1.0 alpha:1.0] setStroke];
        [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
        [path setLineWidth:3.0];
        [path fillWithBlendMode:kCGBlendModeScreen alpha:1.0 ];
        [path strokeWithBlendMode:kCGBlendModePlusDarker alpha:0.9];
        
        beforeX = beforeX + BAR_SPACE;
    }
    
}


@end
