//
//  GroupLeagueViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupLeagueViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AirBalloonView.h"
#import <AFNetworking.h>
#import "AppDelegate.h"
#import <UIImageView+AFNetworking.h>
#define TOPX 25
#define TOPY 61
#define BOTTOMY 485
#define WIDTH 235
#define HEIGHT 424

#define URLLINK @"http://bowling.pineoc.cloulu.com/user/groupLeague"

@interface GroupLeagueViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *testPeople;
@property (nonatomic, strong) UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *membersCntLabel;


@end

@implementation GroupLeagueViewController{
    AppDelegate *ad;
    NSMutableArray *datas;
    NSMutableArray *airBalloons;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    datas = [[NSMutableArray alloc]init];
    airBalloons = [[NSMutableArray alloc]init];
	// Do any additional setup after loading the view.
    
    // 이부분이 이미지 둥글게 만들 수 잇는 부분임.
    UIImage *image = [UIImage imageNamed:@"person1.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(30, 120, 50, 50);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 30.0f;
    [self.view addSubview:imageView];
    
    self.testPeople.layer.masksToBounds = YES;
    self.testPeople.layer.cornerRadius = 30.0f;
    
}


// setneedsdisplay
- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    
    
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc]init];
    [sendDic setObject:[NSString stringWithFormat:@"%d",ad.selectedGroupIdx] forKey:@"gidx"];
    
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
            
            datas = responseObject[@"leaguedata"];
            
            for(int i =0 ; i < datas.count ; i++){
                NSMutableDictionary *oneData = [datas objectAtIndex:i];
                NSString *score = oneData[@"avg"];
                CGRect tmpPosition = [self showDrawPointWithScore:[score integerValue]];
                AirBalloonView *one = [[AirBalloonView alloc]initWithFrame:tmpPosition];
                [one setValueWithScore:[score integerValue] withProfileURL:oneData[@"prophoto"]];
                [airBalloons addObject:one];
                [self.view addSubview:one];
            }
            self.membersCntLabel.text = [NSString stringWithFormat:@"%d members.",datas.count];
            [self.view reloadInputViews];
            // TODO
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

- (void)removeAirBalloons{
    for(int i = 0 ; i < airBalloons.count ;i++){
        AirBalloonView *one = [airBalloons objectAtIndex:i];
        [one removeFromSuperview];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self removeAirBalloons];
}
- (IBAction)showBoard:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

- (IBAction)showMember:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}

- (CGRect)showDrawPointWithScore:(NSInteger)inScore{
    NSInteger x = arc4random()%WIDTH;
    NSInteger y = (HEIGHT-90) * ((float)inScore/300);
    
    CGRect tmp = CGRectMake(TOPX + x, 420 - (((float)359/300)*inScore), 60, 90 );
    
    return tmp;
}

- (void)showLeague{
    // League를 보여줌
}

- (void)drawPersonWithScore:(NSInteger)score{
    
}
@end
