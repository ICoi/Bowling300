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
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "WriteScoreView.h"
#import "ScoreCell.h"
#import "iAd/iAd.h"
#define URLLINK @"http://bowling300.cafe24app.com/user/score"



#define STARTX 27
#define STARTY 249
#define SCOREWIDTH 64
#define SCOREHEIGHT 30
#define MARGINWIDTH 7
#define MARGINHIEGHT 3

@interface WriteRecordViewController ()<UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *handyLabel;
@property (weak, nonatomic) IBOutlet UITextField *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISwitch *leagueSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong) UIButton *button;

@property (nonatomic, retain) IBOutlet ADBannerView *adView;
@end

@implementation WriteRecordViewController{
    NSMutableArray *buttons;
    DBPersonnalRecordManager *dbPRManager;
    DBGroupManager *dbGManager;
    DayScore *scores;
    NSMutableArray *groupNames;
    NSMutableArray *groupIdes;
    AppDelegate *ad;

    UIActionSheet *sheet;
    UIPickerView *groupPicker;
    
    NSInteger selectedGroupIdx;
    NSString *selectedGroupName;
    
    NSIndexPath *selectedIdx ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbPRManager = [DBPersonnalRecordManager sharedModeManager];
	// Do any additional setup after loading the view.
    scores.todayScores = [[NSMutableArray alloc]init];
    NSLog(@"%d %d %d",(int)self.nowDate, (int)self.nowMonth, (int)self.nowYear);
     scores = [dbPRManager showDataWithDate:self.nowDate withMonth:self.nowMonth withYear:self.nowYear];
    
    dbGManager = [DBGroupManager sharedModeManager];
    NSMutableArray *groups = [dbGManager showAllGroups];
    groupNames = [dbGManager showGroupNameWithGroupsArray:groups];
    groupIdes = [dbGManager showGroupIdxWithGroupsArray:groups];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    selectedGroupIdx = -1;
    
    self.adView.delegate = self;
    self.adView.hidden = true;
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
    self.dateLabel.text = [NSString stringWithFormat:@"%d - %d - %d",(int)self.nowYear,(int)self.nowMonth,(int)self.nowDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setYear:(NSInteger)inYear withMonth:(NSInteger)inMonth withDate:(NSInteger)inDate{
    self.nowYear = inYear;
    self.nowMonth = inMonth;
    self.nowDate = inDate;
}

// 화면 아무곳이나 클릭하면 키보드 사라짐
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pressScoreButton:(id)sender{
    UIButton *pressBtn = (UIButton *)sender;
    NSInteger pressRowID = pressBtn.tag - 10000;
    NSLog(@"rowID : %d",(int)pressRowID);
    
    
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
    NSLog(@"data string : %@",dateStr);
    
    
    [dbPRManager insertDataWithDate:dateStr withGroupNum:selectedGroupIdx withScore:@"" withHandy:handy withTotalScore:totalScore withLeague:self.leagueSwitch.on];
    self.scoreLabel.text = @"";
    
    scores = [dbPRManager showDataWithDate:self.nowDate withMonth:self.nowMonth withYear:self.nowYear];
    
    [self.collectionView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    NSInteger selectdDay = [[NSString stringWithFormat:@"%04d%02d%02d",(int)self.nowYear,(int)self.nowMonth, (int)self.nowDate] integerValue];
    
    if((selectdDay >= [ad.rankingStartDate integerValue]) && (selectdDay <= [ad.rankingEndDate integerValue])){
        
        // 해당기간에 해당하는 날짜의 점수를 수정한경우 서버에 전송함
        
        NSMutableDictionary *dataDic = [dbPRManager shownByGroupRecordWithStartDate:ad.rankingStartDate withEndDate:ad.rankingEndDate];
        
        NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]init];
        NSString *myIdx = [NSString stringWithFormat:@"%d",(int)ad.myIDX];
        [sendDic setObject:myIdx forKey:@"aidx"];
        
        NSArray *keys = [dataDic allKeys];
        NSMutableArray *datas = [[NSMutableArray alloc]init];
        
        for(int i = 0 ; i < keys.count ; i++){
            NSString *keyChk = [keys objectAtIndex:i];
            NSArray *components = [keyChk componentsSeparatedByString:@"_"];
            
            NSDictionary *oneData = dataDic[[keys objectAtIndex:i]];
            NSDictionary *oneDic;
            if([[components objectAtIndex:0] isEqualToString:@"l"]){
                // 리그전의 점수인경우
                oneDic = @{@"type":[components objectAtIndex:1],
                           @"league":@"1",
                           @"allScore":oneData[@"score"],
                           @"allGame":oneData[@"cnt"]};
            }else{
                // 그냥 점수인경우
                oneDic = @{@"type":[keys objectAtIndex:i],
                           @"league":@"0",
                           @"allScore":oneData[@"score"],
                           @"allGame":oneData[@"cnt"]};
            }
            // 원래  @"type":[keys objectAtIndexi]
            
            [datas addObject:oneDic];
        }
        [sendDic setObject:datas forKey:@"myscoredata"];
        // 여기 부분은 에러 체크용..
        __autoreleasing NSError *error;
        NSData *data =[NSJSONSerialization dataWithJSONObject:sendDic options:kNilOptions error:&error];
        NSString *stringdata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",stringdata);
        
        // 데이터 보냄
        NSLog(@"senddic : %@",sendDic);
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
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alert show];
            NSLog(@"Error: %@", error);
        }];
    }else{
        // 해당 기간의 날짜를 편집한게 아니라면 그냥 끝냄
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)selectGroup:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Groups" delegate:self cancelButtonTitle:@"Cancle" destructiveButtonTitle:nil otherButtonTitles: nil];
    for(int i = 0 ; i < groupNames.count; i++){
        [actionSheet addButtonWithTitle:[groupNames objectAtIndex:i]];
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex != actionSheet.cancelButtonIndex){
        selectedGroupIdx = [[groupIdes objectAtIndex:(buttonIndex-1)] integerValue];
        selectedGroupName = [groupNames objectAtIndex:(buttonIndex-1)];
    
        self.groupLabel.text = selectedGroupName;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return scores.gameCnt;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ScoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCORE_CELL" forIndexPath:indexPath];
    
    Score *one = [scores.todayScores objectAtIndex:indexPath.row];
    
    BOOL handy = FALSE;
    if(one.handy != 0){
        handy = TRUE;
    }
    [cell setValueWithRowIDX:one.rowID withscore:[NSString stringWithFormat:@"%d",(int)one.totalScore] withHandy:handy withColor:one.groupColor];
    return  cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Do you want to delete this socore?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    selectedIdx = indexPath;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.firstOtherButtonIndex){
        
        
        ScoreCell *cell = (ScoreCell *)[self.collectionView
                           cellForItemAtIndexPath:selectedIdx];
        
        NSInteger rowIdx = cell.rowIdx;
        NSLog(@"rowdix : %d",(int)rowIdx);
        [dbPRManager deleteDateWithRowID:rowIdx];
        
        scores = [dbPRManager showDataWithDate:self.nowDate withMonth:self.nowMonth withYear:self.nowYear];
        [self.collectionView reloadData];
        
    }
}



// About IAD
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    self.adView.hidden = false;
    NSLog(@"Has ad, showing");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    self.adView.hidden = true;
    NSLog(@"No ad To Display");
}

/*
 //TODO
 -        selectedGroupIdx = [[groupIdes objectAtIndex:(buttonIndex )] integerValue];
 -        selectedGroupName = [groupNames objectAtIndex:(buttonIndex)];
 -
 -        self.groupLabel.text = selectedGroupName;
 */
@end
