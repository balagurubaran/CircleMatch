//
//  GameViewController.m
//  FirstGame
//
//  Created by Prabhu on 21/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "AdmobViewController.h"

GameScene *scene;
MenuScene *menuScene;
AdmobViewController *adsController;
SKView * skView;

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

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    scene = [GameScene unarchiveFromFile:@"GameScene"];
    
    menuScene = [MenuScene unarchiveFromFile:@"MenuScene"];
    
    menuScene.scaleMode = SKSceneScaleModeFill;
    
    // Present the scene.
    [skView presentScene:menuScene];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addGameScene)
                                                 name:@"addGameScene"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addMenuScene)
                                                 name:@"addMenuScene"
                                               object:nil];
    adsController = [AdmobViewController singleton];
    [adsController resetAdView:self];
    
}

- (void) addGameScene{
    [skView presentScene:scene];
}

- (void) addMenuScene{
    [skView presentScene:menuScene];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
