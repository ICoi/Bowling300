//
//  AppDelegate.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "AppDelegate.h"
#import "DBMyInfoManager.h"
#import "DBPersonnalRecordManager.h"
@implementation AppDelegate{
    DBMyInfoManager *dbInfoManager;
    DBPersonnalRecordManager *dbRecordManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.countryNameArray = @[@"Argentian",@"America",@"Belgium",@"Brazil",@"Canada",@"China",@"Czech",@"Denmark",@"Egypt",@"Finland",@"France",@"Germany",@"Ghana",@"Greece",@"Ireland",@"Island",@"Italy",@"Japan",@"Korea",@"Latvia",@"Mexico",@"Neterlands",@"Norway",@"Poland",@"Russia",@"Southafrica",@"Spain",@"Sweden",@"United kingdom",@"Ukraine"];
    self.countyrCodeArray = @[@"ARG",@"USA",@"BEL",@"BRA",@"CAN",@"CHN",@"CZE",@"DEN",@"EGY",@"FIN",@"FRA",@"GER",@"GHA",@"GRE",@"IRL",@"ISL",@"ITA",@"JPN",@"KOR",@"LAT",@"MEX",@"NED",@"NOR",@"POL",@"RUS",@"RSA",@"ESP",@"SWE",@"GBR",@"UKR"];
    
    
    dbInfoManager = [DBMyInfoManager sharedModeManager];
    
    dbRecordManager = [DBPersonnalRecordManager sharedModeManager];
    
    self.myIDX = [dbInfoManager showMyIdx];
    // Override point for customization after application launch.
    self.rankingStartDate = @"";
    self.rankingEndDate = @"";
    
    // 여기서 호출하기!
    [dbRecordManager setDefaultData];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
