//
//  RecordViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

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
    NSLog(@"search button clicked!");
    UIView *pickerView = [self.view viewWithTag:20];
    NSLog(@"pickerview : %@",pickerView);
    
    if(pickerView.hidden == YES){
        // 숨겨진 상태인경우 등장시키기
        [pickerView setHidden:NO];
    
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = pickerView.frame;
             frame.origin.y = 50;
             frame.origin.x = 0;
             pickerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [pickerView setHidden:NO];
             
         }];
    }
    else{
        // 등장해 잇는경우 다시 숨기기
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGRect frame = pickerView.frame;
             frame.origin.y = -110;
             frame.origin.x = 0;
             pickerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [pickerView setHidden:YES];
             
         }];
    }
}

@end
