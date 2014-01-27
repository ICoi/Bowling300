//
//  GraphViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < 5 ; i++){
        NSMutableArray *dataArr = [[NSMutableArray alloc]init];
        
        for(int i = 0 ; i < 5 ; i++){
            NSNumber *number = [NSNumber numberWithInteger:rand()%60+20];
            
            // add number to array
            [dataArr addObject:number];
        }
        
        [self.pieChartView renderInLayer:self.pieChartView dataArray:dataArr];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    // 네비게이션 바 보이지 않게 한다.
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goCalendar:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
