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
@property (nonatomic) NSString *countryName;
@property (nonatomic) NSURL *country;
@property (nonatomic) NSInteger hand;
@property (nonatomic) NSString *score;
@property (nonatomic) NSInteger fromYear;
@property (nonatomic) NSInteger style;
@property (nonatomic) NSInteger step;
@property (nonatomic) NSInteger ballPound;
@property (nonatomic) NSInteger series300;
@property (nonatomic) NSInteger series800;
@property (nonatomic) NSInteger gender;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *pwd;

-(void)setValueWithName:(NSString *)inName withProfileURL:(NSURL *)inProfileURL withCountryURL:(NSURL *)inCountryURL withHandy:(NSInteger)inHandy withScore:(NSString *)score withYear:(NSInteger)inYear withStyle:(NSInteger)inSytle withStep:(NSInteger)inStep withBall:(NSInteger)inBall with300:(NSInteger)in300 with800Series:(NSInteger)in800;
-(void)setValueWithName:(NSString *)inName withGender:(NSInteger)inGender withCountry:(NSString *)inCountry withEmail:(NSString *)inEmail withPWD:(NSString *)inPwd withHand:(NSInteger)inHand withProfileImg:(NSString *)inProfileImg withFromyear:(NSInteger)inFromyear withBallPound:(NSInteger)inBallPound withSeries300:(NSInteger)in300 withSeries800:(NSInteger)in800 withStep:(NSInteger)inStep withStyle:(NSInteger)inStyle;
@end
