//
//  FileHandler.h
//  FirstGame
//
//  Created by Administrator on 28/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHandler : NSObject

+ (FileHandler*) fileHandlerSharedInstance;
- (void) writeFile:(NSString*)fileName fileContent:(NSString*)fileContent;
- (NSString*)readFile:(NSString*)fileName;
@end
