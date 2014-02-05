//
//  BLGraphYear.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 5..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "BLGraphYear.h"

@implementation BLGraphYear
- (id)init{
    self = [super init];
    if (self) {
        self.months = [[NSMutableDictionary alloc]init];
    }
    return  self;
}
- (void)addDataWithMonth:(NSString *)inMonth withGroup:(NSInteger)inGroupNum withScore:(NSInteger)inScore{
    BLGraphMonth *tmpMonth = self.months[inMonth];
    if(tmpMonth == nil){
        //해당 월에 데이터가 하나도 없는 경우
        tmpMonth = [[BLGraphMonth alloc]init];
        [tmpMonth addDataWithGroup:inGroupNum withScore:inScore];
        [self.months setObject:tmpMonth forKey:inMonth];
    }
    else{
        // 해당 월에 이미 데이터가 한개라도 존재하는 경우
        [tmpMonth addDataWithGroup:inGroupNum withScore:inScore];
    }
}
@end
