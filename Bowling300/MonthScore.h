//
//  MonthScore.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthScore : NSObject
- (id)init;
- (void)addDataWithScore:(NSInteger)inTotalScore withDate:(NSString *)inDate withGroupNum:(NSInteger)inGroupNum;
- (NSInteger)getDailyHighScoreWithDate:(NSString *)inDate;
- (NSInteger)getDailyLowScoreWithDate:(NSString *)inDate;
- (NSInteger)getDailyAverageScoreWithDate:(NSString *)inDate;

- (NSInteger)getMonthlyHighScore;
- (NSInteger)getMonthlyLowScore;
- (NSInteger)getMonthlyAverageScore;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSMutableDictionary *days;
@end
