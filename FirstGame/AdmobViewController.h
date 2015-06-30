//
//  AdmobViewController.h
//  SampleProject6
//
//  Created by Balagurubaran on 09/10/2014.
//  Copyright (c) 2014 Iapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AdmobViewController : UIViewController{
    GADBannerView *bannerView_;
    BOOL didCloseWebsiteView_;
    BOOL isLoaded_;
    id currentDelegate_;
    GADInterstitial *interstitial;
}
+(AdmobViewController *)singleton;
-(void)resetAdView:(UIViewController *)rootViewController;
- (void) removeADS;
- (void) LoadInterstitialAds:(UIViewController *)rootViewController;
- (void) reLoadInterstitialAds;
@end
