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
         NSString *string2 = (NSString*) [components objectAtIndex:1];
        
        ad.rankingStartDate = [NSString stringWithFormat:@"%04d%02d%02d",[[components objectAtIndex:0] integerValue],[[components objectAtIndex:1] integerValue],[[components objectAtIndex:2] integerValue]];
        
        string = responseObject[@"endPoint"];
        components = [string componentsSeparatedByString:@"-"];
        
        ad.rankingEndDate = [NSString stringWithFormat:@"%04d%02d%02d",[[components objectAtIndex:0] integerValue],[[components objectAtIndex:1] integerValue],[[components objectAtIndex:2] integerValue]];
        
        
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"start date : %@ end date : %@",ad.rankingStartDate, ad.rankingEndDate);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    ad.myIDX = [dbInfoManager showMyIdx];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
