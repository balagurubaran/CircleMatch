//
//  HelpScene.m
//  FirstGame
//
//  Created by iappscrazy on 22/05/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "HelpScene.h"
#import "Constant.h"
SKSpriteNode *bgNode;
@implementation HelpScene

-(void)didMoveToView:(SKView *)view {
    //[self multiLine:@"Pair same colour, same size cirlce with in the time frame"];
    
  /*  SKLabelNode *nextNode = (SKLabelNode*)[self childNodeWithName:@"next"];
     nextNode.userData = [NSMutableDictionary dictionaryWithObject:@"next" forKey:@"userData"];
    
    SKLabelNode *backNode = (SKLabelNode*)[self childNodeWithName:@"back"];
    backNode.userData = [NSMutableDictionary dictionaryWithObject:@"back" forKey:@"userData"];
    
    bgNode = (SKSpriteNode*)[self childNodeWithName:@"bgNode"];
    bgNode.userData = [NSMutableDictionary dictionaryWithObject:@"bgNode" forKey:@"userData"];
    
    nextNode.hidden = YES;
    backNode.hidden = YES;
   */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
}

@end
