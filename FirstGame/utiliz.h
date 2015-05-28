//
//  utiliz.h
//  FirstGame
//
//  Created by Administrator on 28/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface utiliz : NSObject

+ (utiliz*) utilizSharedInstance;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)reverseColorOf :(UIColor *)oldColor;
@end
