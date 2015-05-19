//
//  utiliz.m
//  FirstGame
//
//  Created by Administrator on 28/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "utiliz.h"

@implementation utiliz


+ (utiliz*) utilizSharedInstance{
    static utiliz *utility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utility = [[self alloc] init];
    });
    return utility;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
