//
//  GroupMemberViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "GroupMemberCell.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>

#define URLLINK @"http://bowling.pineoc.cloulu.com/user/groupmember"
@interface GroupMemberViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *memberList;
@property (weak, nonatomic) IBOutlet UILabel *memberCntLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;

@end

@implementation GroupMemberViewController{
    NSMutableArray *members;
    AppDelegate *ad;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    members = [[NSMutableArray alloc]init];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    self.myPhotoImageView.layer.masksToBounds = YES;
    self.myPhotoImageView.layer.cornerRadius = 71.0f;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]init];
    [sendDic setObject:[NSString stringWithFormat:@"%d",ad.selectedGroupIdx] forKey:@"gidx"];
    [sendDic setObject:[NSString stringWithFormat:@"%d",ad.myIDX] forKey:@"aidx"];
    
    __autoreleasing NSError *error;
    NSData *data =[NSJSONSerialization dataWithJSONObject:sendDic options:kNilOptions error:&error];
    NSString *stringdata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
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
            NSString *myPhoto = responseObject[@"proPhoto"];
            NSURL *myURL = [NSURL URLWithString:myPhoto];
            [self.myPhotoImageView setImageWithURL:myURL];
            self.myNameLabel.text = ad.myName;
            members = responseObject[@"member"];
            self.memberCntLabel.text = [NSString stringWithFormat:@"%d members.",members.count];
            [self.memberList reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        // 실패한경우...
        NSLog(@"Error: %@", error);
    }];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showLeague:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)showBoard:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [members count]){
        GroupMemberCell *cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MEMBER_CELL" forIndexPath:indexPath];
        
        NSMutableDictionary *one = [members objectAtIndex:indexPath.row];
        NSLog(@"%@",one);
        NSString *proPhoto = one[@"proPhoto"];
        [cell setValueWithName:one[@"name"] withProfileURL:[NSURL URLWithString:proPhoto]];
        return  cell;
        
    }else{
        UICollectionViewCell *cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LAST_CELL" forIndexPath:indexPath];
        return  cell;
    }
    return  nil;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [members count] + 1;
    
}

@end
