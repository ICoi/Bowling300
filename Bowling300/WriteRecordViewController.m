//
//  WriteRecordViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "WriteRecordViewController.h"
#import "DBPersonnalRecordManager.h"
#import "DBGroupManager.h"
#import "DayScore.h"
#import "Score.h"
#import <AFNetworking.h>

#define URLLINK @"http://bowling.pineoc.cloulu.com/user/score"
@interface WriteRecordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *handyLabel;
@property (weak, nonatomic) IBOutlet UITextField *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *groupLabel;


@property (strong) UIButton *button;
@end

@implementation WriteRecordViewController{
    NSMutableArray *buttons;
    DBPersonnalRecordManager *dbPRManager;
    DBGroupManager *dbGManager;
    DayScore *scores;
    NSMutableArray *groupNames;
    NSMutableArray *groupIdes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbPRManager = [DBPersonnalRecordManager sharedModeManager];
	// Do any additional setup after loading the view.
    scores.todayScores = [[NSMutableArray alloc]init];
    [self drawScores];
    
    dbGManager = [DBGroupManager sharedModeManager];
    NSMutableArray *groups = [dbGManager showAllGroups];
    groupNames = [dbGManager showGroupNameWithGroupsArray:groups];
    groupIdes = [dbGManager showGroupIdxWithGroupsArray:groups];
    
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


// 점수 적힌 버튼들 나열하는 함수
- (void)drawScores{
    scores = [dbPRManager showDataWithDate:self.nowDate withMonth:self.nowMonth withYear:self.nowYear];
    for(int i = 0 ; i < scores.gameCnt ; i++){
        Score *one = [scores.todayScores objectAtIndex:i];
        
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(70*(i%4) + 30, 250 + 50 *(i/4), 50, 40);
        self.button.backgroundColor = [UIColor yellowColor];
        [self.button setTitle:[NSString stringWithFormat:@"%d",one.totalScore] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(pressScoreButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // 여기 Tag로 해당 것의rowID 전달.
        self.button.tag = (10000 + one.rowID);
        [self.view addSubview:self.button];
        
        
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pressScoreButton:(id)sender{
    UIButton *pressBtn = (UIButton *)sender;
    NSInteger pressRowID = pressBtn.tag - 10000;
    NSLog(@"rowID : %d",pressRowID);
    
    
    [dbPRManager deleteDateWithRowID:pressRowID];
    UIView *parent = self.view.superview;
    [self.view removeFromSuperview];
    self.view = nil; // unloads the view
    [parent addSubview:self.view];
}


- (IBAction)addData:(id)sender {
    NSInteger totalScore = [self.handyLabel.text integerValue] + [self.scoreLabel.text integerValue];
    NSInteger handy = [self.handyLabel.text integerValue];
    NSString *dateStr = [NSString stringWithFormat:@"%04d%02d%02d",(int)self.nowYear,(int)self.nowMonth,(int)self.nowDate];
    NSInteger groupNum = [self.groupLabel.text integerValue];
    NSLog(@"data string : %@",dateStr);
    
    
    [dbPRManager insertDataWithDate:dateStr withGroupNum:groupNum withScore:@"" withHandy:handy withTotalScore:totalScore];
    [self drawScores];
}

- (IBAction)clickSaveBtn:(id)sender {
    
    NSMutableDictionary *dataDic = [dbPRManager shownByGroupRecordWithStartDate:@"20140105" withEndDate:@"20140111"];
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]init];
    NSString *myIdx = @"67";
    [sendDic setObject:myIdx forKey:@"aidx"];
    
    NSArray *keys = [dataDic allKeys];
    /*
    for(int i = 0 ; i < keys.count ; i++){
        NSDictionary *oneData = dataDic[[keys objectAtIndex:i]];
        // 원래  @"type":[keys objectAtIndexi]
        NSDictionary *oneDic = @{@"type":@"solo",
                                 @"allScore":oneData[@"score"],
                                 @"allGame":oneData[@"cnt"]};
        [datas addObject:oneDic];
    }
    */
    
    // TODO여기 기간에 맞는거랑 그룹별 등등 해야할듯.. 일단 정보전달은 잘 되는걸로~
    NSDictionary *oneDic = @{@"type":@"-1",
                             @"allScore":@"280",
                             @"allGame":@"10"};
    [sendDic setObject:@[oneDic] forKey:@"myscoredata"];
    
    // 여기 부분은 에러 체크용..
    __autoreleasing NSError *error;
    NSData *data =[NSJSONSerialization dataWithJSONObject:sendDic options:kNilOptions error:&error];
    NSString *stringdata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",stringdata);
    
    // 데이터 보냄
       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager POST:URLLINK parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"sendDic : %@",sendDic);
        NSLog(@"JSON: %@", responseObject);
        
        // TODO
        // 여기서 응답 온거 가지고 처리해야한다!!!
        /*
        NSString *value = responseObject[@"aidx"];
        NSLog(@"result : %@",value);
         */
        NSString *result = responseObject[@"result"];
        if([result isEqualToString:@"SUCCESS"]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            NSLog(@"Save ERROR!");
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
