//
//  GraphViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GraphViewController.h"
#import "DBGraphManager.h"
#import "DBGroupManager.h"
#import "Group.h"

#define START_YEAR 2000
#define GROUPWIDTH 70
@interface GraphViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *barScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *groupSelectScrollView;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation GraphViewController{
    DBGraphManager *dbGManager;
    DBGroupManager *dbGroupManager;
    NSMutableArray *groups;
    NSInteger nowYear;
    UIButton *button;
    
    NSMutableArray *pieDataArr;
    NSMutableArray *pieGroupIdxArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbGManager = [DBGraphManager sharedModeManager];
    dbGroupManager = [DBGroupManager sharedModeManager];
    groups = [dbGroupManager showAllGroups];
    nowYear = 2014;
    self.yearLabel.text = [NSString stringWithFormat:@"%d",nowYear];
	// Do any additional setup after loading the view.
    
   
    [self drawGraphsWithYear:nowYear];
    
    
    // 이거 스크롤 가능하게 하는거
    [self.barScrollView setScrollEnabled:YES];
    [self.barScrollView setContentSize:CGSizeMake(400, 220)];
}

- (void)viewWillAppear:(BOOL)animated{
    [self showGroupList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGroupList{
    
    NSInteger groupCnt = groups.count;
    // scrollView
    [self.groupSelectScrollView setScrollEnabled:YES];
    [self.groupSelectScrollView setContentSize:CGSizeMake(groupCnt * GROUPWIDTH, 44)];
    
    for(int i = 0 ; i < groupCnt ; i++){
        
        Group *nowGroup = [groups objectAtIndex:i];
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(GROUPWIDTH * i, 0, 50, 30);
        [button setTitle:nowGroup.name forState:UIControlStateNormal];
        [button setTag:(10000+nowGroup.idx)];
        
        [button addTarget:self action:@selector(pressGroupName:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"name : %@",nowGroup.name);
        [self.groupSelectScrollView addSubview:button];
    }
    
}

- (void)pressGroupName:(id)sender{
    UIButton *pressBtn = (UIButton *)sender;
    NSInteger pressGroupID = pressBtn.tag - 10000;
    NSLog(@"rowID : %d",pressGroupID);
    [self drawGraphsWithYear:nowYear withGroupNum:pressGroupID];
    
    // 화면 새로고침하기
}
- (void)drawGraphsWithYear:(NSInteger)inYear{
    // TODO
    
    
    // 파이차트 그리기
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    dataArr = [dbGManager arrayForCircleGraphWithYear:inYear];
    
    [self.pieChartView renderInLayer:self.pieChartView dataArray:dataArr];
    
    
    // barline그래프 그리는거
    
    [self.barChartView init];
    [self.barChartView setDataForBarLineChar];
    
}
- (void)drawGraphsWithYear:(NSInteger)inYear withGroupNum:(NSInteger)inGroupNum{
    // TODO
    
    
    // 파이차트 그리기
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    dataArr = [dbGManager arrayForCircleGraphWithYear:inYear];
    
    [self.pieChartView renderInLayer:self.pieChartView dataArray:dataArr];
    
    
    // barline그래프 그리는거
    
    [self.barChartView init];
    [self.barChartView setDataForBarLineCharWithGroupNum:inGroupNum];
}

- (IBAction)goCalendar:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (IBAction)showPickerView:(id)sender {
    //    NSLog(@"search button clicked!");
    UIView *viewPicker = self.viewPicker;
    //    NSLog(@"pickerview : %@",pickerView);
    
    if(viewPicker.hidden == YES){
        // 숨겨진 상태인 경우 등장하기
        
        
        
        // 일단 처음에 보여질 칸부터 설정하기
        // 이걸로 시작지점 설정!!!
        [self.picker selectRow:(nowYear - START_YEAR) inComponent:0 animated:NO];
        [viewPicker setHidden:NO];
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             CGRect frame = viewPicker.frame;
             frame.origin.y = 70;
             frame.origin.x = 0;
             viewPicker.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [viewPicker setHidden:NO];
             
         }];
    }
    else{
        // 다시 picker접는 경우
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             CGRect frame = viewPicker.frame;
             frame.origin.y = -162;
             frame.origin.x = 0;
             viewPicker.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [viewPicker setHidden:YES];
             
         }];
        self.yearLabel.text = [NSString stringWithFormat:@"%d",nowYear];
        [self drawGraphsWithYear:nowYear];
        
    }

}
- (IBAction)showYearPicker:(id)sender {
}

- (IBAction)goBeforeYear:(id)sender {
    nowYear--;
    
    self.yearLabel.text = [NSString stringWithFormat:@"%d",nowYear];
    [self drawGraphsWithYear:nowYear];
    
}

- (IBAction)goAfterYear:(id)sender {
    nowYear++;
    
    self.yearLabel.text = [NSString stringWithFormat:@"%d",nowYear];
    [self drawGraphsWithYear:nowYear];
}

// 여기 아래는 Picker위해 만들어진것들.
// 컴포넌트 갯수
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// 컴포넌트 별로 항목 갯수
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 30;
}

// 각 컴포넌트와 로우 인덱스에 해당하는 문자열 항목 반환
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d",(int)row+START_YEAR];

}

// 사용자 선택시
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *item = [self pickerView:pickerView titleForRow:row forComponent:component];
        nowYear = [item integerValue];
    
}

@end
