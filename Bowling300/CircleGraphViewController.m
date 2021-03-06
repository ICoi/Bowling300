//
//  CircleGraphViewController.m
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "CircleGraphViewController.h"
#import "DBGraphManager.h"
@interface CircleGraphViewController (){
    NSMutableArray *dataArr;
    DBGraphManager *dbGManager;
}
@end

@implementation CircleGraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbGManager = [DBGraphManager sharedModeManager];
	// Do any additional setup after loading the view.
    dataArr = [[NSMutableArray alloc]init];
    // 여기에 원을 위한 데이터가 들어감!!
    /*
        for(int i = 0 ; i < 5 ; i++){
            NSNumber *number = [NSNumber numberWithInteger:rand()%60+20];
            
            // add number to array
            [dataArr addObject:number];
        }
      */
    dataArr = [dbGManager arrayForCircleGraphWithYear:2014];
        [self.pieChartView renderInLayer:self.pieChartView dataArray:dataArr];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
