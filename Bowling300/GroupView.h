//
//  GroupView.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupView : UIView
- (void)setValueWithGroupIdx:(NSInteger)idx withGroupName:(NSString *)inGroupName withDate:(NSString *)inDate withImageLink:(NSString *)inImageLink;
@property NSInteger groupIdx;
- (void)setEditMode:(BOOL)ck;
@end
