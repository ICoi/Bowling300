//
//  ScoreCell.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 20..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCell : UICollectionViewCell
- (void)setValueWithRowIDX:(NSInteger)inRowIDX withscore:(NSString *)inScore withHandy:(BOOL)inHandy withColor:(UIColor *)inColor;

@end
