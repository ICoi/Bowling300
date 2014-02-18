//
//  GroupMainViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupMainViewController.h"
#import "DBGroupManager.h"
#import "AppDelegate.h"

@interface GroupMainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GroupMainViewController{
    DBGroupManager *dbManager;
    AppDelegate *ad;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    dbManager = [DBGroupManager sharedModeManager];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *groupName = [dbManager showGroupNameWithGroupIdx:ad.selectedGroupIdx];
    self.titleLabel.text = groupName;
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
