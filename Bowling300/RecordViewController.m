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
#import "CalendarView.h"
#import "BarGraphView.h"

#define START_YEAR 2000

@interface RecordViewController (){
    NSString *searchYear;
    NSString *searchMonth;
}

@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UIView *writeContainerView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CalendarView *calendarView;
@property (weak, nonatomic) IBOutlet BarGraphView *barGraphView;

@end

@implementation RecordViewController{
    DBPersonnalRecordManager *dbPRManager;
    DBMyInfoManager *dbInfoManager;
    NSInteger nowDate;
    NSInteger nowYear;
    NSInteger nowMonth;
    BOOL hamHidden;
    BOOL pickerHidden;
    MonthScore *nowMonthScoreData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
    
    searchYear = [NSString stringWithFormat:@""];
    searchMonth = [NSString stringWithFormat:@""];
    
    dbPRManager = [DBPersonnalRecordManager sharedModeManager];
    dbInfoManager = [DBMyInfoManager sharedModeManager];
    
    
    [self.navigationController.navigationBar setHidden:YES];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    if([dbInfoManager isLoggined]){
        
        [self.calendarView setCalendarSetting];
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
        hamHidden = YES;
        pickerHidden = YES;
        
        
        
        NSDate *now = [NSDate date];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit |
                                        NSMonthCalendarUnit |
                                        NSDayCalendarUnit fromDate:now];
        
        nowYear = [components year];
        nowMonth = [components month];
        nowDate = [components day];
        
        NSLog(@"now %d-%d-%d",nowYear,nowMonth,nowDate);
        [self.calendarView setYear:nowYear setMonth:nowMonth setDate:nowDate];
        
    }else{
        UIViewController *uiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_BOARD"];
        [self.navigationController pushViewController:uiVC   animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if( [@"WRITE_SEGUE" isEqualToString:segue.identifier]){
        WriteRecordViewController *wrVC = (WriteRecordViewController *)segue.destinationViewController;
        [wrVC setYear:nowYear withMonth:nowMonth withDate:nowDate];
    }
}
- (void)drawBarchartWithAverageScore:(NSInteger)inAverage withHighScore:(NSInteger)inHighScore withLowScore:(NSInteger)inLowScore withGameCnt:(NSInteger)inGameCnt isMonthly:(BOOL)isMonthly{
    [self.barGraphView drawBarchartWithAverageScore:inAverage withHighScore:inHighScore withLowScore:inLowScore withGameCnt:inGameCnt isMonthly:isMonthly];
}


- (void)setYear:(NSInteger)inYear withMonth:(NSInteger)inMonth withDate:(NSInteger)inDate{
    nowYear = inYear;
    nowMonth = inMonth;
    nowDate = inDate;
}

- (IBAction)showDatePicker:(id)sender {
//    NSLog(@"search button clicked!");
    UIView *nowView = self.viewPicker;
    searchYear = [NSString stringWithFormat:@"%d",nowYear];
    searchMonth = [NSString stringWithFormat:@"%d",nowMonth];
//    NSLog(@"pickerview : %@",pickerView);
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
    [self.calendarView setYear:[searchYear integerValue] setMonth:[searchMonth integerValue] setDate:nowDate];
    
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

- (IBAction)goRankingPage:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)goGroupPage:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}
- (IBAction)goMyPage:(id)sender {
    [self.tabBarController setSelectedIndex:3];
}


@end
