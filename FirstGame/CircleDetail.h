//
//  CircleDetail.h
//  FirstGame
//
//  Created by Prabhu on 21/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface CircleDetail : NSObject

@property(nonatomic) int circlePosition;
@property(nonatomic) int circleID;
@property(nonatomic) int circleSize;
@property(nonatomic) int circleColor;
@property(nonatomic,strong) SKShapeNode *circleSpriteNode;

@end
