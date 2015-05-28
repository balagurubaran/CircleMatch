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

-  (void) multiLine:(NSString*)labelText{
    NSCharacterSet *separators = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *words = [labelText componentsSeparatedByCharactersInSet:separators];
    
    int len = [labelText length];
    int width = self.frame.size.width - 50; // specify your own width to fit the device screen
    
    // get the number of labelnode we need.
    int totLines = len/width + 1;
    int cnt = 0; // used to parse through the words array
    
    // here is the for loop that create all the SKLabelNode that we need to
    // display the string.
    
    for (int i=0; i < totLines; i++) {
        int lenPerLine = 0;
        NSString *lineStr = @"";
        
        while (lenPerLine<width) {
            if (cnt>[words count]-1) break; // failsafe - avoid overflow error
            lineStr = [NSString stringWithFormat:@"%@ %@", lineStr, words[cnt]];
            lenPerLine = [lineStr length];
            cnt ++;
            // NSLog(@"%@", lineStr);
        }
        // creation of the SKLabelNode itself
        SKLabelNode *_multiLineLabel = [SKLabelNode labelNodeWithFontNamed:@"Oxygen Light"];
        _multiLineLabel.text = lineStr;
        // name each label node so you can animate it if u wish
        // the rest of the code should be self-explanatory
        _multiLineLabel.name = [NSString stringWithFormat:@"line%d",i];
        _multiLineLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _multiLineLabel.fontSize = 35;
        _multiLineLabel.fontColor = [SKColor blackColor];
        _multiLineLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:_multiLineLabel];
    }
}
@end
