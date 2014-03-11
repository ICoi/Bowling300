//
//  GlobalRankingCell.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GlobalRankingCell.h"
#import <UIImageView+AFNetworking.h>
@interface GlobalRankingCell()
@property (weak, nonatomic) IBOutlet UILabel *rankingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *countryImageView;


@end

@implementation GlobalRankingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setValueWithRankingNum:(NSInteger)inRankingNum withName:(NSString *)inName withScore:(NSString *)inScore withProfileImageURL:(NSURL*)inImageURL withCountryImageURL:(NSURL*)inCountryURL{
    self.rankingNumLabel.text = [NSString stringWithFormat:@"%d",(int)inRankingNum];
    self.scoreLabel.text = inScore;
    self.nameLabel.text = inName;
    
    //self.scoreLabel.font = [UIFont fontWithName:@"expansiva" size:self.scoreLabel.font.pointSize];
    
    [self.profileImageView setImageWithURL:inImageURL];
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 20.0f;
    
    
    [self.countryImageView setImageWithURL:inCountryURL];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
