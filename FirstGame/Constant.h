//
//  Constant.h
//  FirstGame
//
//  Created by Administrator on 24/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#ifndef FirstGame_Constant_h
#define FirstGame_Constant_h

#define BLACKCIRCLE 0
#define GRAYCIRCLE  1

#define REDCIRCLE   0
#define GREENCIRCLE 1
#define BLUECIRCLE  2

#define ORANGECIRCLE    3
#define YELLOWCIRCLE    4
#define INDIGOCIRCLE    5
#define VIOLETCIRCLE    6

#define RGBMAXPLAY      50
#define BLACKMAXPLAY    50


#define ORANGEHEX     @"#FF8F62"
#define YELLOWHEX     @"#FDFC73"
#define INDIGOHEX     @"#CB76FE"
#define VIOLETHEX     @"#8B35CB"

#define GREENHEX    @"#7BC86F"
#define BLUEHEX     @"#45A2E0"
#define REDHEX      @"#DB6D62"

#define BLACK_GREY_Mode  0
#define RGB_MODE         1
#define VIBGYOR_MODE     2

int gameMode;
int maxColor;

int
bestScore;
int         blackAndGreyPlayCount;
int         RGBPlayCount;


int     totalClick;
NSTimeInterval   avgTimeValue;
NSTimeInterval   currentTimeValue;

#endif
