//
//  GlobalRankingCell.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalRankingCell : UITableViewCell
- (void)setValueWithRankingNum:(NSInteger)inRankingNum withName:(NSString *)inName withScore:(NSString *)inScore withProfileImageURL:(NSURL*)inImageURL withCountryImageURL:(NSURL*)inCountryURL;


@end
