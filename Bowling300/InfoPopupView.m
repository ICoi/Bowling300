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
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UIImageView *profileImageView;
@property (nonatomic) UIImageView *profileImageBackground;
@property (nonatomic) UIImageView *handerImageView;
@property (nonatomic) UIImageView *handerImageBackground;
@property (nonatomic) UIImageView *countryImageView;
@property (nonatomic) UIImageView *countryImageBackground;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *yearLabel;
@property (nonatomic) UILabel *styleLabel;
@property (nonatomic) UILabel *stepLabel;
@property (nonatomic) UIImageView *ballImageView;
@property (nonatomic) UILabel *ballLabel;
@property (nonatomic) UIImageView *series300ImageView;
@property (nonatomic) UIImageView *series800ImageView;
@end
@implementation InfoPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *image = [UIImage imageNamed:@"ranking_x.png"];
        UIImage *highlightImage;
        self.closeButton = [[UIButton alloc]initWithFrame:CGRectMake(225, 44, 30, 30)];
        self.closeButton.imageView.image = image;
        
        image = [UIImage imageNamed:@"ranking_flag_bg.png"];
        self.handerImageBackground = [[UIImageView alloc]initWithFrame:CGRectMake(34, 105, 54, 54)];
        self.handerImageBackground.image = image;
        self.countryImageBackground = [[UIImageView alloc]initWithFrame:CGRectMake(233, 105, 54, 54)];
        self.countryImageBackground.image = image;
        
        image = [UIImage imageNamed:@"ranking_hander_l.png"];
        highlightImage = [UIImage imageNamed:@"ranking_hander_r.png"];
        self.handerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(41, 115, 35, 35)];
        self.handerImageView.image = image;
        self.handerImageView.highlightedImage = highlightImage;
        self.countryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(245, 122, 30, 20)];
        
        image = [UIImage imageNamed:@"board_profile.png"];
        self.profileImageBackground = [[UIImageView alloc]initWithFrame:CGRectMake(91, 57, 138, 138)];
        self.profileImageBackground.image = image;
        
        self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(93, 59, 134, 134)];
        
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = 67.0f;
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(91, 208, 140, 21)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(121, 230, 82, 21)];
        self.scoreLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        
        self.yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(57, 255, 50, 21)];
        self.yearLabel.font = [UIFont systemFontOfSize:13.0f];
        self.yearLabel.text = @"1 Years";
        self.styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(122, 255, 82, 21)];
        self.styleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.styleLabel.text = @"Straight Ball";
        self.stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(228, 255, 50, 21)];
        self.stepLabel.font = [UIFont systemFontOfSize:13.0f];
        self.stepLabel.text = @"3 Steps";
        
        image = [UIImage imageNamed:@"ranking_ballimg.png"];
        self.ballImageView = [[UIImageView alloc]initWithFrame:CGRectMake(44, 305, 28, 26)];
        self.ballImageView.image = image;
        
        self.ballLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 307, 53, 21)];
        self.ballLabel.text = @"3 Pounds";
        self.ballLabel.font = [UIFont systemFontOfSize:12.0f];
        
        image = [UIImage imageNamed:@"ranking_300icon.png"];
        highlightImage = [UIImage imageNamed:@"ranking_300icon_over.png"];
        self.series300ImageView = [[UIImageView alloc]initWithImage:image highlightedImage:highlightImage];
        self.series300ImageView.frame = CGRectMake(184, 289, 47, 46);
        
        image = [UIImage imageNamed:@"ranking_800icon.png"];
        highlightImage = [UIImage imageNamed:@"ranking_800icon_over.png"];
        
        self.series800ImageView = [[UIImageView alloc]initWithImage:image highlightedImage:highlightImage];
        self.series800ImageView.frame = CGRectMake(233, 289, 47, 46);
        
        
        image = [UIImage imageNamed:@"ranking_myinfo.png"];
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 391)];
        self.backgroundImageView.image = image;
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.closeButton];
        [self addSubview:self.profileImageView];
        [self addSubview:self.profileImageBackground];
        [self addSubview:self.handerImageBackground];
        [self addSubview:self.handerImageView];
        [self addSubview:self.countryImageBackground];
        [self addSubview:self.countryImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.scoreLabel];
        [self addSubview:self.yearLabel];
        [self addSubview:self.styleLabel];
        [self addSubview:self.stepLabel];
        [self addSubview:self.ballImageView];
        [self addSubview:self.ballLabel];
        [self addSubview:self.series300ImageView];
        [self addSubview:self.series800ImageView];
        
    }
    return self;
}
- (IBAction)clickCloseButton:(id)sender{
    [self setHidden:YES];
}
- (void)setValueWithProfileURL:(NSURL *)inProfileURL withCountryURL:(NSURL *)inCountryURL withHandy:(NSInteger)inHandy withName:(NSString *)inName withScore:(NSString *)inScore withYears:(NSInteger)inYears withStyle:(NSString *)instyle withStep:(NSInteger)inStep withBall:(NSInteger)inBall with300:(NSInteger)in300 with800Series:(NSInteger)in800{
    [self.profileImageView setImageWithURL:inProfileURL];
    [self.countryImageView setImageWithURL:inCountryURL];
    if(inHandy == 1){
        [self.handerImageView setHighlighted:YES];
    }
    
    self.scoreLabel.text = inScore;
    self.nameLabel.text = inName;
    self.yearLabel.text = [NSString stringWithFormat:@"%d",inYears];
    self.styleLabel.text = instyle;
    self.stepLabel.text = [NSString stringWithFormat:@"%d Steps",inStep];
    self.ballLabel.text = [NSString stringWithFormat:@"%d Pounds",inBall];
    if(in300 == 1){
        [self.series300ImageView setHighlighted:YES];
    }
    if(in800 == 1){
        [self.series800ImageView setHighlighted:YES];
    }
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setHidden:YES];
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
