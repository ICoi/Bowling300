//
//  GroupListViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupListViewController.h"
#import "DBGroupManager.h"
#import "Group.h"
#define GROUPWIDTH 100

@interface GroupListViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *groupListScrollView;
@property (weak, nonatomic) IBOutlet UIView *hamburgerView;
@property (weak, nonatomic) IBOutlet UIButton *hamRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamMyPageBtn;

@property (weak, nonatomic) IBOutlet UIButton *addGroupBtn;
@end

@implementation GroupListViewController{
    UIButton *button;
    DBGroupManager *dbManager;
    NSArray *groups;
    NSInteger groupCnt;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbManager = [DBGroupManager sharedModeManager];
    
    
 
}


- (void)viewWillAppear:(BOOL)animated{
    // 네비게이션 바 보이지 않게 한다.
    [self.navigationController.navigationBar setHidden:YES];
    
    
    //그룹 리스트 초기화
    groups = [dbManager showAllGroups];
    groupCnt = [groups count];
    // scrollView
    [self.groupListScrollView setScrollEnabled:YES];
    self.groupListScrollView.alwaysBounceVertical = NO;
    [self.groupListScrollView setContentSize:CGSizeMake(GROUPWIDTH * (groupCnt + 1) , 130)];
    
    //group list를 보여준다.
    [self showGroupList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGroupList{
    for(int i = 0 ; i < groupCnt ; i++){
        
        Group *nowGroup = [groups objectAtIndex:i];
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(GROUPWIDTH * i, 30, 50, 30);
        [button setTitle:nowGroup.name forState:UIControlStateNormal];
        NSLog(@"name : %@",nowGroup.name);
        [self.groupListScrollView addSubview:button];
    }
    
    /*
    elf.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = CGRectMake(70*(i%4) + 30, 250 + 50 *(i/4), 50, 40);
    self.button.backgroundColor = [UIColor yellowColor];
    [self.button setTitle:[NSString stringWithFormat:@"%d",one.totalScore] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(pressScoreButton:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    self.addGroupBtn.frame = CGRectMake(GROUPWIDTH * groupCnt, 10, self.addGroupBtn.frame.size.width, self.addGroupBtn.frame.size.height);
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)showHamburgerList:(id)sender {
    UIView *hamView = self.hamburgerView;
    // 숨겨진 상태인 경우 등장하기
    
    [hamView setHidden:NO];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         CGRect frame = hamView.frame;
         frame.origin.y = 70;
         frame.origin.x = 0;
         hamView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         [hamView setHidden:NO];
         
     }];
    
}

- (IBAction)clickedHamListBtn:(id)sender {
    NSLog(@"Ham list button clicked!");
    UIButton *clickedButton = (UIButton *)sender;
    
    UIViewController *controller;
    
    if(clickedButton == self.hamRankingBtn){
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RANKINGVC"];
    }
    else if(clickedButton == self.hamRecordBtn){
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RECORDVC"];
        
    }
    else if(clickedButton == self.hamMyPageBtn){
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MYPAGEVC"];
        
    }
    
    // 햄버거 메뉴 숨기기
    CGRect frame = self.hamburgerView.frame;
    frame.origin.y = -162;
    frame.origin.x = 0;
    self.hamburgerView.frame = frame;
    [self.hamburgerView setHidden:YES];
    
    // 화면 전환하기
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
