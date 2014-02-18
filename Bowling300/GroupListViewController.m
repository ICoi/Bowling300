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
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "GroupLeagueViewController.h"

#define URLLINK @"http://bowling.pineoc.cloulu.com/user/grouplist"
#define GROUPWIDTH 100

@interface GroupListViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *groupListScrollView;
@property (weak, nonatomic) IBOutlet UIView *hamburgerView;
@property (weak, nonatomic) IBOutlet UIButton *hamRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamMyPageBtn;

@property (weak, nonatomic) IBOutlet UILabel *groupCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scrollViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addGroupBtn;
@end

@implementation GroupListViewController{
    UIButton *button;
    DBGroupManager *dbManager;
    NSMutableArray *groups;
    NSMutableArray *groupViews;                // group view들 담아놓는거
    BOOL hamHidden;
    BOOL nowEditMode;
    AppDelegate *ad;
    NSInteger representGroupIdx;
    NSInteger groupCnt;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbManager = [DBGroupManager sharedModeManager];
    
    
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // 화면 갱신 notification등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshGroupList" object:nil];
    
    //화면 이동 notification등록
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showGroup:) name:@"showGroup" object:nil];
 
}



- (void)viewWillAppear:(BOOL)animated{
    
    groupCnt = 0;
    
    //그룹 리스트 초기화
    groups = [[NSMutableArray alloc]init];
    groupViews = [[NSMutableArray alloc]init];
    // scrollView
    [self.groupListScrollView setScrollEnabled:YES];
    self.groupListScrollView.alwaysBounceVertical = NO;
    if(groups.count < 3){
        [self.groupListScrollView setContentSize:CGSizeMake(320, 130)];
    }else{
        [self.groupListScrollView setContentSize:CGSizeMake(GROUPWIDTH * (groups.count + 1) , 130)];
    }
    //group list를 보여준다.
    [self showGroupList];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.tabBarController.tabBar setHidden:YES];
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
    hamHidden = YES;
    nowEditMode = NO;
    //TODO
    
    representGroupIdx = dbManager.showRepresentiveGroupIdx;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGroupList{
    // 그룹 리스트들 저장하고 있는 뷰들을 저장하는 배열
    groupViews = [[NSMutableArray alloc]init];
    
    
    // 일단 그룹 리스트들을 불러옴
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    NSDictionary *parameters = @{@"aidx":[NSString stringWithFormat:@"%d",ad.myIDX]};
    NSLog(@"parameters : %@",parameters);
    AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if([responseObject[@"result"] isEqualToString:@"SUCCESS"]){
            groups = responseObject[@"group"];
            NSLog(@"groups : %@",groups);
            if (groups != nil) {
                groupCnt = groups.count;
            }
            int nowGroupI = 0;
            for(int i = 0 ; i < groupCnt ; i++){
                
                NSDictionary *nowGroup = [groups objectAtIndex:i];
                NSInteger nowGroupIdx = [nowGroup[@"gidx"]integerValue];
                
                if(nowGroupIdx == representGroupIdx){
                    // TODO@@
                    // 대표 그룹인경우 위에 보이도록 해야한다.
                    
                    GroupView *gv = [[GroupView alloc]initWithFrame:CGRectMake(72, 150, 160, 160)];
                    [gv setValueWithGroupIdx:[nowGroup[@"gidx"] integerValue] withGroupName:nowGroup[@"gname"] withDate:nowGroup[@"gdate"] withImageLink:nowGroup[@"gphoto"]];
                    [self.view addSubview:gv];
                    [groupViews addObject:gv];
                    
                } else{
                    GroupView *gv = [[GroupView alloc]initWithFrame:CGRectMake(GROUPWIDTH * nowGroupI, 20, 90, 90)];
                
              
                
                    [gv setValueWithGroupIdx:[nowGroup[@"gidx"] integerValue] withGroupName:nowGroup[@"gname"] withDate:nowGroup[@"gdate"] withImageLink:nowGroup[@"gphoto"]];
                    [self.groupListScrollView addSubview:gv];
                    [self.groupListScrollView reloadInputViews];
                
                    [groupViews addObject:gv];
                    nowGroupI++;
                }
            }
            
            self.addGroupBtn.frame = CGRectMake(GROUPWIDTH* nowGroupI, 20, 90, 90);
            if(groupCnt< 3){
                self.scrollViewBackground.frame = CGRectMake(0, 0, 320, 128);
            }else{
                self.scrollViewBackground.frame = CGRectMake(0, 0, GROUPWIDTH * (groupCnt + 1), 128);
            }
            
            if(groupCnt < 3){
                [self.groupListScrollView setContentSize:CGSizeMake(320, 130)];
            }else{
                [self.groupListScrollView setContentSize:CGSizeMake(GROUPWIDTH * (groupCnt + 1) , 130)];
            }
            
            
            
            self.groupCountLabel.text = [NSString stringWithFormat:@"total %d",groupCnt];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    
    
    
    
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


- (void)refreshView:(NSNotification *)notification{
    if([[notification name]isEqualToString:@"refreshGroupList"]){
        [self.view setNeedsDisplay];
    }
}
- (void)showGroup:(NSNotification *)notification{
    if([[notification name]isEqualToString:@"showGroup"]){
        UIViewController *uiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GROUP_STORYBOARD"];
        [self.navigationController pushViewController:uiVC   animated:YES];
    }
}
@end
