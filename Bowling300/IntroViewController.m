//
//  ViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *test;

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    //self.dateLabel.font = [UIFont fontWithName:@"Nanum Pen Script OTF" size:self.dateLabel.font.pointSize];
    
    for(NSString *familyName in [UIFont familyNames])
        NSLog(@"%@ : [ %@ ]",familyName,
              [[UIFont fontNamesForFamilyName:familyName] description]);
    self.test.font = [UIFont fontWithName:@"Expansiva"  size:self.test.font.pointSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
