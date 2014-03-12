//
//  GroupWriteListCell.h
//  Bowling300
//
//  Created by 정다운 on 2014. 3. 12..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupWriteListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabe;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
-(void)setValueWithTitle:(NSString *)inTitle withName:(NSString *)inName withDate:(NSString *)inDate withImageURL:(NSString *)inImageURL;
-(void)setValueWithTitle:(NSString *)inTitle withName:(NSString *)inName withDate:(NSString *)inDate;
@end
