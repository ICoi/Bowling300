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
- (id)initWithGroupNum:(NSInteger)inGroupNum withTotalScore:(NSInteger)inTotalScore;
@property NSInteger groupNum;
@property NSString *score;
@property NSInteger totalScore;
@end
