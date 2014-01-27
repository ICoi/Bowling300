//
//  GroupLeagueViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupLeagueViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface GroupLeagueViewController ()


@end

@implementation GroupLeagueViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 이부분이 이미지 둥글게 만들 수 잇는 부분임.
    UIImage *image = [UIImage imageNamed:@"bg.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(20, 20, 200, 200);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 100.0f;
    [self.view addSubview:imageView];
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
