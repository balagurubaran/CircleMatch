//
//  HelpScene.m
//  FirstGame
//
//  Created by iappscrazy on 22/05/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "HelpScene.h"

@implementation HelpScene

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
}
@end
