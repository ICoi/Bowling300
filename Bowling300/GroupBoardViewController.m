//
//  GroupBoardViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupBoardViewController.h"

@interface GroupBoardViewController ()

@end

@implementation GroupBoardViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showLeague:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)showMember:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}

@end
