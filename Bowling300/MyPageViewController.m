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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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
    
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    if([dbInfoManager logOut]){
        NSLog(@"You Logout success!");
        [self.tabBarController setSelectedIndex:0];
    }
}
- (IBAction)goRanking:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}
- (IBAction)goRecord:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}
- (IBAction)goGroup:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}
@end
