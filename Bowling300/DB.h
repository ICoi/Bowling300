//
//  DB.h
//  Bowling300
//
//  Created by ico on 14. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface DB : NSObject{
    sqlite3 *db;
}
- (BOOL)openDB;

@end
