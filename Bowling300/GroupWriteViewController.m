//
//  GroupWriteViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupWriteViewController.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

#define URLLINK @"http://bowling300.cafe24app.com/user/group/board/write"
#define IMAGESIZE 300

@interface GroupWriteViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;

@end

@implementation GroupWriteViewController{
    AppDelegate *ad;
    UIImage *usingImage;
    UIAlertView *cameraAlert;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.contentLabel setTextColor:[UIColor greenColor]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickecSave:(id)sender {
    NSString *title = self.titleLabel.text;
    NSString *content = self.contentLabel.text;
    NSData *imageData = UIImageJPEGRepresentation(usingImage, 0.5);
    if([title isEqualToString:@""] || [content isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You have to write all datas" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }else{
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
        
        NSDictionary *parameters = @{@"gidx": [NSString stringWithFormat:@"%d",ad.selectedGroupIdx],@"aidx":[NSString stringWithFormat:@"%d",ad.myIDX],@"title":title,@"content":content};
        NSLog(@"%@",parameters);
        
        NSInteger randomNum = arc4random()%10000000000;
        NSString *randomName = [NSString stringWithFormat:@"%d.PNG",randomNum];
        if (imageData == nil) {
            AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON : %@",responseObject);
                
                NSString *result = responseObject[@"result"];
                if([result isEqualToString:@"FAIL"]){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Someting wrong" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                    [alert show];
                    
                }else{
                    NSLog(@"result is success");
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            }];
            [op start];

        }else{
            AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"photo" fileName:randomName mimeType:@"multipart/form-data"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON : %@",responseObject);
            
            NSString *result = responseObject[@"result"];
            if([result isEqualToString:@"FAIL"]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Someting wrong" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
        
            }else{
                NSLog(@"result is success");
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alert show];
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];
        }
    }
}




- (IBAction)takePhoto:(id)sender {
    cameraAlert = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Select" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Take picture",@"Album", nil];
    [cameraAlert show];
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
    self.imageView.image = usingImage;
    
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
// 키보드에 return키 누르면 들어가게 하는거
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
