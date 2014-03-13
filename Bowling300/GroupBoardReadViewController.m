//
//  GroupBoardReadViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 19..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupBoardReadViewController.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#define URLLINK @"http://bowling.pineoc.cloulu.com/user/group/board/read"
@interface GroupBoardReadViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *writerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation GroupBoardReadViewController{
    AppDelegate *ad;
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
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self getData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getData{
    
    NSDictionary *sendDic = @{@"gidx":[NSString stringWithFormat:@"%d",(int)ad.selectedGroupIdx],
                                     @"bidx": self.bidx};
    
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
        NSString *result = responseObject[@"result"];
        if([result isEqualToString:@"SUCCESS"]){
            NSDictionary *one = responseObject[@"content"];
            self.titleLabel.text = one[@"title"];
            self.writerNameLabel.text = one[@"name"];
            NSString *contentURL = one[@"picture"];
            NSURL *URL = [NSURL URLWithString:contentURL];
            [self.contentImageView setImageWithURL:URL];
            self.contentTextView.text = one[@"content"];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Something wrong" delegate:nil cancelButtonTitle:@"OKay" otherButtonTitles: nil];
            [alert show];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        // 실패한경우...
        NSLog(@"Error: %@", error);
    }];

}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
