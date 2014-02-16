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
@interface GroupView()

@end


@implementation GroupView{
    UIImageView *backgroundImageView;
    UIImageView *groupImageView;
    UIImageView *labelImageView;
    UIImageView *editImageView;
    UILabel *groupNameLabel;
    UILabel *dateLabel;
    
    BOOL nowEditMode;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *backgroundImage = [UIImage imageNamed:@"group_layout.png"];
        
        backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
        backgroundImageView.frame = CGRectMake(0, 0, 90, 90);
        
        
        UIImage *groupImage = [UIImage imageNamed:@"group_new_img1.png"];
        groupImageView = [[UIImageView alloc]initWithImage:groupImage];
        groupImageView.frame = CGRectMake(12, 13, 77, 77);
        
        
        UIImage *labelImage = [UIImage imageNamed:@"group_new_img_bg.png"];
        labelImageView = [[UIImageView alloc]initWithImage:labelImage];
        labelImageView.frame = CGRectMake(12, 60, 77, 30);
        
        groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 54, 86, 22)];
        groupNameLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        groupNameLabel.font = [UIFont systemFontOfSize:9.0];
        groupNameLabel.text = @"groupName";
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 67, 52, 21)];
        dateLabel.font = [UIFont systemFontOfSize:8.0];
        dateLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        dateLabel.text = @"2014.01.01";
        
        UIImage *editImage= [ UIImage imageNamed:@"group_edit_delete_icon.png"];
        editImageView = [[UIImageView alloc]initWithImage:editImage];
        [editImageView setHidden:YES];
        
        nowEditMode = NO;
        
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Menu" message:@"What do you want to do?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Represent   Group",@"Setting", nil];
        [alert show];
    }
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
