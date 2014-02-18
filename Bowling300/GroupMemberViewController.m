//
//  GroupMemberViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupMemberViewController.h"
#import "GroupMemberCell.h"
@interface GroupMemberViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *memberList;

@end

@implementation GroupMemberViewController{
    NSMutableArray *members;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    members = [[NSMutableArray alloc]initWithArray:@[@"daun",@"aa",@"AA",@"AA",@"DD",@"sdf",@"aa",@"sdf",@"asd"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
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
