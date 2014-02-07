//
//  ViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "IntroViewController.h"
#import "DB.h"
@interface IntroViewController ()
@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    //self.dateLabel.font = [UIFont fontWithName:@"Nanum Pen Script OTF" size:self.dateLabel.font.pointSize];
    
//    self.test.font = [UIFont fontWithName:@"Expansiva"  size:self.test.font.pointSize];
    DB *newDB = [[DB alloc]init];
    [newDB openDB];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
