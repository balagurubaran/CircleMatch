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

#define PINKCIRCLE      0
#define GREENONECIRCLE  1
#define BLACKONECIRCLE  2
#define GRAYONECIRCLE   3


#define PINKHEX     @"#FFD3E0"
#define GREENONEHEX @"#5AD427"

#define GREENHEX    @"#4CD964"
#define BLUEHEX     @"#5856D6"
#define REDHEX      @"#FF3A2D"

#define BLACK_GREY_Mode  0
#define RGB_MODE         1
#define VIBGYOR_MODE     2

int gameMode;
int maxColor;

int     totalClick;
NSTimeInterval   avgTimeValue;
NSTimeInterval   currentTimeValue;

#endif
