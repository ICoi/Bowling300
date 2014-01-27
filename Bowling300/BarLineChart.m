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

@implementation BarLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
 
 - (void)drawRect:(CGRect)rect
{
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 5 ; i++){
        // make dummy data
        NSNumber *number = [NSNumber numberWithInteger:(rand()%100 + 50)];
        [dataArr addObject:number];
        NSLog(@"Make data : %@",number);
    }
    CGFloat beforeX = BARGRAPE_X;
    for(int i = 0 ; i < [dataArr count]; i++){
        // 제일 처음 막대 그래프를 그린다.
        UIBezierPath *path;
        path = [UIBezierPath bezierPathWithRect:CGRectMake(beforeX - (BAR_WIDTH/2), [[dataArr objectAtIndex:i] integerValue], BAR_WIDTH, BARGRAPE_Y)];
        [[UIColor colorWithWhite:1.0 alpha:1.0 ] setStroke];
        [[UIColor colorWithWhite:1.0 alpha:0.7] setFill];
        [path fill];
        [path stroke];
        beforeX = beforeX + BAR_SPACE;
    }
    
    
    beforeX = BARGRAPE_X;
    for(int i = 0 ; i < [dataArr count]-1 ; i++){
        // 그래프 그리기... 갯수만큼
        
        // 그다음 선을 그림..
        UIBezierPath *path;
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
        [path moveToPoint:CGPointMake(beforeX, [[dataArr objectAtIndex:i] integerValue])];
        [path setLineCapStyle:kCGLineCapRound];
        beforeX = beforeX + BAR_SPACE;
        [path addLineToPoint:CGPointMake(beforeX, [[dataArr objectAtIndex:i+1] integerValue])];
        [path stroke];
                            
    }
    
    beforeX = BARGRAPE_X;
    for(int i = 0 ; i < [dataArr count]; i++){
        // 그다음 해당 선에 해당하는 곳에 동그라미 점 찍음
        UIBezierPath *path;
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(beforeX - (CIRCLE_RADIUS/2), [[dataArr objectAtIndex:i] integerValue] - (CIRCLE_RADIUS/2),CIRCLE_RADIUS, CIRCLE_RADIUS)];
        [[UIColor colorWithWhite:1.0 alpha:1.0] setStroke];
        [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
        [path setLineWidth:3.0];
        [path fillWithBlendMode:kCGBlendModeScreen alpha:1.0 ];
        [path strokeWithBlendMode:kCGBlendModePlusDarker alpha:0.9];
        
        beforeX = beforeX + BAR_SPACE;
    }
    
    
    // Drawing code
    
    /*
    // 선그리기
    UIBezierPath *path;
    path = [UIBezierPath bezierPath];
    [path setLineWidth:3.0];
    [path moveToPoint:CGPointMake(20,20)];
    [path setLineCapStyle:kCGLineCapRound];
    [path addLineToPoint:CGPointMake(280, 80)];
    [path stroke];
    
    
    // 사각형 그리기
    path = [UIBezierPath bezierPathWithRect:CGRectMake(30,40,80,90)];
    [[UIColor magentaColor] setStroke];
    [[UIColor orangeColor] setFill];
    [path fill];
    [path stroke];
     */
}


@end
