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
#import "DBMyInfoManager.h"
#define START_YEAR 2000

@interface RecordViewController (){
    NSString *searchYear;
    NSString *searchMonth;
}

@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UIView *writeContainerView;

@property (weak, nonatomic) IBOutlet UIView *hamburgerView;
@property (weak, nonatomic) IBOutlet UIButton *hamRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamGroupBtn;
@property (weak, nonatomic) IBOutlet UIButton *hamMyPageBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RecordViewController{
    DBPersonnalRecordManager *dbPRManager;
    DBMyInfoManager *dbInfoManager;
    NSInteger nowDate;
    NSInteger nowYear;
    NSInteger nowMonth;
    BOOL hamHidden;
    BOOL pickerHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    searchYear = [NSString stringWithFormat:@""];
    searchMonth = [NSString stringWithFormat:@""];
    
    dbPRManager = [DBPersonnalRecordManager sharedModeManager];
    dbInfoManager = [DBMyInfoManager sharedModeManager];
    
    // Notification등록하기. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveWriteButtonNotification:) name:@"WriteBtnNoti" object:nil];
    
    
    // Notification등록하기.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDateNotification:) name:@"DateNoti" object:nil];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
    hamHidden = YES;
    pickerHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Notification전달 받을 함수입니다.
- (void)receiveWriteButtonNotification:(NSNotification *)notification{
    if([[notification name] isEqualToString:@"WriteBtnNoti"]){
        
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
        NSDictionary *userInfo = notification.userInfo;
        
        nowYear = [[userInfo objectForKey:@"year"] integerValue];
        nowMonth = [[userInfo objectForKey:@"month"] integerValue];
        nowDate = [[userInfo objectForKey:@"date"]integerValue];
        // TODO
        
    }
}

- (IBAction)goBack:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)showDatePicker:(id)sender {
//    NSLog(@"search button clicked!");
    UIView *nowView = self.viewPicker;
//    NSLog(@"pickerview : %@",pickerView);
    
        // 숨겨진 상태인 경우 등장하기
        
        // 일단 현재의 년도와 월 가져오기
        UIViewController *subViewController = (UIViewController *)self.childViewControllers[1];
        UILabel *year = subViewController.view.subviews[1];
        UILabel *month = subViewController.view.subviews[2];
        
        searchYear = year.text;
        searchMonth = month.text;
        
        // 일단 처음에 보여질 칸부터 설정하기
        // 이걸로 시작지점 설정!!!
        [self.pickerView selectRow:([searchYear integerValue] - START_YEAR) inComponent:0 animated:NO];
        [self.pickerView selectRow:([searchMonth integerValue] - 1) inComponent:1 animated:NO];
    
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             CGRect frame = nowView.frame;
             frame.origin.y = 0;
             frame.origin.x = 0;
             nowView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             pickerHidden = NO;
         }];

}

- (IBAction)hiddenPicker:(id)sender {
    UIView *nowView = self.viewPicker;
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
         CGRect frame = nowView.frame;
         frame.origin.y = -568;
         frame.origin.x = 0;
         nowView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         pickerHidden = YES;
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

- (IBAction)showHamburgerList:(id)sender {
    UIView *hamView = self.hamburgerView;
    
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
         hamHidden = NO;
         
     }];
    
}

- (IBAction)clickedHamListBtn:(id)sender {
    NSLog(@"Ham list button clicked!");
    
    // 햄버거 메뉴 숨기기
    CGRect frame = self.hamburgerView.frame;
    frame.origin.y = -568;
    frame.origin.x = 0;
    self.hamburgerView.frame = frame;
    UIButton *clickedButton = (UIButton *)sender;
    if(clickedButton == self.hamRankingBtn){
        [self.tabBarController setSelectedIndex:0];
    }
    else if(clickedButton == self.hamGroupBtn){
        [self.tabBarController setSelectedIndex:2];
        
    }
    else if(clickedButton == self.hamMyPageBtn){
        [self.tabBarController setSelectedIndex:3];
        
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
             hamHidden = YES;
             
         }];
    }
    NSLog(@"Touched!!");
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
