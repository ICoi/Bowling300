//
//  MyPageViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyPageViewController.h"
#import "DBMyInfoManager.h"
#import "DBGroupManager.h"
#import "DBPersonnalRecordManager.h"
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>
@interface MyPageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *gLabel;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;
@property (weak, nonatomic) IBOutlet UILabel *hLabel;

@end

@implementation MyPageViewController{
    DBMyInfoManager *dbInfoManager;
    DBGroupManager *dbGroupManager;
    DBPersonnalRecordManager *dbRecordManager;
    AppDelegate *ad;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbInfoManager = [DBMyInfoManager sharedModeManager];
    dbGroupManager = [DBGroupManager sharedModeManager];
    dbRecordManager = [DBPersonnalRecordManager sharedModeManager];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    
    NSString *myImageStr = [dbInfoManager showUserProfile];
    NSURL *myImageURL = [NSURL URLWithString:myImageStr];
    
    [self.profileImage setImageWithURL:myImageURL];
    
    self.userName.text = [dbInfoManager showUsername];
    self.gLabel.text = [NSString stringWithFormat:@"%d",(int)ad.myGameCnt];
    self.aLabel.text = [NSString stringWithFormat:@"%d",(int)ad.myAllScore];
    self.hLabel.text = [NSString stringWithFormat:@"%d",(int)ad.myHighScore];
    
    
    
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    if([dbGroupManager logOut] &&
       [dbInfoManager logOut]){
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
