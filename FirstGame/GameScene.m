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

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
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
    }else{
        bestScore = 0;
        avgTimeValue = 0.0;
    }
    
    bestScoreLabel = (SKLabelNode*)[self childNodeWithName:@"bestScore"];
    bestScoreLabel.text = [NSString stringWithFormat:@"%d",bestScore];
    
    backBtn = (SKSpriteNode*)[self childNodeWithName:@"backBtn"];
    backBtn.userData = [NSMutableDictionary dictionaryWithObject:@"backBtn" forKey:@"userData"];
    
    isSelectedNode = NO;
    isGameEnded = YES;
    
   
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
    
    avgTimeLbl.text = [NSString stringWithFormat:@"%.1f",avgTimeValue];
    
    [self resetTheGame];

}

- (void) generateCircle:(BOOL)initalLoad needToChangeValue:(NSArray*) circleIndex{

    if(initalLoad){
        //[allCirlceDetaiArray removeAllObjects];
        
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
   // cirDetail.circleSpriteNode = [SKShapeNode shapeNodeWithCircleOfRadius:cirDetail.circleSize/2];
    //cirDetail.circleSpriteNode.position = CGPointMake(circlePosition_size.origin.x, circlePosition_size.origin.y);
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
        
        if([selectedNodeCircle isKindOfClass:[CircleDetail class]]){
            isSelectedNode = !isSelectedNode;
            if(isGameEnded){
                startTime = [NSDate date];
            }
            
            isGameEnded = NO;
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
                    [self resetTheGame];
                }
            }
            firstTouchTime = [NSDate date];
            previouslySelectedNodeCircle = selectedNodeCircle;
            
            
            node.strokeColor = [SKColor grayColor];
            node.lineWidth = 3.0f;
            node.glowWidth = 3.0f;
            node.antialiased = YES;
        }
        else{
            NSDictionary *userDataDic = node.userData;
            NSString *userData = [userDataDic objectForKey:@"userData"];
            if([userData isEqualToString:@"backBtn"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addMenuScene" object:nil];
            }
        }
    }
}

- (void) resetTheGame{
    
   /* 
    gameMode = (arc4random() % 100) % 2;
    if(gameMode == BLACK_GREY_Mode)
        maxColor = 2;
    else if(gameMode == RGB_MODE){
        maxColor = 3;
    }else{
        maxColor = 4;
    }
    */
    
    if(bestScore <= macthedCircleCount){
        NSString *fileContent = [NSString stringWithFormat:@"%d,%f",bestScore,avgTimeValue];
        [fileHandler writeFile:@"settings" fileContent:fileContent];
    }
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
    if(differnceBetweenTouch > 2 && !isGameEnded){
        isGameEnded = YES;
        avgTimeValue += [endTime timeIntervalSinceDate:startTime]/totalClick;
        avgTimeLbl.text = [NSString stringWithFormat:@"%.1f",avgTimeValue
                           ];
        
       [self resetTheGame];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(!isGameEnded){
        endTime = [NSDate date];
        currentTimeValue  = [endTime timeIntervalSinceDate:startTime];
        currentTimeLbl.text = [NSString stringWithFormat:@"%.1f",currentTimeValue];
        
    }
    
    
}

- (void) findCountFromAll{
    
}
@end
