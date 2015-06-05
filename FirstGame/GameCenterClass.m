//
//  GameCenterClass.m
//  iCopterClassic
//
//  Created by iappscrazy on 16/05/2015.
//  Copyright (c) 2015 iappscrazy. All rights reserved.
//

#import "GameCenterClass.h"


@import GameKit;

BOOL isAuthetication;
GameCenterClass *gameCenterSharedInstance;


@implementation GameCenterClass


+ (id) gameCenterSharedInstance{
    if (!gameCenterSharedInstance) {
        gameCenterSharedInstance = [[self alloc] init];
    }
    // returns the same object each time
    return gameCenterSharedInstance;
}

- (BOOL)checkAuthentication:(staus)gameCenterIsavaialble{
    
    /*[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error){
        if (error == nil) {
            isAuthetication = YES;
        }
        else{
            isAuthetication = NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Center Disabled"message:@"For Game Center make sure you have an account and you have a proper device connection."delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [alert show];
        }
    }];*/
    
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (error == nil) {
            isAuthetication = YES;
            gameCenterIsavaialble(isAuthetication);
        }
        else{
            isAuthetication = NO;
            gameCenterIsavaialble(isAuthetication);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Center Disabled"message:@"For Game Center make sure you have an account and you have a proper device connection."delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
            [alert show];
        }
    };
    return isAuthetication;
}

- (void) postScore:(int)score{
    if(isAuthetication){
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderBoardID];
         scoreReporter.shouldSetDefaultLeaderboard = YES;
        scoreReporter.value = score;
        scoreReporter.context = 0;
        
        NSArray *scores = @[scoreReporter];
        [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
            //Do something interesting here.
        }];
    }
}

- (NSString*) getUserName{
    NSString *userName;
    if (isAuthetication) {
        GKLocalPlayer *lp = [GKLocalPlayer localPlayer];

        userName = lp.alias;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Center Disabled"message:@"For Game Center make sure you have an account and you have a proper device connection."delegate:self cancelButtonTitle:@"Ok"otherButtonTitles:nil];
        [alert show];
    }
    return userName;
}
@end
