//
//  WriteRecordViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "WriteRecordViewController.h"
#import "DBPersonnalRecordManager.h"
@interface WriteRecordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *handyLabel;
@property (weak, nonatomic) IBOutlet UITextField *scoreLabel;

@end

@implementation WriteRecordViewController{
    DBPersonnalRecordManager *dbPRManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbPRManager = [DBPersonnalRecordManager sharedModeManager];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 화면 아무곳이나 클릭하면 키보드 사라짐
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 점수 기록한거를 저장함과 동시에 서버로 보내야함
- (IBAction)clickSaveBtn:(id)sender {
    
    NSInteger totalScore = [self.handyLabel.text integerValue] + [self.scoreLabel.text integerValue];
    
    // 화면 없에라는 notification보낸다
    NSDictionary *sendDic = @{@"totalScore":[NSString stringWithFormat:@"%d",(int)totalScore]};    [[NSNotificationCenter defaultCenter]postNotificationName:@"WriteNoti" object:nil userInfo:sendDic];

}

@end
