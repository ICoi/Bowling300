//
//  JoinViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 6..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "JoinViewController.h"

@interface JoinViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation JoinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)pressSaveButton:(id)sender {
    
    //정보를 보낸다
    NSURL *url = [NSURL URLWithString:@"http://bowling.pineoc.cloulu.com/user/sign"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    
    NSDictionary *sendDic = @{@"email": @"i_co1022@naver.com",
                              @"name":@"Joung Daun",
                              @"pwd":@"merong",
                              @"proPhoto":@"",
                              @"ballPhoto":@""};
    
    __autoreleasing NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:sendDic options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"JSON : %@",postData);
    
    [request setHTTPBody:postData];
    
    NSURLResponse *resp = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:nil];

    
    
 //   [self.navigationController popViewControllerAnimated:YES];
}

@end
