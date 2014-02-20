//
//  GroupView.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupView.h"
#import <UIImageView+AFNetworking.h>
#import "Group.h"
#import "DBGroupManager.h"
#import "AppDelegate.h"
@interface GroupView()<UIActionSheetDelegate>

@end


@implementation GroupView{
    UIImageView *backgroundImageView;
    UIImageView *groupImageView;
    UIImageView *labelImageView;
    UIImageView *editImageView;
    UILabel *groupNameLabel;
    UILabel *dateLabel;
    
    BOOL nowEditMode;
    DBGroupManager *dbManager;
    BOOL representive;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dbManager = [DBGroupManager sharedModeManager];
        // Initialization code
        UIImage *backgroundImage = [UIImage imageNamed:@"group_layout.png"];
        
        backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
        backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        
        UIImage *groupImage = [UIImage imageNamed:@"group_new_img1.png"];
        groupImageView = [[UIImageView alloc]initWithImage:groupImage];
        groupImageView.frame = CGRectMake(self.frame.size.width*0.125, self.frame.size.height*0.125, self.frame.size.width*0.875, self.frame.size.height*0.875);
        
        
        UIImage *labelImage = [UIImage imageNamed:@"group_new_img_bg.png"];
        labelImageView = [[UIImageView alloc]initWithImage:labelImage];
        labelImageView.frame = CGRectMake(self.frame.size.width*0.125, self.frame.size.height*0.75, self.frame.size.width*0.875, self.frame.size.height*0.25);
        
        groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.15, self.frame.size.height*0.75, self.frame.size.width*0.85, self.frame.size.height*0.125)];
        groupNameLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        groupNameLabel.text = @"groupName";
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.15, self.frame.size.height*0.875, self.frame.size.width*0.85, self.frame.size.height*0.125)];
        
        
        dateLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        dateLabel.text = @"2014.01.01";
        
        UIImage *editImage= [ UIImage imageNamed:@"group_edit_delete_icon.png"];
        editImageView = [[UIImageView alloc]initWithImage:editImage];
        editImageView.frame = CGRectMake(self.frame.size.width*0.06, self.frame.size.height*0.06, self.frame.size.width*0.2, self.frame.size.height*0.2);
        [editImageView setHidden:YES];
        
        nowEditMode = NO;
        
        
        
        if(self.frame.size.width >100){
            groupNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
            dateLabel.font = [UIFont systemFontOfSize:13.0];
        }else{
            groupNameLabel.font = [UIFont boldSystemFontOfSize:12.0];
            dateLabel.font = [UIFont systemFontOfSize:7.0];
        }
        
        
        [self addSubview:groupImageView];
        [self addSubview:labelImageView];
        [self addSubview:groupNameLabel];
        [self addSubview:dateLabel];
        [self addSubview:backgroundImageView];
        [self addSubview:editImageView];
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches??");
    if(nowEditMode){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"Set Representive", nil];
        
        [actionSheet showInView:self];
    }else{        AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        ad.selectedGroupIdx = self.groupIdx;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showGroup" object:nil];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == actionSheet.cancelButtonIndex){
        
    }
    else if(buttonIndex == actionSheet.destructiveButtonIndex){
    
    }else if(buttonIndex == actionSheet.firstOtherButtonIndex) {
        
        
        [dbManager setRepresentiveGroupWithGroupIdx:self.groupIdx];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshGroupList" object:nil];
    }
}


-(void)setRepresentive{
    representive = TRUE;
}
- (void)setValueWithGroupIdx:(NSInteger)idx withGroupName:(NSString *)inGroupName withDate:(NSString *)inDate withImageLink:(NSString *)inImageLink{
    self.groupIdx = idx;
    groupNameLabel.text = inGroupName;
    dateLabel.text = inDate;
    NSURL *imageURL = [NSURL URLWithString:inImageLink];
    [groupImageView setImageWithURL:imageURL];
}
- (void)setEditMode:(BOOL)ck{
    if(ck){
        NSLog(@"EditMode");
        [editImageView setHidden:NO];
        nowEditMode = YES;
    } else{
        NSLog(@"EditMode end");
        [editImageView setHidden:YES];
        nowEditMode = NO;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
