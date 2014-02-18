//
//  JoinViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 6..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "JoinViewController.h"
#import <AFNetworking.h>
#import "DBMyInfoManager.h"
#import "AppDelegate.h"
#define URLLINK @"http://bowling.pineoc.cloulu.com/user/sign"
#define IMAGESIZE 300


@interface JoinViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation JoinViewController{
    DBMyInfoManager *dbInfoManager;
    UIImage *usingImage;
    AppDelegate *ad;
    NSInteger hander;
    NSInteger gender;
    UIAlertView *countryAlert;
    UIAlertView *cameraAlert;
    NSString *selectCountryCode;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.maleButton setSelected:YES];
	// Do any additional setup after loading the view.
    dbInfoManager = [DBMyInfoManager sharedModeManager];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    hander = 0;
    gender = 0;
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)ClickMaleButton:(id)sender {
    gender = 0;
    [self.maleButton setSelected:YES];
    [self.femaleButton setSelected:NO];
}
- (IBAction)clickFemaleButton:(id)sender {
    gender = 1;
    [self.maleButton setSelected:NO];
    [self.femaleButton setSelected:YES];
}

- (IBAction)selectHanderSegmentedControl:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    hander = control.selectedSegmentIndex;
    NSLog(@"selected %d",hander);
}

- (IBAction)pressSaveButton:(id)sender {
    NSString *name = self.nameField.text;
    NSString *email = self.emailField.text;
    NSString *country = self.countryField.text;
    NSString *password = self.passwordField.text;
    NSData *imageData = UIImageJPEGRepresentation(usingImage, 0.5);
    
    if (([name isEqualToString:@""]) || ([email isEqualToString:@""]) || ([selectCountryCode isEqualToString:@""]) || ([password isEqualToString:@""]) || ( imageData == nil)) {
        // 한개라도 null이 들어가면 서버에 전송하지 않음!!
        NSLog(@"Null Error");
    }
    else{
    
    
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
        
        NSDictionary *parameters = @{@"email": email,@"name":name,@"pwd":password,@"sex":[NSString stringWithFormat:@"%d",gender],@"country":selectCountryCode,@"hand":[NSString stringWithFormat:@"%d",hander]};
        NSLog(@"%@",parameters);
        NSInteger randomNum = arc4random()%10000000;
        NSString *randomName = [NSString stringWithFormat:@"%d.PNG",randomNum];
        AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"proPhoto" fileName:randomName mimeType:@"multipart/form-data"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // TODO
            // 여기서 응답 온거 가지고 처리해야한다!!!
            NSString *result = responseObject[@"result"];
            if([result isEqualToString:@"FAIL"]){
                NSLog(@"%@",responseObject);
                NSLog(@"result is fail");
            }else{
                NSLog(@"result is success");
                NSInteger idx = [responseObject[@"aidx"] integerValue];
                NSString *imageLink = @"";
                [dbInfoManager joinMemberWithIdx:idx WithName:name withGender:gender withCountry:country withEmail:email withPwd:password withHand:hander withImage:imageLink];
                [self.navigationController popToRootViewControllerAnimated:YES];
                ad.myIDX = idx;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alert show];
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];
    }
}
- (IBAction)clickCamera:(id)sender {
    cameraAlert = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Select" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Take picture",@"Album", nil];
    [cameraAlert show];
}

- (IBAction)selectFaceIcon:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    CGSize size = CGSizeMake(IMAGESIZE, IMAGESIZE);
    UIImage *resizeImage = [self imageWithImage:button.imageView.image scaledToSize:size];
    
    
    usingImage = resizeImage;
    self.ProfileImageView.image = usingImage;
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//alertView 선택시
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == cameraAlert) {

        if(buttonIndex == alertView.firstOtherButtonIndex){
            [self takePicture];
        }else{
            //앨범에서 가져오는거
            [self getImage];
        }
    } else if(alertView == countryAlert){
        if(buttonIndex == alertView.firstOtherButtonIndex){
            self.countryField.text = @"Korea";
            selectCountryCode = @"KOR";
        }else if(buttonIndex == (alertView.firstOtherButtonIndex+1)){
            self.countryField.text = @"Japan";
            selectCountryCode = @"JPN";
        }else if(buttonIndex == (alertView.firstOtherButtonIndex+2)){
            self.countryField.text = @"America";
            selectCountryCode = @"USA";
        }else if(buttonIndex == (alertView.firstOtherButtonIndex+3)){
            self.countryField.text = @"China";
            selectCountryCode = @"CHN";
        }
    }
}

-(void)takePicture{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //에러처리
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"카메라가 지원되지 않는 기종입니다." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        return ;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)getImage{
    //앨범에서 가져오는거
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //편집된 이미지가 있으면 사용, 없으면 원본으로 사용
    usingImage = (nil == editedImage) ? originalImage : editedImage;
    self.ProfileImageView.image = usingImage;
    
    CGSize size = CGSizeMake(IMAGESIZE, IMAGESIZE);
    UIImage *resizeImage = [self imageWithImage:usingImage scaledToSize:size];
    
    
    usingImage = resizeImage;
    
    //피커 감추기
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (IBAction)selectCountry:(id)sender {
    countryAlert = [[UIAlertView alloc]initWithTitle:@"Country" message:@"Select country" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Korea",@"Japan",@"America",@"China", nil];
    [countryAlert show];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
