//
//  InfoPopupView.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "InfoPopupView.h"
#import <UIImageView+AFNetworking.h>

@interface InfoPopupView()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak,nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak,nonatomic) IBOutlet UIImageView *handerImageView;
@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak,nonatomic) IBOutlet UILabel *yearLabel;
@property (weak,nonatomic) IBOutlet UILabel *styleLabel;
@property (weak,nonatomic) IBOutlet UILabel *stepLabel;
@property (weak,nonatomic) IBOutlet UILabel *ballLabel;
@end
@implementation InfoPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)clickCloseButton:(id)sender{
    [self setHidden:YES];
}
- (void)setDataWithDictionary:(NSDictionary *)inDic{
    /*
     allhighScore = "<null>";
     avg = "0.0";
     ballPhoto = "<null>";
     country = kor;
     hand = 1;
     highscore = "<null>";
     name = "\Uc815\Ub2e4\Uc6b4";
     proPhoto = "http://bowling.pineoc.cloulu.com/uploads/user/90/proPhoto.PNG";
     rank = 22;
     series800 = "<null>";
     step = "<null>";
     style = "<null>";
     */
    NSURL *proURL = [NSURL URLWithString:inDic[@"proPhoto"]];
    self.scoreLabel.text = inDic[@"avg"];
    self.nameLabel.text = inDic[@"name"];
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 70.0f;
    [self.profileImageView setImageWithURL:proURL];
    
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
