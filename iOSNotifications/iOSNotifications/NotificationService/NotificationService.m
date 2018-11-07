//
//  NotificationService.m
//  NotificationService
//
//  Created by WengHengcong on 2017/1/4.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//

#import "NotificationService.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/*
 
 apns payload test demo
 
 {
 "aps": {
    "alert": {
        "title": "斯沃驰2016秋冬系列华丽上市",
        "body": "Swatch推出Magies D'Hiver系列新品！"
    },
    "sound": "default",
    "mutable-content": 1
 },
 "isqImgPath": "https://cdn.pixabay.com/photo/2017/01/06/22/24/giraffe-1959110_1280.jpg",
 "tImgPath": "https://cdn.pixabay.com/photo/2017/01/06/22/24/giraffe-1959110_1280.jpg",
 "title": "斯沃驰2016秋冬系列华丽上市",
 "content": "Swatch推出MagiesD'Hiver系列新品。该系列灵感来源于雪花的结晶构造，技术感十足，配以新潮迷彩色和爱尔兰式粗花呢，宛若置身壁炉旁。"
 }
 
 以上图片若无效，尝试：https://img30.360buyimg.com/EdmPlatform/jfs/t4000/43/1883011713/62578/a8ef6739/589ac88dNdacd97ed.jpg
 
 */


static NSString *notiSmallImageKey = @"isqImgPath";


@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    //the data store by host app, read by notification service extension
    NSUserDefaults *groupDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.bfpushtest"];
    NSString *shared = [groupDefault objectForKey:@"JSSharedData"];
    NSLog(@"shared data: %@", shared);

    if ( (request == nil) || (request.content == nil) || (request.content.userInfo == nil) ) {
        return;
    }
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    //小于10.2的系统，都不会执行该流程
    if ([self systemVersionInteger] < 1020) {
        self.contentHandler(self.bestAttemptContent);
        return;
    }
    
    // Modify the notification content here...
    //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    NSString *urlStr = [self.bestAttemptContent.userInfo objectForKey:notiSmallImageKey];
    
    __weak __typeof__ (self) wself = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __strong __typeof__ (self) sself = wself;
        
        if (sself) {
            if (urlStr) {
                // load the attachment
                [sself loadAttachmentForUrlString:urlStr withType:@"png" completionHandler:^(UNNotificationAttachment *attachment) {
                    if (attachment) {
                        sself.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
                    }
                    //返回给系统执行
                    sself.contentHandler(sself.bestAttemptContent);
                    
                }];
            }else{
                sself.contentHandler(sself.bestAttemptContent);
            }
            
        }
        
    });
    
}


- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}


- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    
    return [@"." stringByAppendingString:ext];
}

- (void)loadAttachmentForUrlString:(NSString *)urlString withType:(NSString *)type
                 completionHandler:(void(^)(UNNotificationAttachment *))completionHandler  {
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlString];
    if (!attachmentURL) {
        return;
    }
    
    NSString *fileExt = [self fileExtensionForMediaType:type];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        //                        [self wirteLogWithString:@"%@", error.localizedDescription);
                    } else {
                        if (temporaryFileLocation) {
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                            if (localURL) {
                                [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                                NSError *attachmentError = nil;
                                //NSMutableDictionary *option = [NSMutableDictionary dictionary];
                                //option[UNNotificationAttachmentOptionsThumbnailClippingRectKey] = (__bridge id _Nullable)((CGRectCreateDictionaryRepresentation(CGRectMake(0.25, 0.25, 0.5, 0.5))));
                                if (localURL) {
                                    attachment = [UNNotificationAttachment attachmentWithIdentifier:notiSmallImageKey URL:localURL options:nil error:&attachmentError];
                                    if (attachmentError) {
                                        //[self wirteLogWithString:@"%@", attachmentError.localizedDescription);
                                    }
                                }
                            }
                            
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionHandler) {
                            completionHandler(attachment);
                        }
                    });
                }]
     resume];
}

/**
 返回系统版本号
 */
- (NSInteger)systemVersionInteger
{
    /*
     iOS 版本号是两位或者三位
     大版本如：8.4，9.2，10.1
     小版本如：8.4.1，9.3.3，10.2.1
     */
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSArray *components = [version componentsSeparatedByString:@"."];
    NSInteger major = 0;
    NSInteger minor = 0;
    NSInteger micro = 0;
    
    if (components.count == 0) {
        major = [version integerValue];
    }else if (components.count == 1){
        major = [version integerValue];
    }if (components.count == 2){
        major = [components[0] integerValue];
        minor = [components[1] integerValue];
    }else if (components.count == 3){
        major = [components[0] integerValue];
        minor = [components[1] integerValue];
        micro = [components[2] integerValue];
    }
    
    NSInteger versionInteger = major * 100 + minor * 10 + micro;
    //    [self wirteLogWithString:@"%ld",(long)versionInteger);
    return versionInteger;
}

@end
