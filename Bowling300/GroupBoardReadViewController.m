//
//  GroupBoardReadViewController.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 19..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupBoardReadViewController.h"
#import "WriteReplyWriteCell.h"
#import "WriteReplyCell.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#define URLLINK @"http://bowling.pineoc.cloulu.com/user/group/board/read"
@interface GroupBoardReadViewController (){
    int dy;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *writerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *commentCntLabel;

@end

@implementation GroupBoardReadViewController{
    AppDelegate *ad;
    NSMutableArray *commentDatas;
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
    
    commentDatas = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentSendRecv:) name:@"commentSendRecv" object:nil];
    
    // 감시 객체 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
            if([[NSString stringWithFormat:@"%@",one[@"picture"]] isEqualToString:@"<null>"]){
            }else{
                NSString *contentURL = one[@"picture"];
                NSURL *URL = [NSURL URLWithString:contentURL];
                [self.contentImageView setImageWithURL:URL];
            }
                self.contentTextView.text = one[@"content"];
            self.contentTextView.textColor = [UIColor whiteColor];
            
            NSString *writerURL = one[@"writerPhoto"];
            NSURL *URL = [NSURL URLWithString:writerURL];
            [self.userImageView setImageWithURL:URL];
            
            
            if([[NSString stringWithFormat:@"%@",responseObject[@"comment"]]isEqualToString:@"<null>"]){
                // 코멘트가 없는 경우
            }else{
                //코멘트가 있는 경우
                commentDatas = responseObject[@"comment"];
                self.commentCntLabel.text = [NSString stringWithFormat:@"Comments(%d)",commentDatas.count];
                [self.tableView reloadData];
                
            
            }
            
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



// 여기 아래는 댓글 부분
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == commentDatas.count) {
    
        WriteReplyWriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WRITEREPLY" forIndexPath:indexPath];
        
        cell.bidx = self.bidx;
        return cell;
    }else{
        WriteReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"REPLYCELL" forIndexPath:indexPath];
        NSDictionary *one = [commentDatas objectAtIndex:indexPath.row];
        [cell setvalueWithTitle:one[@"comment"] withWriter:one[@"name_comm"] withDate:one[@"writedate"]];
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentDatas.count + 1;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


// 모든 서브뷰를 찾아서 최초 응답 객체를 반환
- (UITextField *)firstResponderTextField{
    for(id child in self.view.subviews){
        if([child isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)child;
            
            if(textField.isFirstResponder){
                return textField;
            }
        }
    }
    return nil;
}

- (IBAction)dissmissKeyboard:(id)sender{
    [[self firstResponderTextField]resignFirstResponder];
    // 모든 서브 뷰를 찾아서 최초 응답 객체에서 해제시킨다.
}

// 키보드가 나타나는 알림이 발생하면 동작
- (void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"keyboardWillShow, noti : %@ ",noti);
    
    UITextField *firstResponder = (UITextField *)[self firstResponderTextField];
    int y = 451;
    int viewHeight = self.view.frame.size.height;
    
    NSDictionary *userInfo = [noti userInfo];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    int keyboardHeight = (int)rect.size.height;
    
    float animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 키보드가 텍스트 필드를 가리는 경우
    if (keyboardHeight > (viewHeight - y)){
        NSLog(@"키보드가 가림");
        [UIView animateWithDuration:animationDuration animations:^{dy = keyboardHeight - (viewHeight - y);
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - dy);
        }];
    }
    else{
        NSLog(@"키보드가 가리지 않음");
        dy = 0;
        
    }
    
}

// 키보드가 사라지는 알림이 발생하면 동작
- (void)keyboardWillHide:(NSNotification *)noti{
    NSLog(@"keyboard Will Hide");
    
    if( dy > 0){
        float animationDuration = [[[noti userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:animationDuration animations:^{ self.view.center = CGPointMake(self.view.center.x, self.view.center.y + dy);}];
    }
}
- (void)commentSendRecv:(NSNotification *)notification{
    if([[notification name]isEqualToString:@"commentSendRecv"]){
        [self.view endEditing:YES];
        [self.tableView reloadData];
    }
}

@end
