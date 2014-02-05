//
//  BLGraphYear.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 5..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLGraphMonth.h"
@interface BLGraphYear : NSObject
@property (nonatomic) NSMutableDictionary *months;

- (void)addDataWithMonth:(NSString *)inMonth withGroup:(NSInteger)inGroupNum withScore:(NSInteger)inScore;
@end
