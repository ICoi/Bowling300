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
#define IMAGESIZE 300
@interface GroupAddViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;


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
    /*
    NSInteger groupIdx = [self.groupIdxLabel.text integerValue];
    NSString *groupName = self.groupNameLabel.text;
    NSInteger redColor = [self.groupRedLabel.text integerValue];
    NSInteger greenColor = [self.groupGreenLabel.text integerValue];
    NSInteger blueColor = [self.groupBlueLabel.text integerValue];
    
    
     [dbManager addDataInGroupTableWithGroupIdx:groupIdx withGroupName:groupName withGroupRedColor:redColor withGroupGreenColor:greenColor withGroupBlueColor:blueColor];
      */
    
    //여기   Save버튼 누르면 그룹 디비에도 저장하고 서버로도 보내야되1!1
    // TODO
    
    NSInteger myIdx = ad.myIDX;
    NSLog(@"my idx : %d",myIdx);
    
    // 그룹의 색상을 임의로 정함
    NSInteger redColor = rand()%255;
    NSInteger greenColor = rand()%255;
    NSInteger blueColor = rand()%255;
    
    NSLog(@"NEW GROUP name : %@ idx: %d red : %d green : %d blue : %d",@"",10,redColor,greenColor,blueColor);
    
}
- (IBAction)takePhoto:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Select" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Take picture",@"Alberm", nil];
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


@end
