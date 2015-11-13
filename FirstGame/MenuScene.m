//
//  MenuScene.m
//  FirstGame
//
//  Created by Administrator on 13/05/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "MenuScene.h"
#import "Constant.h"
#import "FileHandler.h"
#import "CreditsScene.h"
#import "HelpScene.h"

SKSpriteNode *blackMode;
SKSpriteNode *RGBMode;
SKSpriteNode *vibgyorMode;
SKSpriteNode *creditsScene;
SKTransition *transition;
NSString *storedData;
FileHandler *fileHandler;
CreditsScene *CS;
HelpScene *help;
@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation MenuScene

-(void)didMoveToView:(SKView *)view {
    if(blackMode == NULL){
        blackMode = (SKSpriteNode*)[self childNodeWithName:@"black"];
        blackMode.userData = [NSMutableDictionary dictionaryWithObject:@"blackmode" forKey:@"userData"];
        
        RGBMode = (SKSpriteNode*)[self childNodeWithName:@"rgb"];
        RGBMode.userData = [NSMutableDictionary dictionaryWithObject:@"RGBMode" forKey:@"userData"];
        
        vibgyorMode = (SKSpriteNode*)[self childNodeWithName:@"vibgyor"];
        vibgyorMode.userData = [NSMutableDictionary dictionaryWithObject:@"VIBGYORMode" forKey:@"userData"];
        
        creditsScene = (SKSpriteNode*)[self childNodeWithName:@"credits"];
        creditsScene.userData = [NSMutableDictionary dictionaryWithObject:@"credits" forKey:@"userData"];
        
        SKSpriteNode *helpScene = (SKSpriteNode*)[self childNodeWithName:@"help"];
        helpScene.userData = [NSMutableDictionary dictionaryWithObject:@"help" forKey:@"userData"];
        
        SKSpriteNode *leadeBoardScene = (SKSpriteNode*)[self childNodeWithName:@"leaderboard"];
        leadeBoardScene.userData = [NSMutableDictionary dictionaryWithObject:@"leaderboard" forKey:@"userData"];
        
        fileHandler = [FileHandler fileHandlerSharedInstance];
        
        
        transition = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.5];
        
        CS = [CreditsScene unarchiveFromFile:@"CreditScene"];
        CS.scaleMode = SKSceneScaleModeFill;
        
        help = [HelpScene unarchiveFromFile:@"HelpScene"];
        help.scaleMode = SKSceneScaleModeFill;
    }
    storedData = [fileHandler readFile:@"settings"];
    if ([storedData length] > 0) {
        NSArray  *storedDataAray = [storedData componentsSeparatedByString:@","];
        bestScore = [[storedDataAray objectAtIndex:0] intValue];
        avgTimeValue = [[storedDataAray objectAtIndex:1] floatValue];
        totalClick = [[storedDataAray objectAtIndex:2] floatValue];
        blackAndGreyPlayCount = [[storedDataAray objectAtIndex:3] intValue];
        RGBPlayCount = [[storedDataAray objectAtIndex:4] intValue];
    }else{
        blackAndGreyPlayCount = 0;
        RGBPlayCount = 0;
        bestScore = 0;
        avgTimeValue = 0.0;
        totalClick = 0;
    }
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
        }else if([userData isEqualToString:@"RGBMode"]){
            if(blackAndGreyPlayCount > BLACKMAXPLAY){
                gameMode = RGB_MODE;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addGameScene" object:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"Play %d times Black & Grey mode to unlock the RGB Game mode",BLACKMAXPLAY-blackAndGreyPlayCount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else if([userData isEqualToString:@"VIBGYORMode"]){
            if(RGBPlayCount > RGBMAXPLAY){
                gameMode = VIBGYOR_MODE;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addGameScene" object:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"Play %d times RGB mode to unlock the VIBGYOR Game mode",RGBMAXPLAY-RGBPlayCount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else if([userData isEqualToString:@"credits"]){
            [self.view presentScene:CS transition:transition];
        }else if([userData isEqualToString:@"help"]){
            [self.view presentScene:help transition:transition];
        }else if([userData isEqualToString:@"leaderboard"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLeaderBoard" object:nil];
        }
        
    }
}

@end
