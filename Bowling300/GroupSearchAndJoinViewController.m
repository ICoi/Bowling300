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

#define GROUPCELL @"GROUP_LIST_CELL"

@interface GroupSearchAndJoinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *groupSearchBar;

@end

@implementation GroupSearchAndJoinViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchGroup:(id)sender {
    NSString *searchGroupName = self.groupSearchBar.text;
    NSLog(@"search group name : %@",searchGroupName);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:URLLINK]];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    NSDictionary *parameters = @{@"aidx": [NSString stringWithFormat:@"%d",myIdx],@"gname":groupName,@"gpwd":groupPassword};
    AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"grpPhoto" fileName:@"grpPhoto.png" mimeType:@"multipart/form-data"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *result = responseObject[@"result"];
        if([result isEqualToString:@"FAIL"]){
            NSLog(@"result is fail");
        }else{
            NSLog(@"result is success");
            NSInteger groupIdx = [responseObject[@"aidx"] integerValue];
            NSString *imageLink = @"";
            
            [dbManager addDataInGroupTableWithGroupIdx:groupIdx withGroupName:@"groupTest" withGroupRedColor:redColor withGroupGreenColor:greenColor withGroupBlueColor:blueColor];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    [op start];

}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupListCell *cell = [tableView  dequeueReusableCellWithIdentifier:GROUPCELL forIndexPath:indexPath];
    [cell setValueWithName:@"name" withGroupName:@"group"];
 
    return  cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  3;
}
@end
