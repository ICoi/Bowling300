//
//  MyInfoTwoViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 20..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyInfoTwoViewController.h"
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "DBMyInfoManager.h"

#define URLLINK @"http://bowling300.cafe24app.com/user/addsign"
@interface MyInfoTwoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fromLabel;
@property (weak, nonatomic) IBOutlet UITextField *ballPoundLabel;
@property (weak, nonatomic) IBOutlet UIButton *y800Btn;
@property (weak, nonatomic) IBOutlet UIButton *n800Btn;
@property (weak, nonatomic) IBOutlet UIButton *step3Btn;
@property (weak, nonatomic) IBOutlet UIButton *step4Btn;
@property (weak, nonatomic) IBOutlet UIButton *step5Btn;
@property (weak, nonatomic) IBOutlet UIButton *styleNon
;
@property (weak, nonatomic) IBOutlet UIButton *styleStraight;
@property (weak, nonatomic) IBOutlet UIButton *styleHook;
@property (weak, nonatomic) IBOutlet UIButton *styleCurve;
@property (weak, nonatomic) IBOutlet UIButton *styleBackup;

@end

@implementation MyInfoTwoViewController{
    NSInteger series800;
    NSInteger step;
    NSInteger style;
    DBMyInfoManager *dbManager;
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
    dbManager = [DBMyInfoManager sharedModeManager];
}
-(void)viewWillAppear:(BOOL)animated{
    //초기 값 설정하기
    self.fromLabel.text = [NSString stringWithFormat:@"%d",self.me.fromYear];
    self.ballPoundLabel.text = [NSString stringWithFormat:@"%d",self.me.ballPound];
    
    if(self.me.series800 == 0 ){
        [self.n800Btn setSelected:YES];
        series800 = 0;
    }else{
        [self.y800Btn setSelected:YES];
        series800 = 1;
    }
    
    step = self.me.step;
    switch (self.me.step) {
        case 3:
            [self.step3Btn setSelected:YES];
            break;
        case 4:
            [self.step4Btn setSelected:YES];
            break;
        case 5:
            [self.step5Btn setSelected:YES];
            break;
        default:
            break;
    }
    
    style = self.me.style;
    switch (self.me.style) {
        case 0:
            [self.styleNon setSelected:YES];
            break;
        case 1:
            [self.styleStraight setSelected:YES];
            break;
        case 2:
            [self.styleHook setSelected:YES];
            break;
        case 3:
            [self.styleCurve setSelected:YES];
            break;
        case 4:
            [self.styleBackup setSelected:YES];
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressSaveBtn:(id)sender {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.me.fromYear = [self.fromLabel.text integerValue];
    self.me.ballPound = [self.ballPoundLabel.text integerValue];
    self.me.series800 = series800;
    self.me.step = step;
    self.me.style = style;
    // 서버에 저장후 디비에 저장
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
    
    NSLog(@"%@",self.me);
    NSDictionary *parameters = @{@"aidx":[NSString stringWithFormat:@"%d",ad.myIDX], @"name":self.me.name, @"pwd":self.me.pwd, @"hand":[NSString stringWithFormat:@"%d",self.me.hand],@"country":self.me.countryName ,@"sex":[NSString stringWithFormat:@"%d",self.me.gender],@"year":[NSString stringWithFormat:@"%d",self.me.fromYear],@"ballweight":[NSString stringWithFormat:@"%d",self.me.ballPound],@"style":[NSString stringWithFormat:@"%d",self.me.style],@"step":[NSString stringWithFormat:@"%d",self.me.step],@"series800":[NSString stringWithFormat:@"%d",self.me.series800],@"series300":[NSString stringWithFormat:@"%d",self.me.series300]};
    NSLog(@"%@",parameters);
   
    
    // 사진 : proPhoto
    AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON : %@",responseObject);
        
        NSString *result = responseObject[@"result"];
        if([result isEqualToString:@"SUCCESS"]){
            [dbManager setMyDataWithPerson:self.me];
            // db에 저장
            [self.navigationController popToRootViewControllerAnimated:YES];
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];


}

- (IBAction)clickedY300:(id)sender {
    [self.y800Btn setSelected:YES];
    [self.n800Btn setSelected:NO];
    series800 = 1;
}
- (IBAction)clickedN300:(id)sender {
    [self.y800Btn setSelected:NO];
    [self.n800Btn setSelected:YES];
    series800 = 0;
}
- (IBAction)clicked3Btn:(id)sender {
    [self.step3Btn setSelected:YES];
    [self.step4Btn setSelected:NO];
    [self.step5Btn setSelected:NO];
    step = 0;
}
- (IBAction)clicked4Btn:(id)sender {
    [self.step3Btn setSelected:NO];
    [self.step4Btn setSelected:YES];
    [self.step5Btn setSelected:NO];
    step = 1;
}
- (IBAction)clicked5Btn:(id)sender {
    [self.step3Btn setSelected:NO];
    [self.step4Btn setSelected:NO];
    [self.step5Btn setSelected:YES];
    step = 2;
}
- (IBAction)clickedNonBtn:(id)sender {
    [self.styleNon setSelected:YES];
    [self.styleStraight setSelected:NO];
    [self.styleHook setSelected:NO];
    [self.styleCurve setSelected:NO];
    [self.styleBackup setSelected:NO];
    style = 0;
}
- (IBAction)clickedStraightBtn:(id)sender {
    [self.styleNon setSelected:NO];
    [self.styleStraight setSelected:YES];
    [self.styleHook setSelected:NO];
    [self.styleCurve setSelected:NO];
    [self.styleBackup setSelected:NO];
    style = 1;
}
- (IBAction)clickedHookBtn:(id)sender {
    [self.styleNon setSelected:NO];
    [self.styleStraight setSelected:NO];
    [self.styleHook setSelected:YES];
    [self.styleCurve setSelected:NO];
    [self.styleBackup setSelected:NO];
    style = 2;
}
- (IBAction)clickedCurveBtn:(id)sender {
    [self.styleNon setSelected:NO];
    [self.styleStraight setSelected:NO];
    [self.styleHook setSelected:NO];
    [self.styleCurve setSelected:YES];
    [self.styleBackup setSelected:NO];
    style = 3;
}
- (IBAction)clickedBackupBtn:(id)sender {
    [self.styleNon setSelected:NO];
    [self.styleStraight setSelected:NO];
    [self.styleHook setSelected:NO];
    [self.styleCurve setSelected:NO];
    [self.styleBackup setSelected:YES];
    style = 4;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
