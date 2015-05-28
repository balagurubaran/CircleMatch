//
//  GameCenterClass.h
//  iCopterClassic
//
//  Created by iappscrazy on 16/05/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^staus)(BOOL);

@interface GameCenterClass : NSObject
+(id)gameCenterSharedInstance;

@property(nonatomic,strong) NSString *leaderBoardID;

- (BOOL)checkAuthentication:(staus)gameCenterIsavaialble;
- (void) postScore:(int)score;
- (NSString*) getUserName;
@end
