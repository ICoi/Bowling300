//
//  Person.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 10..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *profileImage;
@property (nonatomic) NSURL *country;
@property (nonatomic) NSInteger hand;
@property (nonatomic) NSString *score;
@property (nonatomic) NSInteger fromYear;
@property (nonatomic) NSString *style;
@property (nonatomic) NSInteger step;
@property (nonatomic) NSInteger ballPound;
@property (nonatomic) NSInteger series300;
@property (nonatomic) NSInteger series800;

-(void)setValueWithName:(NSString *)inName withProfileURL:(NSURL *)inProfileURL withCountryURL:(NSURL *)inCountryURL withHandy:(NSInteger)inHandy withScore:(NSString *)score withYear:(NSInteger)inYear withStyle:(NSString *)inSytle withStep:(NSInteger)inStep withBall:(NSInteger)inBall with300:(NSInteger)in300 with800Series:(NSInteger)in800;
@end
