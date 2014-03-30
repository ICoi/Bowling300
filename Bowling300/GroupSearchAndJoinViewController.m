//
//  GroupSearchAndJoinViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 14..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupSearchAndJoinViewController.h"
#import "GroupListCell.h"
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "DBGroupManager.h"
#define URLLINK @"http://bowling300.cafe24app.com/user/groupsearch"
#define URLJOINLINK @"http://bowling300.cafe24app.com/user/groupjoin"
#define GROUPCELL @"GROUP_LIST_CELL"

@interface GroupSearchAndJoinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *listTable;

@end

@implementation GroupSearchAndJoinViewController{
    NSMutableArray *groupList;
    AppDelegate *ad;
    NSString *selectGroupName;
    DBGroupManager *dbManager;
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
    groupList = [[NSMutableArray alloc]init];
	// Do any additional setup after loading the view.
    ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    selectGroupName = @"";
    dbManager = [DBGroupManager sharedModeManager];
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:20.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchGroup:(id)sender {
    NSString *searchGroupName = self.searchTextField.text;
    NSLog(@"search group name : %@",searchGroupName);
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    NSDictionary *parameters = @{@"gname":searchGroupName};
    AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        groupList = responseObject[@"arr"];
        NSLog(@"group list : %@",groupList);
        [self.listTable reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];

}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupListCell *cell = [tableView  dequeueReusableCellWithIdentifier:GROUPCELL forIndexPath:indexPath];
    NSDictionary *one = [groupList objectAtIndex:indexPath.row];
    [cell setValueWithName:one[@"gmaster"] withGroupName:one[@"gname"] withGroupImageURL:one[@"gphoto"]];
 
    return  cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  groupList.count;
}

// 그룹 선택시 alertview를 통해 무엇을 할지 결정
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO
    
    NSDictionary *one = [groupList objectAtIndex:indexPath.row];
    selectGroupName = one[@"gname"];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Join" message:@"Please write Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Join", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.firstOtherButtonIndex == buttonIndex){
        // UITextField *password = [alertView textFieldAtIndex:0];
        // 정보를 보낸다!
        UITextField *passwordField = [alertView textFieldAtIndex:0];
        
        NSLog(@"Password : %@",passwordField.text);
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLJOINLINK]];
        
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        NSDictionary *parameters = @{@"aidx":[NSString stringWithFormat:@"%d",ad.myIDX],@"gname":selectGroupName,@"gpwd":passwordField.text};
        NSLog(@"parameters : %@",parameters);
        AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@",responseObject);
            if([responseObject[@"result"] isEqualToString:@"SUCCESS"]){
                NSString *groupIdx = responseObject[@"gidx"];
            
                // 그룹의 색상을 임의로 정함
                NSInteger redColor = rand()%255;
                NSInteger greenColor = rand()%255;
                NSInteger blueColor = rand()%255;
                [dbManager addDataInGroupTableWithGroupIdx:[groupIdx integerValue] withGroupName:selectGroupName withGroupRedColor:redColor withGroupGreenColor:greenColor withGroupBlueColor:blueColor];
            
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Join Error" message:@"Password was wrong!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];

        
    }
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
