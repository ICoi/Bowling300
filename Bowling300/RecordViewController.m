//
//  RecordViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "RecordViewController.h"
#define START_YEAR 2000

@interface RecordViewController (){
    NSString *searchYear;
    NSString *searchMonth;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    searchYear = [NSString stringWithFormat:@""];
    searchMonth = [NSString stringWithFormat:@""];
    
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

- (IBAction)showDatePicker:(id)sender {
//    NSLog(@"search button clicked!");
    UIView *pickerView = [self.view viewWithTag:20];
//    NSLog(@"pickerview : %@",pickerView);
    
    if(pickerView.hidden == YES){
        // 숨겨진 상태인 경우 등장하기
        
        // 일단 현재의 년도와 월 가져오기
        UIViewController *subViewController = (UIViewController *)self.childViewControllers[0];
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
    NSLog(@"selected components : %d row %d text %@",component,row,item);
}
@end
