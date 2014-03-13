//
//  GroupBoardViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupBoardViewController.h"
#import "AppDelegate.h"
#import "GroupWriteListCell.h"
#import "GroupBoardReadViewController.h"
#import <AFNetworking.h>
#define URLLINK @"http://bowling.pineoc.cloulu.com/user/group/board/list"

@interface GroupBoardViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end

@implementation GroupBoardViewController{
    AppDelegate *ad;
    NSMutableArray *listArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    listArr = [[NSMutableArray alloc]init];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self getList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getList{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    NSDictionary *parameters = @{@"gidx":[NSString stringWithFormat:@"%d",ad.selectedGroupIdx],@"limit":[NSString stringWithFormat:@"%d",0]};
    NSLog(@"parameters : %@",parameters);
    AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        listArr = responseObject[@"arr"];
        NSLog(@"list : %@",listArr);
        [self.collection reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];

}

- (IBAction)showLeague:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)showMember:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"BOARD_READ_SEAGUE"]){
        GroupWriteListCell *cell = (GroupWriteListCell*)sender;
        NSLog(@"%@",cell.bidx);
        
        GroupBoardReadViewController *gbrVC = (GroupBoardReadViewController *)segue.destinationViewController;
        gbrVC.bidx = cell.bidx;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GroupWriteListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LIST_CELL" forIndexPath:indexPath];
    NSDictionary *one = [listArr objectAtIndex:indexPath.row];
    NSString *tmp = [NSString stringWithFormat:@"%@",one[@"photo"]];
    if ([tmp isEqualToString:@"<null>"]) {
        [cell setValueWithTitle:one[@"title"] withName:one[@"name"] withDate:one[@"writedate"]withBidx:one[@"bidx"]];
    }else{
    [cell setValueWithTitle:one[@"title"] withName:one[@"name"] withDate:one[@"writedate"] withImageURL:one[@"photo"] withBidx:one[@"bidx"]];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return listArr.count;
}
@end
