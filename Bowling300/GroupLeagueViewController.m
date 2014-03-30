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

#define URLLINK @"http://bowling300.cafe24app.com/user/groupLeague"

@interface GroupLeagueViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *testPeople;
@property (nonatomic, strong) UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *membersCntLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noScoreImg;


@end

@implementation GroupLeagueViewController{
    AppDelegate *ad;
    NSMutableArray *datas;
    NSMutableArray *airBalloons;
    NSInteger holdingAirBalloon;
    NSInteger holdingY;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    datas = [[NSMutableArray alloc]init];
    airBalloons = [[NSMutableArray alloc]init];
	// Do any additional setup after loading the view.
    
    
    self.testPeople.layer.masksToBounds = YES;
    self.testPeople.layer.cornerRadius = 30.0f;
    
    holdingAirBalloon = -1;
    
    [self.tabBarController.tabBar setHidden:YES];
}


// setneedsdisplay
- (void)viewWillAppear:(BOOL)animated{
    
    
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
            
            datas = responseObject[@"leaguedata"];
            NSString *myAver = responseObject[@"myavg"];
            NSString *myName = ad.myName;
            NSInteger notZeroeScoreCnt = 0;
            
            for(int i =0 ; i < datas.count ; i++){
                NSMutableDictionary *oneData = [datas objectAtIndex:i];
                NSString *score = oneData[@"avg"];
                if ([score integerValue] != 0) {
                    CGRect tmpPosition = [self showDrawPointWithScore:[score integerValue]];
                    AirBalloonView *one = [[AirBalloonView alloc]initWithFrame:tmpPosition];
                    [one setValueWithScore:[score integerValue] withProfileURL:oneData[@"prophoto"] withName:oneData[@"name"]];
                    if(([myAver doubleValue] == [score doubleValue]) && ([myName isEqualToString:oneData[@"name"]])){
                    [one isMe];
                    }
                    [airBalloons addObject:one];
                    [self.view addSubview:one];
                    notZeroeScoreCnt++;
                }
            }
            if(notZeroeScoreCnt == 0){
                [self.noScoreImg setHidden:NO];
            }
            self.membersCntLabel.text = [NSString stringWithFormat:@"%d members.",notZeroeScoreCnt];
            
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
    
    CGRect tmp = CGRectMake(TOPX + x, 420 - (((float)349/300)*inScore), 60, 100 );
    
    return tmp;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    for(int i = 0 ; i < airBalloons.count ; i++){
        AirBalloonView *one = [airBalloons objectAtIndex:i];
        if(CGRectContainsPoint(one.frame, point )){
            holdingAirBalloon = i;
            holdingY = one.frame.origin.y + 50;
            one.transform = CGAffineTransformMakeScale(1.2, 1.2);
            break;
        }
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(holdingAirBalloon != -1){
        AirBalloonView *one = [airBalloons objectAtIndex:holdingAirBalloon];
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        CGPoint point2 = CGPointMake(point.x, holdingY);
        if((point2.x > 0) && (point2.x < 320)){
            one.center = point2;
        }
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(holdingAirBalloon != -1){
        AirBalloonView *one = [airBalloons objectAtIndex:holdingAirBalloon];
        one.transform = CGAffineTransformIdentity;
        holdingAirBalloon = -1;
        holdingY = 0;
    }
}
- (void)drawPersonWithScore:(NSInteger)score{
    
}
@end
