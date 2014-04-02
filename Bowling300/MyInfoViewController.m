//
//  MyInfoViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoTwoViewController.h"
#import "DBMyInfoManager.h"
#import "Person.h"
#import "iAd/iAd.h"
#import "AppDelegate.h"

@interface MyInfoViewController () <ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *countryLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *handerLabel;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;

@property (weak, nonatomic) IBOutlet UIView *countryPickView;

@property (nonatomic ,retain) IBOutlet ADBannerView *adView;
@end

@implementation MyInfoViewController{
    Person *me;
    DBMyInfoManager *dbManager;
    NSInteger gender;
    NSInteger hand;
    NSString *selectCountryCode;
    UIAlertView *countryAlert;
    UIAlertView *handAlert;
    AppDelegate *ad;
    NSArray *countryCodeArray;
    NSArray *countryNameArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBMyInfoManager sharedModeManager];
	// Do any additional setup after loading the view.
    
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.adView.delegate = self;
    self.adView.hidden = true;
    
    
    countryCodeArray = ad.countyrCodeArray;
    countryNameArray = ad.countryNameArray;
}

- (void)viewWillAppear:(BOOL)animated{
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
    // DB에서 현재 저장된 정보 불러옴..
    me = [dbManager getMyData];
    
    //초기에 저장된 값 세팅하기
    self.nameLabel.text = me.name;
    [self showCountryNameWithCountryCode:me.countryName];
    selectCountryCode = me.countryName;
    self.emailLabel.text = me.email;
    self.passwordLabel.text = me.pwd;
    if (me.hand == 0) {
        self.handerLabel.text = @"Left";
        hand = me.hand;
    }else{
        self.handerLabel.text = @"Right";
        hand = me.hand;
    }    gender = me.gender;
    
    if(gender == 0) {
        [self.manBtn setSelected:YES];
    }else{
        [self.girlBtn setSelected:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"MYINFOSEGUE"]) {
        MyInfoTwoViewController *mitVC = (MyInfoTwoViewController *)segue.destinationViewController;
        // 일단 바뀐 정보들을 저장한다.
        if (![self.nameLabel.text isEqualToString:@""]) {
            me.name = self.nameLabel.text;
        }
        if(![self.passwordLabel.text isEqualToString:@""]){
            me.pwd = self.passwordLabel.text;
        }
        me.countryName = selectCountryCode;
        me.gender = gender;
        me.hand = hand;
        
        mitVC.me = me;
        
    }
}
-(void)showCountryNameWithCountryCode:(NSString *)inCode{
    if([inCode isEqualToString:@"KOR"]){
        self.countryLabel.text = @"Korea";
    }else if([inCode isEqualToString:@"JPN"]){
        self.countryLabel.text = @"Japan";
    }else if([inCode isEqualToString:@"USA"]){
        self.countryLabel.text = @"America";
    }else if([inCode isEqualToString:@"CHN"]){
        self.countryLabel.text = @"China";
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)clickManBtn:(id)sender {
    [self.manBtn setSelected:YES];
    [self.girlBtn setSelected:NO];
    gender = 0;
}
- (IBAction)clickGirlBtn:(id)sender {
    [self.manBtn setSelected:NO];
    [self.girlBtn setSelected:YES];
    gender = 1;
}


- (IBAction)selectCountry:(id)sender {
    [self.countryPickView setHidden:NO];
    
}
- (IBAction)endSelectCountry:(id)sender {
    [self.countryPickView setHidden:YES];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return countryCodeArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [countryNameArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.countryLabel.text = [countryNameArray objectAtIndex:row];
    selectCountryCode = [countryCodeArray objectAtIndex:row];
    
    NSLog(@"select country : %@, code : %@",self.countryLabel.text,selectCountryCode);
}

//alertView 선택시
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if(buttonIndex == (alertView.firstOtherButtonIndex)){
            hand = 0;
            self.handerLabel.text = @"Left";
        }else{
            hand = 1;
            self.handerLabel.text = @"Right";
        }
    
}
- (IBAction)selectHander:(id)sender {
    handAlert = [[UIAlertView alloc]initWithTitle:@"Handler" message:@"Select Hand" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Left",@"Right", nil];
    [handAlert show];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



// About IAD
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    self.adView.hidden = false;
    NSLog(@"Has ad, showing");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    self.adView.hidden = true;
    NSLog(@"No ad To Display");
}
@end
