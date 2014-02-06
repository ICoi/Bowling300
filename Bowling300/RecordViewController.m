//
//  RecordViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "RecordViewController.h"
#import "DBPersonnalRecordManager.h"
#import "WriteRecordViewController.h"
#define START_YEAR 2000

@interface RecordViewController (){
    NSString *searchYear;
    NSString *searchMonth;
}

@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *hamburgerView;
@property (weak, nonatomic) IBOutlet UIButton *hamRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamGroupBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamMyPageBtn;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UIView *writeContainerView;

@end

@implementation RecordViewController{
    DBPersonnalRecordManager *dbPRManager;
    NSInteger nowDate;
    NSInteger nowYear;
    NSInteger nowMonth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    searchYear = [NSString stringWithFormat:@""];
    searchMonth = [NSString stringWithFormat:@""];
    
    dbPRManager = [DBPersonnalRecordManager sharedModeManager];
    
    // Notification등록하기. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWriteButtonNotification:) name:@"WriteBtnNoti" object:nil];
    
    
    // Notification등록하기.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDateNotification:) name:@"DateNoti" object:nil];
    
    
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


// Notification전달 받을 함수입니다.
- (void)receiveWriteButtonNotification:(NSNotification *)notification{
    if([[notification name] isEqualToString:@"WriteBtnNoti"]){
        NSLog(@"Successfully received the notification!");
        
        NSDictionary *userInfo = notification.userInfo;
        
        NSString *visibility = [userInfo objectForKey:@"visibility"];
        
        if([visibility isEqualToString:@"YES"]){
            [self.writeBtn setHidden:NO];
        }
        else{
            [self.writeBtn setHidden:YES];
        }
        
    }
}

// Notification전달 받을 함수입니다.
- (void)receiveDateNotification:(NSNotification *)notification{
    if([[notification name] isEqualToString:@"DateNoti"]){
        NSLog(@"Successfully received the notification!");
        NSDictionary *userInfo = notification.userInfo;
        
        nowYear = [[userInfo objectForKey:@"year"] integerValue];
        nowMonth = [[userInfo objectForKey:@"month"] integerValue];
        nowDate = [[userInfo objectForKey:@"date"]integerValue];
        // TODO
        
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showDatePicker:(id)sender {
//    NSLog(@"search button clicked!");
    UIView *pickerView = self.viewPicker;
//    NSLog(@"pickerview : %@",pickerView);
    
    if(pickerView.hidden == YES){
        // 숨겨진 상태인 경우 등장하기
        
        // 일단 현재의 년도와 월 가져오기
        UIViewController *subViewController = (UIViewController *)self.childViewControllers[1];
        UILabel *year = subViewController.view.subviews[2];
        UILabel *month = subViewController.view.subviews[3];
        
        searchYear = year.text;
        searchMonth = month.text;
        
        // 일단 처음에 보여질 칸부터 설정하기
        // 이걸로 시작지점 설정!!!
        [self.pickerView selectRow:([searchYear integerValue] - START_YEAR) inComponent:0 animated:NO];
        [self.pickerView selectRow:([searchMonth integerValue] - 1) inComponent:1 animated:NO];
        [pickerView setHidden:NO];
    
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             CGRect frame = pickerView.frame;
             frame.origin.y = 70;
             frame.origin.x = 0;
             pickerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [pickerView setHidden:NO];
             
         }];
    }
    else{
        // 다시 picker접는 경우
        // 달력에 바뀐 년도와 월을 전달한다.
        NSMutableDictionary *sendUserInfo = [[NSMutableDictionary alloc]init];
        [sendUserInfo setObject:searchYear forKey:@"year"];
        [sendUserInfo setObject:searchMonth forKey:@"month"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CalendarSearchNoti" object:nil userInfo:sendUserInfo];

        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             CGRect frame = pickerView.frame;
             frame.origin.y = -162;
             frame.origin.x = 0;
             pickerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [pickerView setHidden:YES];
             
         }];
        
        
        
        // Notification을 보냅니다.
        // Notification을 보냅니다. -> 일 데이터에 따른걸로
        NSDictionary *sendDic = @{@"type":@"Monthly", @"averageScore":[NSString stringWithFormat:@"%d",100],
                                  @"highScore":[NSString stringWithFormat:@"%d",170],
                                  @"lowScore":[NSString stringWithFormat:@"%d",30]};
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"BarChartNoti"
         object:nil userInfo:sendDic];

    }
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"WRITE_SEGUE"])
    {
        WriteRecordViewController *nextVC = (WriteRecordViewController *)segue.destinationViewController;
        nextVC.nowYear = nowYear;
        nextVC.nowMonth = nowMonth;
        nextVC.nowDate = nowDate;
    }
    
    
}


// 컴포넌트 갯수
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// 컴포넌트 별로 항목 갯수
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ( component == 0){
        return 30;
    }
    else {
        return 12;
    }
}

// 각 컴포넌트와 로우 인덱스에 해당하는 문자열 항목 반환
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0 ){
        // 연도
        return [NSString stringWithFormat:@"%d",(int)row+2000];
        
    }else{
        return [NSString stringWithFormat:@"%d",(int)row+1 ];
    }
}

// 사용자 선택시
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *item = [self pickerView:pickerView titleForRow:row forComponent:component];
   // searchYear = row;
   // searchMonth = item];
    if(component == 0){
        // year을 바꿈
        searchYear = item;
    }
    else if ( component == 1){
        // month를 바꿈
        searchMonth = item;
    }
    NSLog(@"selected components : %d row %d text %@",(int)component,(int)row,item);
}




@end
