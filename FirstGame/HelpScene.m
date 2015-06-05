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
    //[self multiLine:@"Pair same colour, same size cirlce with in the time frame"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
}

@end
