//
//  GraphViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GraphViewController.h"
#import "DBGraphManager.h"
@interface GraphViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *barScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *groupSelectScrollView;
@property (weak, nonatomic) IBOutlet UIView *hamburgerView;
@property (weak, nonatomic) IBOutlet UIButton *hamRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamGroupBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamMyPageBtn;

@end

@implementation GraphViewController{
    DBGraphManager *dbGManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbGManager = [DBGraphManager sharedModeManager];
	// Do any additional setup after loading the view.
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
   
    // TODO
    dataArr = [dbGManager arrayForCircleGraphWithYear:2014];
        [self.pieChartView renderInLayer:self.pieChartView dataArray:dataArr];
    
    [self.barChartView init];
    
    // 이거 스크롤 가능하게 하는거
    [self.barScrollView setScrollEnabled:YES];
    [self.barScrollView setContentSize:CGSizeMake(400, 220)];
    [self.groupSelectScrollView setScrollEnabled:YES];
    [self.groupSelectScrollView setContentSize:CGSizeMake(400, 40)];
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

- (IBAction)goCalendar:(id)sender {
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
    else if(clickedButton == self.hamGroupBtn){
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GROUPVC"];
        
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
