//
//  CreditsScene.m
//  FirstGame
//
//  Created by iappscrazy on 21/05/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "CreditsScene.h"

@implementation CreditsScene

-(void)didMoveToView:(SKView *)view {
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
}
@end
