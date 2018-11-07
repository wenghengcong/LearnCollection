//
//  JSNotificationContent.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSNotificationContent.h"

@implementation JSNotificationContent

- (id)copyWithZone:(NSZone *)zone {
    
    JSNotificationContent *content = [JSNotificationContent new];
    content.title = self.title;
    content.subtitle = self.subtitle;
    content.body = self.body;
    content.badge = self.badge;
    content.action = self.action;
    content.categoryIdentifier = self.categoryIdentifier;
    content.userInfo = self.userInfo;
    content.sound = self.sound;
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    content.attachments = self.attachments;
    content.threadIdentifier = self.threadIdentifier;
    content.launchImageName = self.launchImageName;
#endif
    return content;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
    self.body = [aDecoder decodeObjectForKey:@"body"];
    self.badge = [aDecoder decodeObjectForKey:@"badge"];
    self.action = [aDecoder decodeObjectForKey:@"action"];
    self.categoryIdentifier = [aDecoder decodeObjectForKey:@"categoryIdentifier"];
    self.userInfo = [aDecoder decodeObjectForKey:@"userInfo"];
    self.sound = [aDecoder decodeObjectForKey:@"sound"];
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    self.attachments = [aDecoder decodeObjectForKey:@"attachments"];
    self.threadIdentifier = [aDecoder decodeObjectForKey:@"threadIdentifier"];
    self.launchImageName = [aDecoder decodeObjectForKey:@"launchImageName"];
#endif
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.subtitle forKey:@"subtitle"];
    [aCoder encodeObject:self.body forKey:@"body"];
    [aCoder encodeObject:self.badge forKey:@"badge"];
    [aCoder encodeObject:self.categoryIdentifier forKey:@"categoryIdentifier"];
    [aCoder encodeObject:self.userInfo forKey:@"userInfo"];
    [aCoder encodeObject:self.action forKey:@"action"];
    [aCoder encodeObject:self.sound forKey:@"sound"];
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    [aCoder encodeObject:self.attachments forKey:@"attachments"];
    [aCoder encodeObject:self.threadIdentifier forKey:@"threadIdentifier"];
    [aCoder encodeObject:self.launchImageName forKey:@"launchImageName"];
#endif

}

@end
