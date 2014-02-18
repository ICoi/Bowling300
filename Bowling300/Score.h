//
//  Score.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 4..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject
- (id)init;
- (id)initWithGroupNum:(NSInteger)inGroupNum withTotalScore:(NSInteger)inTotalScore withRowID:(NSInteger)inRowID;
- (id)initWithGroupNum:(NSInteger)inGroupNum withTotalScore:(NSInteger)inTotalScore withRowID:(NSInteger)inRowID withHandy:(NSInteger)inHandy;
@property NSInteger groupNum;
@property NSString *score;
@property NSInteger totalScore;
@property NSInteger rowID;
@property UIColor *groupColor;
@property NSInteger handy;
@end
