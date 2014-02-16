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
#import "GroupView.h"
#define GROUPWIDTH 100

@interface GroupListViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *groupListScrollView;
@property (weak, nonatomic) IBOutlet UIView *hamburgerView;
@property (weak, nonatomic) IBOutlet UIButton *hamRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamMyPageBtn;

@property (weak, nonatomic) IBOutlet UIImageView *scrollViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addGroupBtn;
@end

@implementation GroupListViewController{
    UIButton *button;
    DBGroupManager *dbManager;
    NSArray *groups;
    NSInteger groupCnt;
    NSMutableArray *groupViews;                // group view들 담아놓는거
    BOOL hamHidden;
    BOOL nowEditMode;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbManager = [DBGroupManager sharedModeManager];
    
    
 
}


- (void)viewWillAppear:(BOOL)animated{
    
    
    //그룹 리스트 초기화
    groups = [dbManager showAllGroups];
    groupViews = [[NSMutableArray alloc]init];
    groupCnt = [groups count];
    // scrollView
    [self.groupListScrollView setScrollEnabled:YES];
    self.groupListScrollView.alwaysBounceVertical = NO;
    if(groupCnt < 3){
        [self.groupListScrollView setContentSize:CGSizeMake(320, 130)];
    }else{
        [self.groupListScrollView setContentSize:CGSizeMake(GROUPWIDTH * (groupCnt + 1) , 130)];
    }
    //group list를 보여준다.
    [self showGroupList];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.tabBarController.tabBar setHidden:YES];
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
    hamHidden = YES;
    nowEditMode = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGroupList{
    groupViews = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < groupCnt ; i++){
        
        Group *nowGroup = [groups objectAtIndex:i];
        GroupView *gv = [[GroupView alloc]initWithFrame:CGRectMake(GROUPWIDTH * i, 20, 90, 90)];
        [self.groupListScrollView addSubview:gv];
        [self.groupListScrollView reloadInputViews];
        
        [groupViews addObject:gv];
    }
    
    self.addGroupBtn.frame = CGRectMake(GROUPWIDTH* groupCnt, 20, 90, 90);
    if(groupCnt < 3){
        self.scrollViewBackground.frame = CGRectMake(0, 0, 320, 128);
    }else{
        self.scrollViewBackground.frame = CGRectMake(0, 0, GROUPWIDTH * (groupCnt + 1), 128);
    }
    
}
- (IBAction)goEditMode:(id)sender {
    if(nowEditMode == NO){
        for(int i = 0 ; i < groupViews.count; i++){
            GroupView *one = [groupViews objectAtIndex:i];
            [one setEditMode:YES];
        }
        nowEditMode = YES;
    }else{
        for(int i = 0 ; i < groupViews.count ; i++){
            GroupView *one = [groupViews objectAtIndex:i];
            [one setEditMode:NO];
        }
        nowEditMode = NO;
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!hamHidden){
        NSLog(@"Ham");
        //햄버거 뷰 숨기기
        UIView *hamView = self.hamburgerView;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:  UIViewAnimationOptionCurveEaseIn
                         animations:^
         {
             CGRect frame = hamView.frame;
             frame.origin.y = -568;
             frame.origin.x = 0;
             hamView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [hamView setHidden:NO];
             hamHidden = YES;
             
         }];
    }
    NSLog(@"Touched!!");
}
- (IBAction)goBack:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}



- (IBAction)showHamburgerList:(id)sender {
    UIView *hamView = self.hamburgerView;
    // 햄버거 버튼 보여주기
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         CGRect frame = hamView.frame;
         frame.origin.y = 0;
         frame.origin.x = 0;
         hamView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         [hamView setHidden:NO];
         hamHidden = NO;
         
     }];
    
}

- (IBAction)clickedHamListBtn:(id)sender {
    NSLog(@"Ham list button clicked!");
    UIButton *clickedButton = (UIButton *)sender;
    if(clickedButton == self.hamRankingBtn){
        [self.tabBarController setSelectedIndex:0];
    }
    else if(clickedButton == self.hamRecordBtn){
        [self.tabBarController setSelectedIndex:1];
        
    }
    else if(clickedButton == self.hamMyPageBtn){
        [self.tabBarController setSelectedIndex:3];
        
    }
    
    // 햄버거 메뉴 숨기기
    CGRect frame = self.hamburgerView.frame;
    frame.origin.y = -162;
    frame.origin.x = 0;
    self.hamburgerView.frame = frame;
    [self.hamburgerView setHidden:YES];
    
    
}

@end
