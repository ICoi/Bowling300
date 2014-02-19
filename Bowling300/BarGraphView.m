//
//  BarGraphViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "BarGraphView.h"
#import "Group.h"
#import "DBGroupManager.h"
#define AVERAGESCORE 150
#define HIGHSCORE 300
#define LOWSCORE 0



#define BAR_WIDTH 169

#define Monthly @"Monthly"
#define Daily @"Daily"

#define GROUPWIDTH 70

@interface BarGraphView ()
@property (weak, nonatomic) IBOutlet UIScrollView *groupSelectScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *MonthlyDailyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *averageBar;
@property (weak, nonatomic) IBOutlet UIImageView *highBar;
@property (weak, nonatomic) IBOutlet UIImageView *lowBar;
@property (weak, nonatomic) IBOutlet UILabel *gameCountLabel;

@end

@implementation BarGraphView{
    NSString *monthlyOrDaily;
    NSMutableArray *groups;
    UIButton *button;
    DBGroupManager *dbManager;
    NSString *gameCnt;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        dbManager = [DBGroupManager sharedModeManager];
        groups = [dbManager showAllGroups];
        groups = [[NSMutableArray alloc]init];
        monthlyOrDaily = Monthly;
        
       
        //  초기에 그래프를 그림
        [self drawBarGraphWithAverage:AVERAGESCORE withHighScore:HIGHSCORE withLowScore:LOWSCORE];
        
        
        [self showGroupList];
        self.averageLabel.font = [UIFont fontWithName:@"expansiva" size:13.0];
        self.highLabel.font = [UIFont fontWithName:@"expansiva" size:13.0];
        self.lowLabel.font = [UIFont fontWithName:@"expansiva" size:13.0];
        
    }
    return  self;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self ) {
        dbManager = [DBGroupManager sharedModeManager];
        groups = [dbManager showAllGroups];
        groups = [[NSMutableArray alloc]init];
        monthlyOrDaily = Monthly;
    
        //  초기에 그래프를 그림
        [self drawBarGraphWithAverage:AVERAGESCORE withHighScore:HIGHSCORE withLowScore:LOWSCORE];
        
        
        [self showGroupList];
        self.averageLabel.font = [UIFont fontWithName:@"expansiva" size:13.0];
        self.highLabel.font = [UIFont fontWithName:@"expansiva" size:13.0];
        self.lowLabel.font = [UIFont fontWithName:@"expansiva" size:13.0];
    }
    return  self;
}



- (void)showGroupList{
    
    NSInteger groupCnt = groups.count;
    // scrollView
    [self.groupSelectScrollView setScrollEnabled:YES];
    [self.groupSelectScrollView setContentSize:CGSizeMake(groupCnt * GROUPWIDTH, 44)];
    
    for(int i = 0 ; i < groupCnt ; i++){
        
        Group *nowGroup = [groups objectAtIndex:i];
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(GROUPWIDTH * i, 0, 50, 30);
        [button setTitle:nowGroup.name forState:UIControlStateNormal];
       // NSLog(@"name : %@",nowGroup.name);
        [self.groupSelectScrollView addSubview:button];
    }
    
}

// Bar 그래프를 그리는 함수입니다.
- (void)drawBarGraphWithAverage:(NSInteger)averageScore withHighScore:(NSInteger)highScore withLowScore:(NSInteger)lowScore{
 //   NSLog(@"Draw bar chart!");
    [self moveAverageCircleWithScore:averageScore];
    [self moveHighCircleWithScore:highScore];
    [self moveLowCircleWithScore:lowScore];
}

// average circle을 이동시키는 함수입니다.
- (void)moveAverageCircleWithScore:(NSInteger)score{
    if (score >= 200) {
        [self.averageBar setHighlighted:YES];
    } else{
        [self.averageBar setHighlighted:NO];
    }
    float scoreBarWidth = [self setScoreBarWidth:score];
    [self.averageBar setFrame:CGRectMake(self.averageBar.frame.origin.x, self.averageBar.frame.origin.y, scoreBarWidth, self.averageBar.frame.size.height)];
 //   NSLog(@"%f",circleX);
   
}

// high circle을 이동시키는 함수입니다.
- (void)moveHighCircleWithScore:(NSInteger)score{
    if( score >= 200){
        [self.highBar setHighlighted:YES];
    }else{
        [self.highBar setHighlighted:NO];
    }
    float scoreBarWidth = [self setScoreBarWidth:score];
    [self.highBar setFrame:CGRectMake(self.highBar.frame.origin.x, self.highBar.frame.origin.y, scoreBarWidth, self.highBar.frame.size.height)];
 //   NSLog(@"%f",circleX);
    
}

// low circle을 이동시키는 함수입니다.
- (void)moveLowCircleWithScore:(NSInteger)score{
    if(score >=200) {
        [self.lowBar setHighlighted:YES];
    }else{
        [self.lowBar setHighlighted:NO];
    }
    float scoreBarWidth = [self setScoreBarWidth:score];
    [self.lowBar setFrame:CGRectMake(self.lowBar.frame.origin.x, self.lowBar.frame.origin.y, scoreBarWidth, self.lowBar.frame.size.height)];
//    NSLog(@"%f",circleX);
    
}

// 점수를 이용하여 막대의 길이를 리턴해주는 함수입니다.
- (float)setScoreBarWidth:(NSInteger)score{
    float scoreBarWidth = (BAR_WIDTH * ((float)score/300));
    return scoreBarWidth;
}

- (void)drawBarchartWithAverageScore:(NSInteger)inAverage withHighScore:(NSInteger)inHighScore withLowScore:(NSInteger)inLowScore withGameCnt:(NSInteger)inGameCnt isMonthly:(BOOL)isMonthly{
    if(isMonthly){
        self.MonthlyDailyLabel.text = @"Monthly";
    }else{
        self.MonthlyDailyLabel.text = @"Daily";
    }
    
    self.gameCountLabel.text = [NSString stringWithFormat:@"Game %d",inGameCnt];
    
    
    [self drawBarGraphWithAverage:inAverage withHighScore:inHighScore withLowScore:inLowScore];
    
    // Label변경한다
    self.averageLabel.text = [NSString stringWithFormat:@"%d",inAverage];
    self.highLabel.text = [NSString stringWithFormat:@"%d",inHighScore];
    self.lowLabel.text = [NSString stringWithFormat:@"%d",inLowScore];
}

@end
