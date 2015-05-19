//
//  FileHandler.m
//  FirstGame
//
//  Created by Administrator on 28/04/2015.
//  Copyright (c) 2015 British Airways PLC. All rights reserved.
//

#import "FileHandler.h"

@implementation FileHandler
NSString *documentsDirectoryPath;

+ (FileHandler*) fileHandlerSharedInstance   {
    static FileHandler *fileHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileHandler = [[self alloc] init];
    });
    
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectoryPath = [directoryPaths objectAtIndex:0];
    
    
    return fileHandler;
}

- (void) writeFile:(NSString*)fileName fileContent:(NSString*)fileContent{
     NSError *error;
    //NSData *fileData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
   // [fileData writeToFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"] atomically:YES];
    [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

- (NSString*)readFile:(NSString*)fileName{
    NSError *error;
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:
                            &error];
    return fileContent;
}

@end
