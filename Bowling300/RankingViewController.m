//
//  RankingViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "RankingViewController.h"
#import <AFNetworking.h>
#import "LoginViewController.h"
#import "DBMyInfoManager.h"
#import "AppDelegate.h"
#import "GlobalRankingCell.h"
#import <UIImageView+AFNetworking.h>
#import "InfoPopupView.h"
#define GLOBAL_RANKING 0
#define LOCAL_RANKING 1
#define GROUP_RANKING 2

#define URLLINK @"http://bowling.pineoc.cloulu.com/ranking"




@interface RankingViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger selectedRanking;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *globalRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *localRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *groupRankingBtn;
@property (weak, nonatomic) IBOutlet UITableView *rankingTable;

@property (weak, nonatomic) IBOutlet UIImageView *imageFirst;
@property (weak, nonatomic) IBOutlet UIImageView *imageSecond;
@property (weak, nonatomic) IBOutlet UIImageView *imageThird;
@property (weak, nonatomic) IBOutlet UILabel *scoreFirst;
@property (weak, nonatomic) IBOutlet UILabel *scoreSecond;
@property (weak, nonatomic) IBOutlet UILabel *scoreThrid;
@property (weak, nonatomic) IBOutlet UILabel *nameFirst;
@property (weak, nonatomic) IBOutlet UILabel *nameSecond;
@property (weak, nonatomic) IBOutlet UILabel *nameThird;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRankingLabel;

@property (weak, nonatomic) IBOutlet InfoPopupView *popUpView;



@end

@implementation RankingViewController{
    NSMutableArray *rankingDataArr;
    DBMyInfoManager *dbInfoManager;
    AppDelegate *ad;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    selectedRanking = GLOBAL_RANKING;
    rankingDataArr = [[NSMutableArray alloc]init];
    dbInfoManager = [DBMyInfoManager sharedModeManager];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self getRankingFromServerWithType:GLOBAL_RANKING];
    self.myScoreLabel.font = [UIFont fontWithName:@"expansiva" size:17];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getRankingFromServerWithType:(NSInteger)inType{
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]init];
    if( inType == GLOBAL_RANKING){
        [sendDic setObject:[NSString stringWithFormat:@"%d", ad.myIDX]forKey:@"aidx"];
        [sendDic setObject:@"world" forKey:@"type"];
        [sendDic setObject:@"0" forKey:@"limit"];
        
    }else if(inType == LOCAL_RANKING){
        
        [sendDic setObject:@"12" forKey:@"allgame"];
        [sendDic setObject:@"120" forKey:@"allscore"];
        [sendDic setObject:@"world" forKey:@"type"];
        [sendDic setObject:@"0" forKey:@"limit"];
        
    }else if(inType == GROUP_RANKING){
        
        [sendDic setObject:@"12" forKey:@"allgame"];
        [sendDic setObject:@"120" forKey:@"allscore"];
        [sendDic setObject:@"world" forKey:@"type"];
        [sendDic setObject:@"0" forKey:@"limit"];
        
    }
    
    
    
    // 여기는 에러체크용
    // 여기 부분은 에러 체크용..
    __autoreleasing NSError *error;
    NSData *data =[NSJSONSerialization dataWithJSONObject:sendDic options:kNilOptions error:&error];
    NSString *stringdata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",stringdata);
    
    
    // 데이터 통신함
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager POST:URLLINK parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // TODO
        // 여기서 응답 온거 가지고 처리해야한다!!!
        NSString *result = responseObject[@"result"];
        if([result isEqualToString:@"FAIL"]){
            NSLog(@"result is fail");
        }else{
            NSLog(@"result is success");
            [rankingDataArr addObjectsFromArray:responseObject[@"arr"]];
            
            // 이미지 다시 보여줌
            [self showRanking];
           
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 실패한경우...
        NSLog(@"Error: %@", error);
    }];
}
- (IBAction)showGlobalRanking:(id)sender {
    if( selectedRanking != GLOBAL_RANKING){
        UIImage *image = [UIImage imageNamed:@"bg.png"];
        self.backgroundImage.image = image;
    
        selectedRanking = GLOBAL_RANKING;
        [self.rankingTable reloadData];
        // TODO
        // 여기서 table reload도 해야하고 사진도 바꿔야하고 할거 많음..
    }
}
- (IBAction)showLocalRanking:(id)sender {
    if( selectedRanking != LOCAL_RANKING) {
        UIImage *image = [UIImage imageNamed:@"ranking_local_bg.png"];
        self.backgroundImage.image = image;
        
        selectedRanking = LOCAL_RANKING;
        [self.rankingTable reloadData];
        // TODO
        // 여기서 table reload도 해야하고 사진도 바꾸어ㅑ하고 할거 많음
    }
    
}
- (IBAction)showGroupRanking:(id)sender {
    if(selectedRanking != GROUP_RANKING){
        UIImage *image = [UIImage imageNamed:@"ranking_group_bg.png"];
        self.backgroundImage.image = image;
     
        selectedRanking = GROUP_RANKING;
        [self.rankingTable reloadData];
        // TODO
        // 여기서 table reload도 해야하고 사진도 바꿔야됨
    }
}



// 여기 아래는 탭 버튼 누르는거
- (IBAction)goRecordPage:(id)sender {
    if([dbInfoManager isLoggined]){
        [self.tabBarController setSelectedIndex:1];
    }else{
        UIViewController *uiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_BOARD"];
        [self.navigationController pushViewController:uiVC   animated:YES];
        
    }
    //
}
- (IBAction)goGroupPage:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}
- (IBAction)goMyPage:(id)sender {
    [self.tabBarController setSelectedIndex:3];
}


- (void)showRanking{
    //이미지 보여주는 부분입니다~
    NSDictionary *one;
    NSString *photourl;
    NSURL *imageURL;
    NSURLRequest *request;
    AFHTTPRequestOperation *postOperation;
    //일단 123 등 보여준다.
    
    
    //1등부터 일단 보여줌
    one = [rankingDataArr objectAtIndex:0];
    //이미지얻어옴
    imageURL = [NSURL URLWithString:one[@"proPhoto"]];
    [self.imageFirst setImageWithURL:imageURL];
    self.nameFirst.text = one[@"name"];
    self.scoreFirst.text = [NSString stringWithFormat:@"%3.1f", [one[@"avg"] floatValue]];
    self.scoreFirst.font = [UIFont fontWithName:@"Expansiva" size:self.scoreFirst.font.pointSize];
    
    
    // 2등 보여줌
    one = [rankingDataArr objectAtIndex:1];
    //이미지얻어옴
    imageURL = [NSURL URLWithString:one[@"proPhoto"]];
    [self.imageSecond  setImageWithURL:imageURL];
    self.nameSecond.text = one[@"name"];
    self.scoreSecond.text = [NSString stringWithFormat:@"%3.1f", [one[@"avg"] floatValue]];
    self.scoreSecond.font = [UIFont fontWithName:@"Expansiva" size:self.scoreSecond.font.pointSize];
    
    // 3등 보여줌
    one = [rankingDataArr objectAtIndex:2];
    self.nameThird.text = one[@"name"];
    //이미지얻어옴
    imageURL = [NSURL URLWithString:one[@"proPhoto"]];
    [self.imageThird setImageWithURL:imageURL];
    self.scoreThrid.text = [NSString stringWithFormat:@"%3.1f", [one[@"avg"] floatValue]];
    self.scoreThrid.font = [UIFont fontWithName:@"Expansiva" size:self.scoreThrid.font.pointSize] ;

    
    //4등이후는 table이용해서 보여지도록 ㅋㅋ
    [self.rankingTable reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // TODO
    //  여기에 조건문으로 어떤 경우인지에 따라 다르게 보여줘야 할거임!
    if(selectedRanking == GLOBAL_RANKING){
        /*
        PlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PLAYLIST_CELL" forIndexPath:indexPath];
        NSInteger musicID = [_DBManager getKeyValueInListWithKey:@"musicID" index:indexPath.row];
        Music *music = [_DBManager getMusicWithMusicID:musicID];
         */
        NSDictionary *one = [rankingDataArr objectAtIndex:(indexPath.row+3)];
        NSURL *imageURL = [NSURL URLWithString:one[@"proPhoto"]];
        
        GlobalRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLOBAL_RANKING_CELL" forIndexPath:indexPath];
        
        [cell setValueWithRankingNum:(indexPath.row+4) withName:one[@"name"] withScore:one[@"avg"] withProfileImageURL:imageURL];
                return  cell;
        
    }
    else if(selectedRanking == LOCAL_RANKING){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOCAL_RANKING_CELL" forIndexPath:indexPath];
        return cell;
    }
    else if(selectedRanking == GROUP_RANKING ) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GROUP_RANKING_CELL" forIndexPath:indexPath];
        return  cell;
    }
    
    
    
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([rankingDataArr count]-3);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *one = rankingDataArr[indexPath.row+3];
    [self.popUpView setDataWithDictionary:one];
    
    [self.popUpView setHidden:NO];
    
    
    
}
@end
