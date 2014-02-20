//
//  DBGroupManager.h
//  Bowling300
//
//  Created by SDT-1 on 2014. 2. 5..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "DB.h"

@interface DBGroupManager : DB
+ (id)sharedModeManager;
- (BOOL)addDataInGroupTableWithGroupIdx:(NSInteger)inIdx withGroupName:(NSString *)inGroupName withGroupRedColor:(NSInteger)inRed withGroupGreenColor:(NSInteger)inGreen withGroupBlueColor:(NSInteger)inBlue;
- (NSMutableArray *)showAllGroups;
- (NSInteger)showRepresentiveGroupIdx;
- (void)setRepresentiveGroupWithGroupIdx:(NSInteger)inGroupIdx;
- (UIColor *)showGroupColorWithGroupIdx:(NSInteger)inGroupIdx;
- (NSMutableArray *)showGroupNameWithGroupsArray:(NSMutableArray *)inGroups;
- (NSMutableArray *)showGroupIdxWithGroupsArray:(NSMutableArray *)inGroups;
- (NSMutableArray *)showGroupColorWithGroupsArray:(NSMutableArray *)inGroups;
- (NSString *)showGroupNameWithGroupIdx:(NSInteger)inGroupIdx;
- (BOOL)deleteGroupDataWithGroupIdx:(NSInteger)inIdx;
@end
