//
//  GroupAddViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupAddViewController.h"
#import "DBGroupManager.h"
@interface GroupAddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *groupNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *groupIdxLabel;
@property (weak, nonatomic) IBOutlet UITextField *groupRedLabel;
@property (weak, nonatomic) IBOutlet UITextField *groupGreenLabel;
@property (weak, nonatomic) IBOutlet UITextField *groupBlueLabel;

@end

@implementation GroupAddViewController{
    DBGroupManager *dbManager;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBGroupManager sharedModeManager];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)saveData:(id)sender {
    NSInteger groupIdx = [self.groupIdxLabel.text integerValue];
    NSString *groupName = self.groupNameLabel.text;
    NSInteger redColor = [self.groupRedLabel.text integerValue];
    NSInteger greenColor = [self.groupGreenLabel.text integerValue];
    NSInteger blueColor = [self.groupBlueLabel.text integerValue];
    
     [dbManager addDataInGroupTableWithGroupIdx:groupIdx withGroupName:groupName withGroupRedColor:redColor withGroupGreenColor:greenColor withGroupBlueColor:blueColor];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
