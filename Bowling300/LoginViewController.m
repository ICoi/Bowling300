//
//  LoginViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 11..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking.h>
#import "DBGroupManager.h"
#import "DBMyInfoManager.h"
#import "DBPersonnalRecordManager.h"
#define URLLINK @"http://bowling.pineoc.cloulu.com/login"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *idLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;

@end

@implementation LoginViewController{
    int dy;
    DBGroupManager *dbGManager;
    DBMyInfoManager *dbMyManager;
    DBPersonnalRecordManager *dbRecordManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbGManager = [DBGroupManager sharedModeManager];
    dbMyManager = [DBMyInfoManager sharedModeManager];
    dbRecordManager = [DBPersonnalRecordManager sharedModeManager];
}
- (void)viewWillAppear:(BOOL)animated{
    
    // 감시 객체 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Login:(id)sender {
    
    NSMutableDictionary *sendDic = @{@"email":self.idLabel.text,
                                     @"pwd":self.passwordLabel.text};
    
    // 여기는 에러체크용
    // 여기 부분은 에러 체크용..
    __autoreleasing NSError *error;
    NSData *data =[NSJSONSerialization dataWithJSONObject:sendDic options:kNilOptions error:&error];
    NSString *stringdata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",stringdata);
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
            
            NSArray *Arr = responseObject[@"group"];
            [dbGManager setGroupDataWhenLoginedWithJSON:Arr];
            
            NSDictionary *dic = responseObject[@"myval"];
            [dbMyManager setMyDataWhenLoginedWithDic:dic];
            
            [dbRecordManager setDefaultData ];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        // 실패한경우...
        NSLog(@"Error: %@", error);
    }];

}


// 모든 서브뷰를 찾아서 최초 응답 객체를 반환
- (UITextField *)firstResponderTextField{
    for(id child in self.view.subviews){
        if([child isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)child;
            
            if(textField.isFirstResponder){
                return textField;
            }
        }
    }
    return nil;
}

- (IBAction)dissmissKeyboard:(id)sender{
    [[self firstResponderTextField]resignFirstResponder];
    // 모든 서브 뷰를 찾아서 최초 응답 객체에서 해제시킨다.
}

// 키보드가 나타나는 알림이 발생하면 동작
- (void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"keyboardWillShow, noti : %@ ",noti);
    
    UITextField *firstResponder = (UITextField *)[self firstResponderTextField];
    int y = 451;
    int viewHeight = self.view.frame.size.height;
    
    NSDictionary *userInfo = [noti userInfo];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    int keyboardHeight = (int)rect.size.height;
    
    float animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 키보드가 텍스트 필드를 가리는 경우
    if (keyboardHeight > (viewHeight - y)){
        NSLog(@"키보드가 가림");
        [UIView animateWithDuration:animationDuration animations:^{dy = keyboardHeight - (viewHeight - y);
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - dy);
        }];
    }
    else{
        NSLog(@"키보드가 가리지 않음");
        dy = 0;
        
    }
    
}


// 키보드가 사라지는 알림이 발생하면 동작
- (void)keyboardWillHide:(NSNotification *)noti{
    NSLog(@"keyboard Will Hide");
    
    if( dy > 0){
        float animationDuration = [[[noti userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:animationDuration animations:^{ self.view.center = CGPointMake(self.view.center.x, self.view.center.y + dy);}];
    }
}


@end
