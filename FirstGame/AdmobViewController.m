//
//  AdmobViewController.m
//  SampleProject6
//
//  Created by Balagurubaran on 09/10/2014.
//  Copyright (c) 2014 Iapps. All rights reserved.
//

#import "AdmobViewController.h"
#define ADSID @"a15342a12ca609b"
#define ISTESTADS 0

//BOOL const isSimulator = NO;

#ifdef TARGET_IPHONE_SIMULATOR
    BOOL isSimulator = YES;
#else
    BOOL isSimulator = NO;
#endif

@interface AdmobViewController ()

@end

@implementation AdmobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(AdmobViewController *)singleton {
    static dispatch_once_t pred;
    static AdmobViewController *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[AdmobViewController alloc] init];
    });
    return shared;
}

-(id)init {
    if (self = [super init]) {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
        }
        else{
            bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        }
        bannerView_.adUnitID = ADSID;
        isLoaded_ = YES;
    }
    return self;
}

-(void)resetAdView:(UIViewController *)rootViewController {
    return;
    // Always keep track of currentDelegate for notification forwarding
    currentDelegate_ = rootViewController;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        bannerView_.frame = CGRectMake((rootViewController.view.frame.size.width-bannerView_.frame.size.width)/2, rootViewController.view.frame.size.height-bannerView_.frame.size.height, bannerView_.frame.size.width, bannerView_.frame.size.height);
    }
    else{
        int x = (rootViewController.view.frame.size.width-bannerView_.frame.size.width)/2;
        if(self.view.frame.size.width == 468){
            x = 0;
        }
        bannerView_.frame = CGRectMake(x, rootViewController.view.frame.size.height-bannerView_.frame.size.height, bannerView_.frame.size.width, bannerView_.frame.size.height);
    }
    bannerView_.rootViewController = rootViewController;
    [rootViewController.view addSubview:bannerView_];
    if(isLoaded_){
        GADRequest *request = [GADRequest request];
        //if(isSimulator)
          //  request.testDevices = @[ @"a63718f0e45e515b7b906817e2142b92" ];
       // request.testDevices = @[ @"5bdeb2cb81dca47e93b2c567434d7f1b" ];
        
        [bannerView_ loadRequest:request];
        isLoaded_ = NO;
    }
}

- (void) removeADS{
    [bannerView_ removeFromSuperview ];
}

@end
