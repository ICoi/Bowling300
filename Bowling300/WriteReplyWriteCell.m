//
//  WriteReplyWriteCell.m
//  Bowling300
//
//  Created by 정다운 on 2014. 3. 19..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "WriteReplyWriteCell.h"
#import <AFNetworking.h>
#import "AppDelegate.h"

#define URLLINK @"http://bowling300.cafe24app.com/user/group/board/commwrite"
@interface WriteReplyWriteCell()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation WriteReplyWriteCell{
    AppDelegate *ad;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickReplyWrite:(id)sender {
    ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"save");
    
    //REPLYWRITEURLLINK
    NSDictionary *sendDic = @{@"aidx":[NSString stringWithFormat:@"%d",ad.myIDX],@"gidx":[NSString stringWithFormat:@"%d",(int)ad.selectedGroupIdx],
                              @"bidx": self.bidx,@"content":self.textField.text};
    
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
            
            // 다썻다고 정보 보냄!!
            NSDictionary *dic = @{@"content": self.textField.text};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"commentSendRecv" object:nil userInfo:dic];
            
            self.textField.text = NULL;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Server was not connected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        // 실패한경우...
        NSLog(@"Error: %@", error);
    }];
    
    
}

@end
