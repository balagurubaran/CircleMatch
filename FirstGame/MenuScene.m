//
//  MenuScene.m
//  FirstGame
//
//  Created by Administrator on 13/05/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "MenuScene.h"
#import "Constant.h"



SKSpriteNode *blackMode;
SKSpriteNode *RGBMode;
SKSpriteNode *vibgyorMode;

@implementation MenuScene

-(void)didMoveToView:(SKView *)view {
    blackMode = (SKSpriteNode*)[self childNodeWithName:@"black"];
    blackMode.userData = [NSMutableDictionary dictionaryWithObject:@"blackmode" forKey:@"userData"];
    
    RGBMode = (SKSpriteNode*)[self childNodeWithName:@"rgb"];
    RGBMode.userData = [NSMutableDictionary dictionaryWithObject:@"RGBMode" forKey:@"userData"];
    
    vibgyorMode = (SKSpriteNode*)[self childNodeWithName:@"vibgyor"];
    vibgyorMode.userData = [NSMutableDictionary dictionaryWithObject:@"VIBGYORMode" forKey:@"userData"];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKShapeNode *node = (SKShapeNode*)[self nodeAtPoint:location];
        NSDictionary *userDataDic = node.userData;
        
        NSString *userData = [userDataDic objectForKey:@"userData"];
        if([userData isEqualToString:@"blackmode"]){
            gameMode = BLACK_GREY_Mode;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addGameScene" object:nil];
        }if([userData isEqualToString:@"RGBMode"]){
            gameMode = RGB_MODE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addGameScene" object:nil];
        }if([userData isEqualToString:@"VIBGYORMode"]){
            gameMode = VIBGYOR_MODE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addGameScene" object:nil];
        }
 
    }
}

@end
