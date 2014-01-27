//
//  RecordViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
        // 숨겨진 상태인경우 등장시키기
        [pickerView setHidden:NO];
    
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
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
        // 일단 달력 reload 하기!
        UIViewController *subViewController = (UIViewController *)self.childViewControllers[0];
        [subViewController.view.subviews[1] reloadData];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
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
        return [NSString stringWithFormat:@"%d",(int)row+2012];
        
    }else{
        return [NSString stringWithFormat:@"%d",(int)row+1 ];
    }
}

// 사용자 선택시
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *item = [self pickerView:pickerView titleForRow:row forComponent:component];
    // 이거 정보 저장하고 여기 밑에꺼는 버튼 다시 눌렀을때 하기!!!
    // TODO
    NSLog(@"selected components : %d row %d text %@",component,row,item);
}
@end
