//
//  GroupListCell.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 14..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "GroupListCell.h"
@interface GroupListCell()
@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *groupNameLabel;
@end

@implementation GroupListCell

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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setValueWithName:(NSString *)inName withGroupName:(NSString *)inGroupName{
    self.nameLabel.text = inName;
    self.groupNameLabel.text = inGroupName;
}
@end
