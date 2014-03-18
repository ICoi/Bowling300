//
//  WriteReplyCell.h
//  Bowling300
//
//  Created by 정다운 on 2014. 3. 19..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteReplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *writerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (void)setvalueWithTitle:(NSString *)inTitle withWriter:(NSString *)inWriter withDate:(NSString *)inDate;
@end
