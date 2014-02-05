//
//  BLGraphMonth.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 5..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLGraphScore.h"
@interface BLGraphMonth : NSObject
@property NSMutableDictionary *scores;
@property NSInteger totalScore;
@property NSInteger totalGameCnt;
- (void)addDataWithGroup:(NSInteger)inGroupNum withScore:(NSInteger)inScore;
@end
