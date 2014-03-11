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
#import "DBPersonnalRecordManager.h"
#import "DBGroupManager.h"
#import "InfoPopupView.h"
#import "Person.h"
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
@property (weak, nonatomic) IBOutlet UIImageView *countryFirst;
@property (weak, nonatomic) IBOutlet UIImageView *countrySecond;
@property (weak, nonatomic) IBOutlet UIImageView *countryThird;


@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myRankingLabel;


@property (weak, nonatomic) IBOutlet UIImageView *background_123_imageView;

@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameCntLabel;

@end

@implementation RankingViewController{
    NSMutableArray *rankingDataArr;
    DBMyInfoManager *dbInfoManager;
    AppDelegate *ad;
    NSInteger representiveGroupIdx;
    DBPersonnalRecordManager *dbPersonManager;
    InfoPopupView *popUpView;
    
    NSMutableArray *peoples;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    selectedRanking = GLOBAL_RANKING;
    rankingDataArr = [[NSMutableArray alloc]init];
    dbPersonManager = [DBPersonnalRecordManager sharedModeManager];
    dbInfoManager = [DBMyInfoManager sharedModeManager];
    [self.navigationController.navigationBar setHidden:YES];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //self.myScoreLabel.font = [UIFont fontWithName:@"expansiva" size:17];
    
    
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.cornerRadius = 20.0f;
    
    popUpView = [[InfoPopupView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:popUpView];
    [popUpView setHidden:YES];
    peoples = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    
    
    ad.myName =[dbInfoManager showUsername];
    
    [dbPersonManager setDefaultData];
    
    
    [self getRankingFromServerWithType:GLOBAL_RANKING];
    
    self.highScoreLabel.text = [NSString stringWithFormat:@"%d",(int)ad.myHighScore];
    if(ad.myGameCnt != 0){
        self.averageScoreLabel.text = [NSString stringWithFormat:@"%d",(int)(ad.myAllScore / ad.myGameCnt)];
    }else{
        self.averageScoreLabel.text = @"0";
    }
    self.gameCntLabel.text = [NSString stringWithFormat:@"%d",(int)ad.myGameCnt];
    
    
    DBGroupManager *dbGroupManager = [DBGroupManager sharedModeManager];
    representiveGroupIdx = [dbGroupManager showRepresentiveGroupIdx];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)savePeoplesDataWithDic:(NSMutableArray *)inArr{
    Person *person;
    NSMutableDictionary *one;
    for(int i = 0 ; i < inArr.count; i++){
        person = [[Person alloc]init];
        one = [rankingDataArr objectAtIndex:i];
        NSLog(@"%@",one);
        NSString *name = one[@"name"];
        NSString *profile = one[@"proPhoto"];
        NSString *country = one[@"country"];
        NSString *handy = one[@"hand"];
        NSString *score = one[@"avg"];
        NSString *fromYear = @"";
        NSString *style = one[@"style"];
        NSString *step = one[@"step"];
        NSString *ballURL = one[@"proPhoto"];
        NSString *ball = @"1";
        NSString *series300 = @"1";
        NSString *series800 = @"1";
        
        
        [person setValueWithName:name withProfileURL:[NSURL URLWithString:profile] withCountryURL:[NSURL URLWithString:country] withHandy:[handy integerValue] withScore:score withYear:[fromYear integerValue] withStyle:[style integerValue] withStep:[step integerValue] withBall:[ball integerValue] with300:[series300 integerValue] with800Series:[series800 integerValue]];
        
        [peoples addObject:person];
        // rankingDataArr
    }
}

- (void)getRankingFromServerWithType:(NSInteger)inType{
    
    // 일단 값들 초기화시키기
    self.myScoreLabel.text = @"NaN";
    self.myRankingLabel.text = @"0";
    
    self.scoreFirst.text = @"NaN";
    self.scoreSecond.text = @"NaN";
    self.scoreThrid.text = @"NaN";
    
    UIImage *peopleImage = [UIImage imageNamed:@"join_img.png"];
    
    self.imageFirst.image = peopleImage;
    self.imageSecond.image = peopleImage;
    self.imageThird.image = peopleImage;
    
    self.nameFirst.text = @"name";
    self.nameSecond.text = @"name";
    self.nameThird.text = @"name";
    
    self.countryFirst.image = nil;
    self.countrySecond.image = nil;
    self.countryThird.image = nil;
    
    
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]init];
    if( inType == GLOBAL_RANKING){
        [sendDic setObject:[NSString stringWithFormat:@"%d", (int)ad.myIDX]forKey:@"aidx"];
        [sendDic setObject:@"world" forKey:@"type"];
        [sendDic setObject:@"0" forKey:@"limit"];
        
    }else if(inType == LOCAL_RANKING){
        
        [sendDic setObject:[NSString stringWithFormat:@"%d",(int)ad.myIDX] forKey:@"aidx"];
        [sendDic setObject:@"local" forKey:@"type"];
        [sendDic setObject:@"0" forKey:@"limit"];
        
    }else if(inType == GROUP_RANKING){
        [sendDic setObject:[NSString stringWithFormat:@"%d",(int)ad.myIDX] forKey:@"aidx"];
        [sendDic setObject:[NSString stringWithFormat:@"%d",(int)representiveGroupIdx] forKey:@"type"];
        [sendDic setObject:@"0" forKey:@"limit"];
        
    }
    
    
    
    // 여기는 에러체크용
    // 여기 부분은 에러 체크용..
    __autoreleasing NSError *error;
    NSData *data =[NSJSONSerialization dataWithJSONObject:sendDic options:kNilOptions error:&error];
    NSString *stringdata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",stringdata);
    NSLog(@"request : %@",sendDic);
    
    // 데이터 통신함
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager POST:URLLINK parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // 여기서 응답 온거 가지고 처리해야한다!!!
        NSString *result = responseObject[@"result"];
        if([result isEqualToString:@"FAIL"]){
            NSLog(@"result is fail");
        }else{
            NSLog(@"result is success");
            rankingDataArr = [[NSMutableArray alloc]init];
            [rankingDataArr addObjectsFromArray:responseObject[@"arr"]];
            
            NSInteger ranking = [responseObject[@"myrank"] integerValue];
            NSInteger score = [responseObject[@"myavg"] integerValue];
            
            // TODO
            [self savePeoplesDataWithDic:responseObject[@"arr"]];
            
            [self showMyRankingWithRanking:ranking withProfileURL:responseObject[@"myproPhoto"] withMyScore:score];
            
            
            // 이미지 다시 보여줌
            [self showRanking];
           
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        // 실패한경우...
        NSLog(@"Error: %@", error);
    }];
}
- (IBAction)showGlobalRanking:(id)sender {
    if( selectedRanking != GLOBAL_RANKING){
        rankingDataArr = [[NSMutableArray alloc]init];
        UIImage *image = [UIImage imageNamed:@"bg.png"];
        self.backgroundImage.image = image;
    
        image = [UIImage imageNamed:@"ranking_123_re.png"];
        self.background_123_imageView.image = image;
        selectedRanking = GLOBAL_RANKING;
        [self.rankingTable reloadData];
        
        [self.globalRankingBtn setAlpha:0.9];
        [self.localRankingBtn setAlpha:0.6];
        [self.groupRankingBtn setAlpha:0.6];
        
        [self getRankingFromServerWithType:GLOBAL_RANKING];
    }
}
- (IBAction)showLocalRanking:(id)sender {
    if( selectedRanking != LOCAL_RANKING) {
        rankingDataArr = [[NSMutableArray alloc]init];
        UIImage *image = [UIImage imageNamed:@"ranking_local_bg.png"];
        self.backgroundImage.image = image;
        
        image = [UIImage imageNamed:@"ranking_123_bg2.png"];
        self.background_123_imageView.image = image;
        
        selectedRanking = LOCAL_RANKING;
        [self.rankingTable reloadData];
        
        [self.globalRankingBtn setAlpha:0.6];
        [self.localRankingBtn setAlpha:0.9];
        [self.groupRankingBtn setAlpha:0.6];
        
        [self getRankingFromServerWithType:LOCAL_RANKING];
    }
    
}
- (IBAction)showGroupRanking:(id)sender {
    if(selectedRanking != GROUP_RANKING){
        rankingDataArr = [[NSMutableArray alloc]init];
        UIImage *image = [UIImage imageNamed:@"ranking_group_bg.png"];
        self.backgroundImage.image = image;
     
        image = [UIImage imageNamed:@"ranking_123_bg3.png"];
        self.background_123_imageView.image = image;
        
        selectedRanking = GROUP_RANKING;
        [self.rankingTable reloadData];
        
        [self.globalRankingBtn setAlpha:0.6];
        [self.localRankingBtn setAlpha:0.6];
        [self.groupRankingBtn setAlpha:0.9];
        
        [self getRankingFromServerWithType:GROUP_RANKING];
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
    if([dbInfoManager isLoggined]){
        [self.tabBarController setSelectedIndex:2];
        
    }else{
        UIViewController *uiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_BOARD"];
        [self.navigationController pushViewController:uiVC   animated:YES];
        
    }
}
- (IBAction)goMyPage:(id)sender {
    if([dbInfoManager isLoggined]){
        [self.tabBarController setSelectedIndex:3];
        
    }else{
        UIViewController *uiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_BOARD"];
        [self.navigationController pushViewController:uiVC   animated:YES];
        
    }
}
- (void)showMyRankingWithRanking:(NSInteger)inRanking withProfileURL:(NSString *)inProfileURL withMyScore:(NSInteger)inMyScore{
    
    //내 랭킹정보를 보여줍니다.
    self.myRankingLabel.text = [NSString stringWithFormat:@"%d",(int)inRanking];
    
    NSURL *proURL = [NSURL URLWithString:inProfileURL];
    [self.myImageView setImageWithURL:proURL];
    
    // TODO showUsername
    self.myNameLabel.text = ad.myName;
    
    self.myScoreLabel.text = [NSString stringWithFormat:@"%d",inMyScore];
    
    
}

- (BOOL)showRanking{
    //이미지 보여주는 부분입니다~
    NSDictionary *one;
    NSString *photourl;
    NSURL *imageURL;
    NSURL *countryURL;
    NSURLRequest *request;
    AFHTTPRequestOperation *postOperation;
    
    
    //4등이후는 table이용해서 보여지도록 ㅋㅋ
    [self.rankingTable reloadData];
    
    //일단 123 등 보여준다.
    
    if(rankingDataArr.count == 0) {
        return TRUE;
    }
    
    //1등부터 일단 보여줌
    one = [rankingDataArr objectAtIndex:0];
    //이미지얻어옴
    imageURL = [NSURL URLWithString:one[@"proPhoto"]];
    countryURL = [NSURL URLWithString:one[@"country"]];
    [self.imageFirst setImageWithURL:imageURL];
    self.nameFirst.text = one[@"name"];
    self.scoreFirst.text = [NSString stringWithFormat:@"%3.1f", [one[@"avg"] floatValue]];
   // self.scoreFirst.font = [UIFont fontWithName:@"Expansiva" size:self.scoreFirst.font.pointSize];
    [self.countryFirst setImageWithURL:countryURL];
    if (rankingDataArr.count == 1) {
        return TRUE;
    }
    
    // 2등 보여줌
    one = [rankingDataArr objectAtIndex:1];
    //이미지얻어옴
    imageURL = [NSURL URLWithString:one[@"proPhoto"]];
    countryURL = [NSURL URLWithString:one[@"country"]];
    [self.imageSecond  setImageWithURL:imageURL];
    self.nameSecond.text = one[@"name"];
    self.scoreSecond.text = [NSString stringWithFormat:@"%3.1f", [one[@"avg"] floatValue]];
    //self.scoreSecond.font = [UIFont fontWithName:@"Expansiva" size:self.scoreSecond.font.pointSize];
    [self.countrySecond setImageWithURL:countryURL];
    if (rankingDataArr.count == 2) {
        return  TRUE;
    }
    // 3등 보여줌
    one = [rankingDataArr objectAtIndex:2];
    self.nameThird.text = one[@"name"];
    //이미지얻어옴
    imageURL = [NSURL URLWithString:one[@"proPhoto"]];
    countryURL = [NSURL URLWithString:one[@"country"]];
    [self.imageThird setImageWithURL:imageURL];
    self.scoreThrid.text = [NSString stringWithFormat:@"%3.1f", [one[@"avg"] floatValue]];
    //self.scoreThrid.font = [UIFont fontWithName:@"Expansiva" size:self.scoreThrid.font.pointSize] ;
    [self.countryThird setImageWithURL:countryURL];
    if(rankingDataArr.count == 3){
        return TRUE;
    }
    
    
    return TRUE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSDictionary *one = [rankingDataArr objectAtIndex:(indexPath.row+3)];
        NSURL *imageURL = [NSURL URLWithString:one[@"proPhoto"]];
        NSURL *countryURL = [NSURL URLWithString:one[@"country"]];
        
        GlobalRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLOBAL_RANKING_CELL" forIndexPath:indexPath];
        
        [cell setValueWithRankingNum:(indexPath.row+4) withName:one[@"name"] withScore:one[@"avg"] withProfileImageURL:imageURL withCountryImageURL:countryURL];
                return  cell;
    
    
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(rankingDataArr.count > 3){
    return ([rankingDataArr count]-3);
    }else{
        return  0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Person *selectedPerson = [peoples objectAtIndex:(indexPath.row+3)];
    NSLog(@"haha %@",selectedPerson);
    
    [popUpView setValueWithProfileURL:selectedPerson.profileImage withCountryURL:selectedPerson.country withHandy:selectedPerson.hand withName:selectedPerson.name withScore:selectedPerson.score withYears:selectedPerson.fromYear withStyle:selectedPerson.style withStep:selectedPerson.step withBall:selectedPerson.ballPound with300:selectedPerson.series300 with800Series:selectedPerson.series800];
    
    [popUpView setHidden:NO];
    
    
    
}
- (IBAction)showFirstManInfo:(id)sender {
    if (rankingDataArr.count >= 1) {
       
        Person *selectedPerson = [peoples objectAtIndex:0];
    
        [popUpView setValueWithProfileURL:selectedPerson.profileImage withCountryURL:selectedPerson.country withHandy:selectedPerson.hand withName:selectedPerson.name withScore:selectedPerson.score withYears:selectedPerson.fromYear withStyle:selectedPerson.style withStep:selectedPerson.step withBall:selectedPerson.ballPound with300:selectedPerson.series300 with800Series:selectedPerson.series800];
    
        [popUpView setHidden:NO];
    }
}
- (IBAction)showSecondManInfo:(id)sender {
    if (rankingDataArr.count >= 2) {
        
        Person *selectedPerson = [peoples objectAtIndex:1];
        
        [popUpView setValueWithProfileURL:selectedPerson.profileImage withCountryURL:selectedPerson.country withHandy:selectedPerson.hand withName:selectedPerson.name withScore:selectedPerson.score withYears:selectedPerson.fromYear withStyle:selectedPerson.style withStep:selectedPerson.step withBall:selectedPerson.ballPound with300:selectedPerson.series300 with800Series:selectedPerson.series800];
        
        [popUpView setHidden:NO];
    }
}
- (IBAction)showThirdManInfo:(id)sender {
    if (rankingDataArr.count >= 3) {
        
        Person *selectedPerson = [peoples objectAtIndex:2];
        
        [popUpView setValueWithProfileURL:selectedPerson.profileImage withCountryURL:selectedPerson.country withHandy:selectedPerson.hand withName:selectedPerson.name withScore:selectedPerson.score withYears:selectedPerson.fromYear withStyle:selectedPerson.style withStep:selectedPerson.step withBall:selectedPerson.ballPound with300:selectedPerson.series300 with800Series:selectedPerson.series800];
        
        [popUpView setHidden:NO];
    }
}
@end
