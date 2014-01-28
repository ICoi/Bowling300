//
//  GroupListViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupListViewController.h"

@interface GroupListViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *groupListScrollView;

@end

@implementation GroupListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // scrollView
    [self.groupListScrollView setScrollEnabled:YES];
    self.groupListScrollView.alwaysBounceVertical = NO;
    [self.groupListScrollView setContentSize:CGSizeMake(400, 130)];
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


@end
