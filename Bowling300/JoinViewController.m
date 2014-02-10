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
#define URLLINK @"http://bowling.pineoc.cloulu.com/user/sign"


@interface JoinViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImageView;

@end

@implementation JoinViewController{
    DBMyInfoManager *dbInfoManager;
    UIImage *usingImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dbInfoManager = [DBMyInfoManager sharedModeManager];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
 
 UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
 NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 NSDictionary *parameters = @{@"foo": @"bar"};
 NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
 [manager POST:@"http://example.com/resources.json" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 [formData appendPartWithFileData:imageData name:@"image" error:nil];
 } success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"Success: %@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];
 */
- (IBAction)pressSaveButton:(id)sender {
    NSString *name = self.nameField.text;
    NSString *email = self.emailField.text;
    BOOL gender = TRUE;
    NSString *country = self.countryField.text;
    NSString *password = self.passwordField.text;
    BOOL hand = TRUE;
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
    
    NSData *imageData = UIImageJPEGRepresentation(usingImage, 0.5);
    NSDictionary *parameters = @{@"email": email,@"name":name,@"pwd":password,@"sex":@"0",@"country":country,@"hand":@"0"};
    AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"proPhoto" fileName:@"proPhoto.PNG" mimeType:@"multipart/form-data"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // TODO
        // 여기서 응답 온거 가지고 처리해야한다!!!
        NSString *result = responseObject[@"result"];
        if([result isEqualToString:@"FAIL"]){
            NSLog(@"result is fail");
        }else{
            NSLog(@"result is success");
            NSInteger idx = [responseObject[@"aidx"] integerValue];
            NSString *imageLink = @"";
            [dbInfoManager joinMemberWithIdx:idx WithName:name withGender:gender withCountry:country withEmail:email withPwd:password withHand:hand withImage:imageLink];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];
    
}
- (IBAction)clickCamera:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Select" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Take picture",@"Alberm", nil];
    [alert show];
}

//alertView 선택시
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.firstOtherButtonIndex){
        [self takePicture];
    }else{
        //앨범에서 가져오는거
        [self getImage];
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
    
    //피커 감추기
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
