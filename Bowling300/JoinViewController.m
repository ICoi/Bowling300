//
//  JoinViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 6..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "JoinViewController.h"
#import <AFNetworking.h>

#define URLLINK @"http://bowling.pineoc.cloulu.com/user/sign"


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
    
    // 데이터 통신함
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": @"daun144@naver.com",@"name":@"Joung Daun2",@"pwd":@"merong"};
    [manager POST:URLLINK parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // TODO
        // 여기서 응답 온거 가지고 처리해야한다!!!
       NSString *result = responseObject[@"result"];
        if([result isEqualToString:@"FAIL"]){
            NSLog(@"result is fail");
        }else{
            NSLog(@"result is success");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 실패한경우...
        NSLog(@"Error: %@", error);
    }];
    
}

@end
