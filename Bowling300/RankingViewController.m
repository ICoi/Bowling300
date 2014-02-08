//
//  RankingViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "RankingViewController.h"
#define GLOBAL_RANKING 0
#define LOCAL_RANKING 1
#define GROUP_RANKING 2

@interface RankingViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger selectedRanking;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *globalRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *localRankingBtn;
@property (weak, nonatomic) IBOutlet UIButton *groupRankingBtn;
@property (weak, nonatomic) IBOutlet UITableView *rankingTable;


@end

@implementation RankingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    selectedRanking = GLOBAL_RANKING;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showGlobalRanking:(id)sender {
    if( selectedRanking != GLOBAL_RANKING){
        UIImage *image = [UIImage imageNamed:@"ranking.png"];
        self.backgroundImage.image = image;
    
        selectedRanking = GLOBAL_RANKING;
        [self.rankingTable reloadData];
        // TODO
        // 여기서 table reload도 해야하고 사진도 바꿔야하고 할거 많음..
    }
}
- (IBAction)showLocalRanking:(id)sender {
    if( selectedRanking != LOCAL_RANKING) {
        UIImage *image = [UIImage imageNamed:@"ranking_local.png"];
        self.backgroundImage.image = image;
        
        selectedRanking = LOCAL_RANKING;
        [self.rankingTable reloadData];
        // TODO
        // 여기서 table reload도 해야하고 사진도 바꾸어ㅑ하고 할거 많음
    }
    
}
- (IBAction)showGroupRanking:(id)sender {
    if(selectedRanking != GROUP_RANKING){
        UIImage *image = [UIImage imageNamed:@"ranking_group.png"];
        self.backgroundImage.image = image;
     
        selectedRanking = GROUP_RANKING;
        [self.rankingTable reloadData];
        // TODO
        // 여기서 table reload도 해야하고 사진도 바꿔야됨
    }
}



// 여기 아래는 탭 버튼 누르는거
- (IBAction)goRecordPage:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}
- (IBAction)goGroupPage:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}
- (IBAction)goMyPage:(id)sender {
    [self.tabBarController setSelectedIndex:3];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // TODO
    //  여기에 조건문으로 어떤 경우인지에 따라 다르게 보여줘야 할거임!
    UITableViewCell *cell;
    if(selectedRanking == GLOBAL_RANKING){
        cell = [tableView dequeueReusableCellWithIdentifier:@"GLOBAL_RANKING_CELL" forIndexPath:indexPath];
    }
    else if(selectedRanking == LOCAL_RANKING){
            cell = [tableView dequeueReusableCellWithIdentifier:@"LOCAL_RANKING_CELL" forIndexPath:indexPath];
    }
    else if(selectedRanking == GROUP_RANKING ) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GROUP_RANKING_CELL" forIndexPath:indexPath];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
@end
