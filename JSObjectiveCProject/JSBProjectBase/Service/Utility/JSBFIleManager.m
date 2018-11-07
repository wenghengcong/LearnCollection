//
//  JSBFIleManager.m
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/15.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBFIleManager.h"

@implementation JSBFIleManager

#pragma mark - get app default directory

+ (NSString *)sandboxDirectory {
    NSString *homeDirectory = NSHomeDirectory();
    NSLog(@"home path:%@", homeDirectory);
    return homeDirectory;
}

+ (NSString *)documentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"document path:%@", path);
    return path;
}

+ (NSString *)documentInboxDirectory {
    return nil;
}

+ (NSString *)libraryDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"library path:%@", path);
    return path;
}

+ (NSString *)libraryAppSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"document application support path:%@", path);
    return nil;
}

+ (NSString *)libraryCachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"library caches path:%@", path);
    return path;
}

+ (NSString *)libraryPreferencesDirectory {
    return nil;
}

+ (NSString *)tmpDirectiory {
    NSString *tmpDir = NSTemporaryDirectory();
    NSLog(@"tmp path:%@", tmpDir);
    return tmpDir;
}


@end
