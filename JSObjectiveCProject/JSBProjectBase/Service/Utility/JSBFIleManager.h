//
//  JSBFIleManager.h
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/15.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

/**
 *  iOS沙盒知识
 *   1.1、每个应用程序都有自己的存储空间
 *   1.2、应用程序不能翻过自己的围墙去访问别的存储空间的内容
 *   1.3、应用程序请求的数据都要通过权限检测，假如不符合条件的话，不会被放行。
 *   1.4、模拟器沙河路径：/Users/whc/Library/Developer/CoreSimulator/Devices/
 *   ————————————————————————————————————————————————————————————————————————
 *   2.1、App 沙盒目录：timeboy.app\Document\Library\tmp
 *   2.2、Library目录：Application Support\Caches\Preferences
 *   2.3、Doucemnt目录：将应用程序的数据文件保存在该目录下，不过这些数据类型仅限于不可再生的数据，可再生的数据文件应该存放在Library/Cache目录下。不会被iTunes同步；
        ->Documents/Inbox目录：该目录用来保存由外部应用请求当前应用程序打开的文件。会被iTunes同步；
 
 *   2.4、Library目录：建议用来存放默认设置或其它状态信息，除了Caches子目录外会被iTunes同步；
        ->Library/Caches目录：主要是缓存文件，用户使用过程中缓存都可以保存在这个目录中。Documents目录用于保存不可再生的文件，那么这个目录就用于保存那些可再生的文件，比如网络请求的数据。鉴于此，应用程序通常还需要负责删除这些文件。不会被iTunes同步；
        ->Library/Application Support目录：
        ->Library/Preferences目录：应用程序的偏好设置文件。NSUserDefaults写的设置数据都会保存到该目录下的一个plist文件中；
 
 *   2.5、tmp目录：各种临时文件，保存应用再次启动时不需要的文件。而且，当应用不再需要这些文件时应该主动将其删除，因为该目录下的东西随时有可能被系统清理掉，目前已知的一种可能清理的原因是系统磁盘存储空间不足的时候。
 */

#import <Foundation/Foundation.h>

@interface JSBFIleManager : NSObject

#pragma mark - get app default directory

+ (NSString *)sandboxDirectory;

+ (NSString *)documentDirectory;
+ (NSString *)documentInboxDirectory;

+ (NSString *)libraryDirectory;
+ (NSString *)libraryAppSupportDirectory;
+ (NSString *)libraryCachesDirectory;
+ (NSString *)libraryPreferencesDirectory;

+ (NSString *)tmpDirectiory;


@end
