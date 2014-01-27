//
//  testViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "testViewController.h"

@interface testViewController ()

@end

@implementation testViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    
    for(int i = 0 ; i < 5 ; i++){
        NSNumber *number = [NSNumber numberWithInteger:rand()%60+20];
        
        // add number to array
        [dataArr addObject:number];
    }
    
    [self.pieChartView renderInLayer:self.pieChartView dataArray:dataArr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
