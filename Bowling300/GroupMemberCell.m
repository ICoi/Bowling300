//
//  GroupMemberCell.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 18..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupMemberCell.h"
#import <UIImageView+AFNetworking.h>
@interface GroupMemberCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation GroupMemberCell{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (void)setValueWithName:(NSString *)inName withProfileURL:(NSURL *)inURL{
    self.nameLabel.text = inName;
    [self.profileImageView setImageWithURL:inURL];
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 44.0f;
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
