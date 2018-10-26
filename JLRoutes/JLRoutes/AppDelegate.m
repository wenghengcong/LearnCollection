//
//  AppDelegate.m
//  JLRoutes
//
//  Created by 翁恒丛 on 2018/10/24.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#import "AppDelegate.h"
#import "JLRoutes.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[JLRoutes globalRoutes] addRoute:@"/user/view/:userID" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        NSLog(@"parameters: %@", parameters);
        return YES;
    }];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
//    return [[JLRoutes globalRoutes] routeURL:url];
    return [JLRoutes routeURL:url];
}

@end
