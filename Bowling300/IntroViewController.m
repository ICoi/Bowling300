//
//  ViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "IntroViewController.h"
#import "DB.h"
#import "AppDelegate.h"
#import "DBMyInfoManager.h"
#import <AFNetworking.h>

#define URLLINK @"http://bowling.pineoc.cloulu.com/user/rankpoint"
@interface IntroViewController ()
@end

@implementation IntroViewController{
    AppDelegate *ad;
    DBMyInfoManager *dbInfoManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dbInfoManager = [DBMyInfoManager sharedModeManager];
}
-(void)viewWillAppear:(BOOL)animated{
    //self.dateLabel.font = [UIFont fontWithName:@"Nanum Pen Script OTF" size:self.dateLabel.font.pointSize];
    
//    self.test.font = [UIFont fontWithName:@"Expansiva"  size:self.test.font.pointSize];
    
    ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLLINK parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
         NSString *string = responseObject[@"startPoint"];
         NSArray *components = [string componentsSeparatedByString: @"-"];
        
        ad.rankingStartDate = [NSString stringWithFormat:@"%04d%02d%02d",[[components objectAtIndex:0] integerValue],[[components objectAtIndex:1] integerValue],[[components objectAtIndex:2] integerValue]];
        
        string = responseObject[@"endPoint"];
        components = [string componentsSeparatedByString:@"-"];
        
        ad.rankingEndDate = [NSString stringWithFormat:@"%04d%02d%02d",[[components objectAtIndex:0] integerValue],[[components objectAtIndex:1] integerValue],[[components objectAtIndex:2] integerValue]];
        
        
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"start date : %@ end date : %@",ad.rankingStartDate, ad.rankingEndDate);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        NSLog(@"Error: %@", error);
    }];
    
    
    ad.myIDX = [dbInfoManager showMyIdx];
    
    
    
    
    // 화면 전환하기
    [UIView animateWithDuration:2.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.alpha = 0.5;
                     }
                     completion:^(BOOL finished){
                         UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RankingViewController"];
                         [vc setModalPresentationStyle:UIModalPresentationFullScreen];
                         
                         [self presentModalViewController:vc animated:YES];
                     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
