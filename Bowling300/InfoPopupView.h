//
//  InfoPopupView.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPopupView : UIView
- (void)setDataWithDictionary:(NSDictionary *)inDic;

- (void)setValueWithProfileURL:(NSURL *)inProfileURL withCountryURL:(NSURL *)inCountryURL withHandy:(NSInteger)inHandy withName:(NSString *)inName withScore:(NSString *)inScore withYears:(NSInteger)inYears withStyle:(NSInteger)instyle withStep:(NSInteger)inStep withBall:(NSInteger)inBall with300:(NSInteger)in300 with800Series:(NSInteger)in800;
@end
