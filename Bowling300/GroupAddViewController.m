//
//  GroupAddViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupAddViewController.h"
#import "DBGroupManager.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#define IMAGESIZE 300
#define URLLINK @"http://bowling.pineoc.cloulu.com/user/groupmake"
///user/groupmake
@interface GroupAddViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GroupAddViewController{
    DBGroupManager *dbManager;
    UIImage *usingImage;
    AppDelegate *ad;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dbManager = [DBGroupManager sharedModeManager];
	// Do any additional setup after loading the view.
    
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (void)viewWillAppear:(BOOL)animated{
    
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
- (IBAction)saveData:(id)sender {
    NSInteger myIdx = ad.myIDX;
    NSLog(@"my idx : %d",myIdx);
    
    NSString *groupName = self.groupNameLabel.text;
    NSString *groupPassword = self.passwordLabel.text;
    NSData *imageData = UIImageJPEGRepresentation(usingImage, 0.5);
    // 그룹의 색상을 임의로 정함
    NSInteger redColor = rand()%255;
    NSInteger greenColor = rand()%255;
    NSInteger blueColor = rand()%255;
    
    NSLog(@"NEW GROUP name : %@ idx: %d red : %d green : %d blue : %d",@"",10,redColor,greenColor,blueColor);
    if ((myIdx == 0) || ([groupName isEqualToString:@""]) || ([groupPassword isEqualToString:@""]) || ( imageData == nil)) {
        NSLog(@"Null Error");
    }
    else{
    
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
    
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        NSDictionary *parameters = @{@"aidx": [NSString stringWithFormat:@"%d",myIdx],@"gname":groupName,@"gpwd":groupPassword};
        NSInteger randomNum = arc4random()%10000000;
        NSString *randomName = [NSString stringWithFormat:@"%d.PNG",randomNum];
        NSLog(@"%@",randomName);
        AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"grpPhoto" fileName:randomName mimeType:@"multipart/form-data"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *result = responseObject[@"result"];
            if([result isEqualToString:@"FAIL"]){
                NSLog(@"result is fail");
            }else{
                NSLog(@"result is success");
                NSInteger groupIdx = [responseObject[@"gidx"] integerValue];
            
                [dbManager addDataInGroupTableWithGroupIdx:groupIdx withGroupName:groupName withGroupRedColor:redColor withGroupGreenColor:greenColor withGroupBlueColor:blueColor];
            
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];
    }
    
}
- (IBAction)takePhoto:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Select" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Take picture",@"Album", nil];
    [alert show];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    self.groupImageView.image = usingImage;
    
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
