//
//  GameScene.m
//  FirstGame
//
//  Created by Balagurubaran on 21/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//


#import "GameScene.h"
#import "CircleDetail.h"
#import "Constant.h"
#import "FileHandler.h"
#import "utiliz.h"
#import "GameCenterClass.h"

#import <Foundation/Foundation.h>

@import AVFoundation;

NSMutableArray  *allCirlceDetaiArray;
BOOL            isSelectedNode;
CircleDetail    *previouslySelectedNodeCircle;
BOOL            isGameEnded;
NSDate          *firstTouchTime;
NSTimer         *gameStatusCheckTimer;
int             macthedCircleCount;
SKLabelNode     *scoreLabel;
SKLabelNode     *bestScoreLabel;

SKShapeNode     *selectedIdentifyNode;


FileHandler     *fileHandler;
utiliz          *utility;

SKSpriteNode    *backBtn;

NSDate          *startTime;
NSDate          *endTime;

SKLabelNode     *currentTimeLbl;
SKLabelNode     *avgTimeLbl;

int             totalCirlce;
SKShapeNode *gameEndBG;
SKLabelNode *menuNode;
SKLabelNode *replayNode;
SKLabelNode *gameEndTxtNode;
SKLabelNode *LeaderBoard;

BOOL        isTabed;

AVAudioPlayer *clickPlayer;
AVAudioPlayer *wrongClickPlayer;
GameCenterClass *GCenter;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    
    for(CircleDetail *node in allCirlceDetaiArray){
        [node.circleSpriteNode removeFromParent];
    }
    
    totalCirlce = 36;
    
    fileHandler = [FileHandler fileHandlerSharedInstance];
    utility = [utiliz utilizSharedInstance];
    /* Setup your scene here */
    scoreLabel = (SKLabelNode*)[self childNodeWithName:@"score"];
   
    
    
    bestScoreLabel = (SKLabelNode*)[self childNodeWithName:@"bestScore"];
    bestScoreLabel.text = [NSString stringWithFormat:@"%d",bestScore];
    
    backBtn = (SKSpriteNode*)[self childNodeWithName:@"backBtn"];
    backBtn.userData = [NSMutableDictionary dictionaryWithObject:@"backBtn" forKey:@"userData"];
    
    isSelectedNode = NO;
    isGameEnded = NO;
    isTabed = NO;
   
    if(gameMode == BLACK_GREY_Mode){
        maxColor = 2;
    }else if(gameMode == RGB_MODE){
        maxColor = 3;
    }else{
        maxColor = 7;
    }
    
    allCirlceDetaiArray = [[NSMutableArray alloc] init];
    gameStatusCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(checkTheTimeInterVal) userInfo:nil repeats:YES];
    
    currentTimeLbl = (SKLabelNode*)[self childNodeWithName:@"currentTimer"];
    avgTimeLbl = (SKLabelNode*)[self childNodeWithName:@"avgTimer"];
    
    avgTimeLbl.text = [NSString stringWithFormat:@"%.1f",avgTimeValue/totalClick];
    [allCirlceDetaiArray removeAllObjects];
    
    
    gameEndBG = (SKShapeNode*)[self childNodeWithName:@"gameendbg"];

    menuNode = (SKLabelNode*)[self childNodeWithName:@"menu"];
    [menuNode setUserData:[NSMutableDictionary dictionaryWithObject:@"menu" forKey:@"userData"]];
    replayNode = (SKLabelNode*)[self childNodeWithName:@"replay"];
    [replayNode setUserData:[NSMutableDictionary dictionaryWithObject:@"replay" forKey:@"userData"]];
    gameEndTxtNode = (SKLabelNode*)[self childNodeWithName:@"gameend"];
    
    LeaderBoard = (SKLabelNode*)[self childNodeWithName:@"leaderboard"];
    [LeaderBoard setUserData:[NSMutableDictionary dictionaryWithObject:@"leaderboard" forKey:@"userData"]];
    
    selectedIdentifyNode = [SKShapeNode shapeNodeWithCircleOfRadius:20];
    selectedIdentifyNode.fillColor = [UIColor blackColor];
    //[self addChild:selectedIdentifyNode];
    
    [self resetTheGame];
    [self gameEndScreen:NO];
    
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"click" withExtension:@"mp3"];
    clickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    [clickPlayer prepareToPlay];
   
    musicURL = [[NSBundle mainBundle] URLForResource:@"wrong" withExtension:@"wav"];
    wrongClickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    [wrongClickPlayer prepareToPlay];
    
     GCenter = [GameCenterClass gameCenterSharedInstance];
}

- (void) generateCircle:(BOOL)initalLoad needToChangeValue:(NSArray*) circleIndex{

    if(initalLoad){
        for(int i = 0;i < totalCirlce ; i++){
            CircleDetail *eachCircle;
            if([allCirlceDetaiArray count] <= totalCirlce-1)
                 eachCircle = [[CircleDetail alloc] init];
            else{
                eachCircle = allCirlceDetaiArray[i];
            }
            [self randomCircle:eachCircle];
            eachCircle.circleID = i;
            [allCirlceDetaiArray addObject:eachCircle];
            [self updateCircleNodes:eachCircle];
        }
        
    }else{
        for(int i = 0 ; i < [circleIndex count];i++){
            CircleDetail *eachCircle = allCirlceDetaiArray[[[circleIndex objectAtIndex:i] integerValue]];
            [self randomCircle:eachCircle];
            
           // [allCirlceDetaiArray replaceObjectAtIndex:[[circleIndex objectAtIndex:i] integerValue] withObject:eachCircle];
            [self updateCircleNodes:eachCircle];
        }
    }
}

- (void) randomCircle:(CircleDetail*)eachCircle{
    
    if((arc4random() % 2) == 0){
        eachCircle.circleSize = 70
        ;
    }else{
        eachCircle.circleSize = 85;
    }
    int circleColor = arc4random() % maxColor;
    eachCircle.circleColor = circleColor;
}

- (void) updateCircleNodes:(CircleDetail*) eachCircle{
  
    int index = eachCircle.circleID;
    int sqrt = sqrtl(totalCirlce);
    int i = index/sqrt;
    int j = index%sqrt;
   
    CGPoint cirlcePosition = CGPointMake((i * 120) + 95, (j * 120 + 210));
    CGRect circleRect = CGRectMake(cirlcePosition.x - eachCircle.circleSize/2, cirlcePosition.y - eachCircle.circleSize/2, eachCircle.circleSize, eachCircle.circleSize);
    
    [self createCircle:circleRect circleDetail:eachCircle];
    NSMutableDictionary *eachNodeUserData = [[NSMutableDictionary alloc] init];
    [eachNodeUserData setValue:eachCircle forKey:@"userData"];
    eachCircle.circleSpriteNode.userData = eachNodeUserData;
    
    [self addChild:eachCircle.circleSpriteNode];
    // [self shake:1000 node:shapeSprite];
}

- (void) createCircle:(CGRect)circlePosition_size circleDetail:(CircleDetail*)cirDetail{
    
    [cirDetail.circleSpriteNode removeFromParent];
    cirDetail.circleSpriteNode = [SKShapeNode node];
    cirDetail.circleSpriteNode.path = [UIBezierPath bezierPathWithOvalInRect:circlePosition_size].CGPath;
    
    if(gameMode == BLACK_GREY_Mode){
        if(cirDetail.circleColor == GRAYCIRCLE)
            cirDetail.circleSpriteNode.fillColor = [UIColor grayColor];
        else if(cirDetail.circleColor == BLACKCIRCLE)
            cirDetail.circleSpriteNode.fillColor = [UIColor blackColor];
    }else if(gameMode == RGB_MODE){
        if(cirDetail.circleColor == GREENCIRCLE){
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:GREENHEX];
        }
        else if(cirDetail.circleColor == REDCIRCLE){
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:REDHEX];
        }
        else if(cirDetail.circleColor == BLUECIRCLE){
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:BLUEHEX];
        }
    }else{
        if(cirDetail.circleColor == GREENCIRCLE){
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:GREENHEX];
        }
        else if(cirDetail.circleColor == REDCIRCLE){
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:REDHEX];
        }
        else if(cirDetail.circleColor == BLUECIRCLE){
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:BLUEHEX];
        }
        
        if(cirDetail.circleColor == ORANGECIRCLE)
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:ORANGEHEX];
        else if(cirDetail.circleColor == YELLOWCIRCLE)
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:YELLOWHEX];
        else if(cirDetail.circleColor == INDIGOCIRCLE)
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:INDIGOHEX];
        else if(cirDetail.circleColor == VIOLETCIRCLE)
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:VIOLETHEX];
    }
   // cirDetail.circleSpriteNode.glowWidth = 1;
    
}

- (void) shake:(NSInteger)times node:(SKNode*)circleNode{
    CGPoint initialPosition = circleNode.position;
    NSInteger amplitudeX = 10;
    NSInteger amplitudeY = 1;
    NSMutableArray *randomActions = [NSMutableArray array];
    for(int i = 0 ; i <= times;i++){
        NSInteger randX = circleNode.position.x + arc4random() % amplitudeX - amplitudeX/2;
        NSInteger randY = circleNode.position.y + arc4random() % amplitudeY - amplitudeY/2;
        SKAction *action = [SKAction  moveTo:CGPointMake(randX, randY) duration:.4];
        
        [randomActions addObject:action];
    }
    SKAction *rep = [SKAction sequence:randomActions];
    [circleNode runAction:rep completion:^{
        circleNode.position = initialPosition;
    
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        SKShapeNode *node = (SKShapeNode*)[self nodeAtPoint:location];
        
        CircleDetail *selectedNodeCircle = [node.userData objectForKey:@"userData"];
        
        if([selectedNodeCircle isKindOfClass:[CircleDetail class]] && !isGameEnded){
            [clickPlayer play];
            isSelectedNode = !isSelectedNode;
            if(!isTabed){
                startTime = [NSDate date];
                isTabed = YES;
            }
            
            if(!isSelectedNode){
               // selectedIdentifyNode.hidden = YES;
                [selectedIdentifyNode removeFromParent];
                totalClick++;
                if(selectedNodeCircle.circleID !=  previouslySelectedNodeCircle.circleID && selectedNodeCircle.circleColor ==  previouslySelectedNodeCircle.circleColor && selectedNodeCircle.circleSize ==  previouslySelectedNodeCircle.circleSize){
                    macthedCircleCount++;
                    [self generateCircle:NO needToChangeValue:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",previouslySelectedNodeCircle.circleID] ,[NSString stringWithFormat:@"%d",selectedNodeCircle.circleID], nil]];
                    scoreLabel.text = [NSString stringWithFormat:@"%d",macthedCircleCount];
                    if(macthedCircleCount > bestScore){
                        bestScore = macthedCircleCount;
                        bestScoreLabel.text = [NSString stringWithFormat:@"%d",bestScore];
                    }
                }else{
                    [wrongClickPlayer play];
                    avgTimeValue += [endTime timeIntervalSinceDate:startTime];
                    avgTimeLbl.text = [NSString stringWithFormat:@"%.1f",avgTimeValue/totalClick];
                    isGameEnded = YES;
                    isTabed = NO;
                    [self gameEndScreen:YES];
                }
                
            }else{
                [self addChild:selectedIdentifyNode];
                int index = selectedNodeCircle.circleID;
                int sqrt = sqrtl(totalCirlce);
                int i = index/sqrt;
                int j = index%sqrt;
                
                CGPoint cirlcePosition = CGPointMake((i * 120) + 95, (j * 120 + 210));
                
                selectedIdentifyNode.position = cirlcePosition;
            }
            
            firstTouchTime = [NSDate date];
            previouslySelectedNodeCircle = selectedNodeCircle;
            
           
            /*node.strokeColor = [self reverseColorOf:node.fillColor];//[SKColor purpleColor];
            node.lineWidth = 3.0f;
            node.glowWidth = 3.0f;
            node.antialiased = YES;
             */
        }
        else if(![selectedNodeCircle isKindOfClass:[CircleDetail class]]){
            NSDictionary *userDataDic = node.userData;
            NSString *userData = [userDataDic objectForKey:@"userData"];
            if([userData isEqualToString:@"backBtn"]){
                                [self writeFile];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];

            }
            if([userData isEqualToString:@"menu"]){
                [self writeFile];
                [self resetTheGame];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];

            }
            if([userData isEqualToString:@"replay"]){
                isGameEnded = NO;
                [self gameEndScreen:NO];
                [self resetTheGame];
            }else if([userData isEqualToString:@"leaderboard"]){
                [self resetTheGame];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLeaderBoard" object:nil];
            }

        }
    }
}

- (void) resetTheGame{
    
    if(gameMode == BLACK_GREY_Mode){
        blackAndGreyPlayCount++;
    }else if(gameMode == RGB_MODE){
        RGBPlayCount++;
    }
    
    [self writeFile];
    if(macthedCircleCount >= bestScore){
        [GCenter postScore:bestScore];
    }
    
    isSelectedNode = NO;
    gameStatusCheckTimer.tolerance = 4;
    macthedCircleCount = 0;
    [self generateCircle:YES needToChangeValue:nil];
    scoreLabel.text = [NSString stringWithFormat:@"%d",macthedCircleCount];
    currentTimeLbl.text = @"0.0";
    [selectedIdentifyNode removeFromParent];
    
   }

- (void) checkTheTimeInterVal{
    NSDate *secondTouchTime = [NSDate date];
    NSTimeInterval differnceBetweenTouch = [secondTouchTime timeIntervalSinceDate:firstTouchTime];
    if(differnceBetweenTouch > .9 && isTabed){
        avgTimeValue += [endTime timeIntervalSinceDate:startTime];
        avgTimeLbl.text = [NSString stringWithFormat:@"%.1f",avgTimeValue/totalClick];
        isTabed = NO;
        isGameEnded = YES;
       [self gameEndScreen:YES];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(isTabed){
        endTime = [NSDate date];
        currentTimeValue  = [endTime timeIntervalSinceDate:startTime];
        currentTimeLbl.text = [NSString stringWithFormat:@"%.1f",currentTimeValue];
        
    }
}

- (void) gameEndScreen:(BOOL)status{
    gameEndBG.zPosition = status?1:-10;
    menuNode.zPosition = status?1:-10;
    replayNode.zPosition = status?1:-10;
    gameEndTxtNode.zPosition = status?1:-10;
    LeaderBoard.zPosition = status?1:-10;
    
    gameEndBG.hidden = !status;
    menuNode.hidden  = !status;
    replayNode.hidden = !status;
    gameEndTxtNode.hidden = !status;
    LeaderBoard.hidden = !status;
}

- (void) writeFile{
    NSString *fileContent = [NSString stringWithFormat:@"%d,%f,%d,%d,%d",bestScore,avgTimeValue,totalClick,blackAndGreyPlayCount,RGBPlayCount];
    [fileHandler writeFile:@"settings" fileContent:fileContent];
}


- (void) findCountFromAll{
    
}
@end
