//
//  GameScene.m
//  FirstGame
//
//  Created by Prabhu on 21/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//


#import "GameScene.h"
#import "CircleDetail.h"
#import "Constant.h"
#import "FileHandler.h"
#import "utiliz.h"

NSMutableArray  *allCirlceDetaiArray;
BOOL            isSelectedNode;
CircleDetail    *previouslySelectedNodeCircle;
BOOL            isGameEnded;
NSDate          *firstTouchTime;
NSTimer         *gameStatusCheckTimer;
int             macthedCircleCount;
SKLabelNode     *scoreLabel;
SKLabelNode     *bestScoreLabel;

int             bestScore;

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

BOOL        isTabed;

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
   
    NSString *storedData = [fileHandler readFile:@"settings"];
    
    if ([storedData length] > 0) {
        NSArray  *storedDataAray = [storedData componentsSeparatedByString:@","];
        bestScore = [[storedDataAray objectAtIndex:0] integerValue];
        avgTimeValue = [[storedDataAray objectAtIndex:1] floatValue];
        totalClick = [[storedDataAray objectAtIndex:2] floatValue];
    }else{
        bestScore = 0;
        avgTimeValue = 0.0;
        totalClick = 0;
    }
    
    bestScoreLabel = (SKLabelNode*)[self childNodeWithName:@"bestScore"];
    bestScoreLabel.text = [NSString stringWithFormat:@"%d",bestScore];
    
    backBtn = (SKSpriteNode*)[self childNodeWithName:@"backBtn"];
    backBtn.userData = [NSMutableDictionary dictionaryWithObject:@"backBtn" forKey:@"userData"];
    
    isSelectedNode = NO;
    isGameEnded = NO;
    isTabed = NO;
   
    if(gameMode == BLACK_GREY_Mode)
        maxColor = 2;
    else if(gameMode == RGB_MODE){
        maxColor = 3;
    }else{
        maxColor = 4;
    }
    
    allCirlceDetaiArray = [[NSMutableArray alloc] init];
    gameStatusCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTheTimeInterVal) userInfo:nil repeats:YES];
    
    currentTimeLbl = (SKLabelNode*)[self childNodeWithName:@"currentTimer"];
    avgTimeLbl = (SKLabelNode*)[self childNodeWithName:@"avgTimer"];
    
    avgTimeLbl.text = [NSString stringWithFormat:@"%.1f",avgTimeValue/totalClick];
    [allCirlceDetaiArray removeAllObjects];
    [self resetTheGame];
    
    gameEndBG = (SKShapeNode*)[self childNodeWithName:@"gameendbg"];

    menuNode = (SKLabelNode*)[self childNodeWithName:@"menu"];
    [menuNode setUserData:[NSMutableDictionary dictionaryWithObject:@"menu" forKey:@"userData"]];
    replayNode = (SKLabelNode*)[self childNodeWithName:@"replay"];
     [replayNode setUserData:[NSMutableDictionary dictionaryWithObject:@"replay" forKey:@"userData"]];
    gameEndTxtNode = (SKLabelNode*)[self childNodeWithName:@"gameend"];
    
    [self gameEndScreen:NO];

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
        eachCircle.circleSize = 50;
    }else{
        eachCircle.circleSize = 75;
    }
    int circleColor = arc4random() % maxColor;
    eachCircle.circleColor = circleColor;
}

- (void) updateCircleNodes:(CircleDetail*) eachCircle{
  
    int index = eachCircle.circleID;
    int i = index/6;
    int j = index%6;
   
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
        if(cirDetail.circleColor == PINKCIRCLE)
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:PINKHEX];
        else if(cirDetail.circleColor == GREENONECIRCLE)
            cirDetail.circleSpriteNode.fillColor = [utiliz colorFromHexString:GREENONEHEX];
        else if(cirDetail.circleColor == BLACKONECIRCLE)
            cirDetail.circleSpriteNode.fillColor = [UIColor blackColor];
        else if(cirDetail.circleColor == GRAYONECIRCLE)
            cirDetail.circleSpriteNode.fillColor = [UIColor grayColor];
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
            isSelectedNode = !isSelectedNode;
            if(!isTabed){
                startTime = [NSDate date];
                isTabed = YES;
            }
            
            if(!isSelectedNode){
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
                    avgTimeValue += [endTime timeIntervalSinceDate:startTime];
                    avgTimeLbl.text = [NSString stringWithFormat:@"%.1f",avgTimeValue/totalClick];
                    isGameEnded = YES;
                    isTabed = NO;
                    [self gameEndScreen:YES];
                }
            }
            firstTouchTime = [NSDate date];
            previouslySelectedNodeCircle = selectedNodeCircle;
            
            
            node.strokeColor = [self reverseColorOf:node.fillColor];//[SKColor purpleColor];
            node.lineWidth = 3.0f;
            node.glowWidth = 3.0f;
            node.antialiased = YES;
        }
        else if(![selectedNodeCircle isKindOfClass:[CircleDetail class]]){
            NSDictionary *userDataDic = node.userData;
            NSString *userData = [userDataDic objectForKey:@"userData"];
            if([userData isEqualToString:@"backBtn"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
                [self writeFile];

            }
            if([userData isEqualToString:@"menu"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
                [self writeFile];

            }
            if([userData isEqualToString:@"replay"]){
                isGameEnded = NO;
                [self gameEndScreen:NO];
                [self resetTheGame];
            }

        }
    }
}

- (void) resetTheGame{
    [self writeFile];
    
    isSelectedNode = NO;
    gameStatusCheckTimer.tolerance = 4;
    macthedCircleCount = 0;
    [self generateCircle:YES needToChangeValue:nil];
    scoreLabel.text = [NSString stringWithFormat:@"%d",macthedCircleCount];
    currentTimeLbl.text = @"0.0";

}

- (void) checkTheTimeInterVal{
    NSDate *secondTouchTime = [NSDate date];
    NSTimeInterval differnceBetweenTouch = [secondTouchTime timeIntervalSinceDate:firstTouchTime];
    if(differnceBetweenTouch > 1 && isTabed){
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
 
    if(!status){
        [gameEndBG removeFromParent];
        [menuNode removeFromParent];
        [replayNode removeFromParent];
        [gameEndTxtNode removeFromParent];
    }else if(isGameEnded){
        [self addChild:gameEndBG];
        [self addChild:menuNode];
        [self addChild:replayNode];
        [self addChild:gameEndTxtNode];
    }
}

- (void) writeFile{
    NSString *fileContent = [NSString stringWithFormat:@"%d,%f,%d",bestScore,avgTimeValue,totalClick];
    [fileHandler writeFile:@"settings" fileContent:fileContent];
}

-(UIColor *)reverseColorOf :(UIColor *)oldColor
{
    CGColorRef oldCGColor = oldColor.CGColor;
    
    int numberOfComponents = CGColorGetNumberOfComponents(oldCGColor);
    // can not invert - the only component is the alpha
    if (numberOfComponents == 1) {
        return [UIColor colorWithCGColor:oldCGColor];
    }
    
    const CGFloat *oldComponentColors = CGColorGetComponents(oldCGColor);
    CGFloat newComponentColors[numberOfComponents];
    
    int i = numberOfComponents - 1;
    newComponentColors[i] = oldComponentColors[i]; // alpha
    while (--i >= 0) {
        newComponentColors[i] = 1 - oldComponentColors[i];
    }
    
    CGColorRef newCGColor = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
    UIColor *newColor = [UIColor colorWithCGColor:newCGColor];
    CGColorRelease(newCGColor);
    
    //=====For the GRAY colors 'Middle level colors'
    CGFloat white = 0;
    [oldColor getWhite:&white alpha:nil];
    
    if(white>0.3 && white < 0.67)
    {
        if(white >= 0.5)
            newColor = [UIColor darkGrayColor];
        else if (white < 0.5)
            newColor = [UIColor blackColor];
        
    }
    return newColor;
}

- (void) findCountFromAll{
    
}
@end
