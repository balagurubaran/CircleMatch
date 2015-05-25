//
//  HelpScene.m
//  FirstGame
//
//  Created by iappscrazy on 22/05/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "HelpScene.h"
#import "Constant.h"

@implementation HelpScene

-(void)didMoveToView:(SKView *)view {
    SKLabelNode *helpTextNode = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue "];
    helpTextNode.text = @"Pair same colour, same size cirlce with in the time frame";
    helpTextNode.fontSize = 40;
    helpTextNode.fontColor = [SKColor blackColor];
    helpTextNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:helpTextNode];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
}
@end
