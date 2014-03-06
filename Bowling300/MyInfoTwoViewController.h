//
//  MyInfoTwoViewController.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 20..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
/*
 요청
 http://bowling.pineoc.cloulu.com/user/addsign
 {
 "aidx":"100",
 "name":"nn",
 "pwd":"123321",
 "hand":"1",
 "sex":"1",
 "year":"2005",
 "ballweight":"11",
 "style":"1",
 "step":"3",
 "series800":"1",
 "series300":"1",
 }
 
 */
@interface MyInfoTwoViewController : UIViewController
@property Person *me;
@end
