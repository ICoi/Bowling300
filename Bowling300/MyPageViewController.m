//
//  MyPageViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyPageViewController.h"
#import "DBMyInfoManager.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController{
    DBMyInfoManager *dbInfoManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbInfoManager = [DBMyInfoManager sharedModeManager];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}
- (IBAction)logout:(id)sender {
    if([dbInfoManager logOut]){
        NSLog(@"You Logout success!");
        [self.tabBarController setSelectedIndex:0];
    }
}
@end
