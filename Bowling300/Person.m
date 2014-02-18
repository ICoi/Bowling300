//
//  Person.m
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 10..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "Person.h"

@implementation Person

-(void)setValueWithName:(NSString *)inName withProfileURL:(NSURL *)inProfileURL withCountryURL:(NSURL *)inCountryURL withHandy:(NSInteger)inHandy withScore:(NSString *)score withYear:(NSInteger)inYear withStyle:(NSString *)inSytle withStep:(NSInteger)inStep withBall:(NSInteger)inBall with300:(NSInteger)in300 with800Series:(NSInteger)in800{
    self.name = inName;
    self.profileImage = inProfileURL;
    self.country = inCountryURL;
    self.hand = inHandy;
    self.score = score;
    self.fromYear = inYear;
    self.style = inSytle;
    self.step = inStep;
    self.ballPound = inBall;
    self.series300 = in300;
    self.series800 = in800;
}

@end
