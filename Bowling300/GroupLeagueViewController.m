//
//  GroupLeagueViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupLeagueViewController.h"

@interface GroupLeagueViewController ()

@end

@implementation GroupLeagueViewController


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


- (IBAction)showBoard:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

- (IBAction)showMember:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}

@end
