//
//  AppDelegate.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *rankingYear;
@property (strong, nonatomic) NSString *rankingMonth;
@property (strong, nonatomic) NSString *rankingDay;

@property (strong, nonatomic) NSString *rankingStartDate;
@property (strong, nonatomic) NSString *rankingEndDate;

@property (nonatomic) NSInteger myHighScore;
@property (nonatomic) NSInteger myAllScore;
@property (nonatomic) NSInteger myGameCnt;

@property (nonatomic) NSInteger myIDX;
@end
