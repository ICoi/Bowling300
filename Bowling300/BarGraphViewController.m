//
//  BarGraphViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "BarGraphViewController.h"


#define AVERAGESCORE 150
#define HIGHSCORE 300
#define LOWSCORE 0


#define BAR_WIDTH 170           // Bar길이
#define BAR_START_X 65
#define AVERAGE_BAR_Y 30          // Average bar의 Y중앙 위치
#define HIGH_BAR_Y   50              //Low bar의 Y중앙위치
#define LOW_BAR_Y     70             //High bar의 Y중앙위치
#define CIRCLE_DIAMETER 16             // 원의 지름길이

@interface BarGraphViewController ()
@property UIImageView *averageCircle;
@property UIImageView *highCircle;
@property UIImageView *lowCircle;
@property UIImage *circle;

@end

@implementation BarGraphViewController

- (void)drawBarGraphWithAverage:(NSInteger)averageScore withHighScore:(NSInteger)highScore withLowScore:(NSInteger)lowScore{
    [self moveAverageCircleWithScore:averageScore];
    [self moveHighCircleWithScore:highScore];
    [self moveLowCircleWithScore:lowScore];
}

// average circle을 이동시키는 함수입니다.
- (void)moveAverageCircleWithScore:(NSInteger)score{
    float circleX = [self setXPosition:score];
    self.averageCircle.frame = CGRectMake(circleX, AVERAGE_BAR_Y, CIRCLE_DIAMETER, CIRCLE_DIAMETER);
    NSLog(@"%f",circleX);
   
}

// high circle을 이동시키는 함수입니다.
- (void)moveHighCircleWithScore:(NSInteger)score{
    float circleX = [self setXPosition:score];
    self.highCircle.frame = CGRectMake(circleX, HIGH_BAR_Y, CIRCLE_DIAMETER, CIRCLE_DIAMETER);
    NSLog(@"%f",circleX);
    
}

// low circle을 이동시키는 함수입니다.
- (void)moveLowCircleWithScore:(NSInteger)score{
    float circleX = [self setXPosition:score];
    self.lowCircle.frame = CGRectMake(circleX, LOW_BAR_Y, CIRCLE_DIAMETER, CIRCLE_DIAMETER);
    NSLog(@"%f",circleX);
    
}

// 점수를 이용하여 circle의 x위치를 리턴해주는 함수입니다.
- (NSInteger)setXPosition:(NSInteger)score{
    float xPsotion = BAR_START_X + (BAR_WIDTH * ((float)score / 300));
   
    NSLog(@"Position check : %f",xPsotion);
    return xPsotion;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 원 이미지를 가져와 초기화시킴
    self.circle = [UIImage imageNamed:@"record_circle.png"];
    self.averageCircle = [[UIImageView alloc]initWithImage:self.circle];
    self.highCircle = [[UIImageView alloc]initWithImage:self.circle];
    self.lowCircle = [[UIImageView alloc]initWithImage:self.circle];
    
    //  초기에 그래프를 그림
    [self drawBarGraphWithAverage:AVERAGESCORE withHighScore:HIGHSCORE withLowScore:LOWSCORE];
	// Do any additional setup after loading the view.
    
    // 초기에 원 모양을 추가시킴
    [self.view addSubview:self.averageCircle];
    [self.view addSubview:self.highCircle];
    [self.view addSubview:self.lowCircle];
}

- (void)viewWillAppear:(BOOL)animated{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
