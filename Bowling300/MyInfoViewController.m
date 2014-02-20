//
//  MyInfoViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTwoViewController.h"

@interface MyInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *countryLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *handerLabel;

@end

@implementation MyInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MYINFOSEGUE"]) {
        MyInfoTwoViewController *mitVC = (MyInfoTwoViewController *)segue.destinationViewController;
        
    }
}

- (IBAction)selectCountry:(id)sender {
}
- (IBAction)selectHander:(id)sender {
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
