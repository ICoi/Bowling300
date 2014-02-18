//
//  AirBalloonView.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 16..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "AirBalloonView.h"
#import <UIImageView+AFNetworking.h>
@implementation AirBalloonView{
    UILabel *scoreLabel;
    UIImageView *bgImageView;
    UIImageView *profileImageView;
    UILabel *nameLabel;
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 42, 20)];
        scoreLabel.text = @"150";
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.font = [UIFont boldSystemFontOfSize:10.0];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 42, 20)];
        nameLabel.text = @"name";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont boldSystemFontOfSize:10.0];
        nameLabel.textColor = [UIColor whiteColor];
        
        UIImage *paraImage = [UIImage imageNamed:@"group_league_para.png"];
        UIImage *paraHighlightImage = [UIImage imageNamed:@"group_league_para_200.png"];
        bgImageView = [[UIImageView alloc]initWithImage:paraImage highlightedImage:paraHighlightImage];
        bgImageView.frame = CGRectMake(0, 0, 60, 90);
        profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 37, 50, 50)];
        
        profileImageView.layer.masksToBounds = YES;
        profileImageView.layer.cornerRadius = 25.0f;
        
        [self addSubview:profileImageView];
        [self addSubview:bgImageView];
        [self addSubview:scoreLabel];
        [self addSubview:nameLabel];
    }
    return self;
}

- (void)setValueWithScore:(NSInteger)inScore withProfileURL:(NSString *)inProfileURL withName:(NSString *)inName{
    scoreLabel.text = [NSString stringWithFormat:@"%d",inScore];
    nameLabel.text = inName;
    if(inScore >= 200){
        [bgImageView setHighlighted:YES];
    }else{
        [bgImageView setHighlighted:NO];
    }
    
    NSURL *profileURL = [NSURL URLWithString:inProfileURL];
    [profileImageView setImageWithURL:profileURL];
    
}

- (void)isMe{
    UIImage *image = [UIImage imageNamed:@"group_league_para_me.png"];
    bgImageView.image = image;
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
