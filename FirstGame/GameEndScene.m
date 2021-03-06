//
//  GameEndScene.m
//  CircleMatch
//
//  Created by iappscrazy on 13/11/2015.
//  Copyright © 2015 British Airways PLC. All rights reserved.
//

#import "GameEndScene.h"
#import "Constant.h"

@implementation GameEndScene
SKLabelNode *replayNode;
SKLabelNode *gameEndTxtNode;
SKLabelNode *LeaderBoard;
SKLabelNode *newBestNode;
SKLabelNode *scoreNode;
SKLabelNode *menuNode;
SKLabelNode *info;

-(void)didMoveToView:(SKView *)view {
    if(replayNode == NULL){
        
        menuNode = (SKLabelNode*)[self childNodeWithName:@"menu"];
        [menuNode setUserData:[NSMutableDictionary dictionaryWithObject:@"menu" forKey:@"userData"]];
        
        replayNode = (SKLabelNode*)[self childNodeWithName:@"replay"];
        [replayNode setUserData:[NSMutableDictionary dictionaryWithObject:@"replay" forKey:@"userData"]];
        gameEndTxtNode = (SKLabelNode*)[self childNodeWithName:@"gameend"];
        
        LeaderBoard = (SKLabelNode*)[self childNodeWithName:@"leaderboard"];
        [LeaderBoard setUserData:[NSMutableDictionary dictionaryWithObject:@"leaderboard" forKey:@"userData"]];
        
        newBestNode = (SKLabelNode*)[self childNodeWithName:@"newbest"];        
        scoreNode   = (SKLabelNode*)[self childNodeWithName:@"currentscore"];
        info        = (SKLabelNode*)[self childNodeWithName:@"Info"];
        
    }

    newBestNode.text = [NSString stringWithFormat:@"Best Score: %d",bestScore];
    scoreNode.text = [NSString stringWithFormat:@"Score : %d",macthedCircleCount];
    
    info.text = @"Don't give up try hard to beat your own best";
    if(bestScore <= macthedCircleCount){
        info.text = @"Congratulations! New high score";
    } else if(bestScore - 10 < macthedCircleCount){
        info.text = @"OOPS! You are very close to your best score! Don't give up ";
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        SKShapeNode *node = (SKShapeNode*)[self nodeAtPoint:location];
        
        NSDictionary *userDataDic = node.userData;
        NSString *userData = [userDataDic objectForKey:@"userData"];
        
        if([userData isEqualToString:@"menu"]){
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"writeFile" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
            
        }
        if([userData isEqualToString:@"replay"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addGameScene" object:nil];
        }else if([userData isEqualToString:@"leaderboard"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetTheGame" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLeaderBoard" object:nil];
        }
    }
}

@end
