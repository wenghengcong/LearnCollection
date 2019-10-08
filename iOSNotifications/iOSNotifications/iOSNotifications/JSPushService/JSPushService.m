//
//  NewPushManager.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/9/19.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushService.h"

NSString *const JSPUSHSERVICE_LOCALNOTI_IDENTIFIER       = @"com.jspush.kLocalNotificationIdentifier";
#define  kLocalNotificationFromJSPushServiceKey           @"com.jspush.jspushservice"


#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
@interface JSPushService()<UNUserNotificationCenterDelegate>
#else
@interface JSPushService()
#endif

@property (nonatomic ,strong) JSRegisterConfig *config;

@end


@implementation JSPushService

+ (instancetype)sharedManager {
    
    static JSPushService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        JSPUSH_NOTIFICATIONCENTER.delegate = self;
#endif
    }
    return self;
}

# pragma mark - Register

+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories
{
    
    if (JSPUSH_IOS_12_0){
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 120000) )
        
        if ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(requestAuthorizationWithOptions:completionHandler:) ]) {
            [JSPUSH_NOTIFICATIONCENTER requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    }
                    if ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(setNotificationCategories:)]) {
                        [JSPUSH_NOTIFICATIONCENTER setNotificationCategories:categories];
                    }
                });
            }];
        }
        
#endif
        
    }else if (JSPUSH_IOS_10_0){
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        
        if ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(requestAuthorizationWithOptions:completionHandler:) ]) {
            [JSPUSH_NOTIFICATIONCENTER requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    }
                    if ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(setNotificationCategories:)]) {
                        [JSPUSH_NOTIFICATIONCENTER setNotificationCategories:categories];
                    }
                });
            }];
        }

#endif
    }else if (JSPUSH_IOS_8_0) {
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:types categories:categories]];
        }
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotificationTypes:)]) {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
        }
#pragma clang diagnostic pop
    }
    
}

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

+ (void)registerForRemoteNotificationConfig:(JSRegisterConfig *)config delegate:(id<JSServiceDelegate>)delegate
{
    if (config == nil) {
        JSPUSHLog(@"if you want to register remote notification,config musn't be nil");
        return;
    }
    [[self class] registerForRemoteNotificationTypes:config.types categories:config.categories];
    [JSPushService sharedManager].delegate = delegate;
    [JSPushService sharedManager].config = config;
    
}
#endif

#pragma mark - device token

+ (void)registerDeviceToken:(NSData *)deviceToken completionHandler:(void (^)(NSString *))completionHandler
{
    NSString *dt = [JSPushUtilities jspush_parseDeviceToken:deviceToken];
    if (completionHandler) {
        completionHandler(dt);
    }

}

#pragma mark - badge

+ (void)resetBadge {
    [JSPushService setBadge:0];
}

+ (void)setBadge:(NSInteger)badge {
    
    //只对角标大于0，修改为0
    if ([UIApplication sharedApplication]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            [self setBadgeToZero];
        }else{
            //是否已经注册角标
            if ([self checkNotificationType:UIRemoteNotificationTypeBadge]){
                [self setBadgeToZero];
            }else{
                JSRegisterConfig *config = [JSPushService sharedManager].config;
                if (config == nil) {
                    config = [[JSRegisterConfig alloc] init];
                    if (config.types == 0) {
                        config.types = 7;
                    }
                }
                [[self class] registerForRemoteNotificationTypes:config.types categories:config.categories];
                [self setBadgeToZero];
            }
        }
        
    }
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

+ (BOOL)checkNotificationType:(UIRemoteNotificationType)type
{

    if ( ([UIApplication sharedApplication])) {
        NSUInteger notiType = 0;
        if (JSPUSH_IOS_10_0) {
            //TODO:返回已经注册的通知类型，需要重构
        }else if (JSPUSH_IOS_8_0) {
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
                UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
                notiType = currentSettings.types;
            }

        }else{
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(enabledRemoteNotificationTypes)]) {
                notiType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            }
        }
        
        return (notiType & type);
    }else{
        return NO;
    }

}
#pragma clang diagnostic pop

+ (void)setBadgeToZero
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - Public Methods

+ (void)addNotification:(JSNotificationRequest *)jsRequest {
    
    if (JSPUSH_IOS_10_0) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        //convert JSPushNotificationRequest to UNNotificationRequest
        if ([UNNotificationRequest class]) {
            UNNotificationRequest *request = [self convertJSNotificationRequestToUNNotificationRequest:jsRequest];
            if (request != nil) {
                
                if ( (JSPUSH_NOTIFICATIONCENTER) && ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(addNotificationRequest:withCompletionHandler:)]) ) {
                    [JSPUSH_NOTIFICATIONCENTER addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                        //注册或更新通知成功回调，iOS10以上成功则result为UNNotificationRequest对象，失败则result为nil
                        id result = error ? nil : request;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (jsRequest.completionHandler) {
                                jsRequest.completionHandler(result);
                            }
                        });
                        
                    }];
                }
            }
        }
        
#endif
    }else{
        
        if ([UILocalNotification class]) {
            UILocalNotification *noti = [self convertJSNotificationRequestToUILocalNotification:jsRequest];
            //iOS10以下成功result为UILocalNotification对象，失败则result为nil
            id result = noti ? noti : nil;
            if (result) {
                
                Class UIApplicationClass = NSClassFromString(@"UIApplication");
                if (!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]){
                    return;
                }
                
                if ([UIApplication sharedApplication] && [[UIApplication sharedApplication] respondsToSelector:@selector(scheduleLocalNotification:)]) {
                    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (jsRequest.completionHandler) {
                    jsRequest.completionHandler(result);
                }
            });
        }
        
    }
}

+ (void)removeNotification:(JSNotificationIdentifier *)identifier {

    if (JSPUSH_IOS_10_0) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        if (JSPUSH_NOTIFICATIONCENTER) {
            BOOL hasResponds10Method = ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(removeAllDeliveredNotifications)]) && ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(removeAllPendingNotificationRequests)]) && ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(removeDeliveredNotificationsWithIdentifiers:)]) && ([JSPUSH_NOTIFICATIONCENTER respondsToSelector:@selector(removePendingNotificationRequestsWithIdentifiers:)]);
            
            if (!hasResponds10Method) {
                return;
            }
            
            if (identifier == nil) {
                [JSPUSH_NOTIFICATIONCENTER removeAllDeliveredNotifications];
                [JSPUSH_NOTIFICATIONCENTER removeAllPendingNotificationRequests];
            }else{
                if ([JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                    switch (identifier.state) {
                        case JSPushNotificationStateAll:
                        {
                            [JSPUSH_NOTIFICATIONCENTER removeDeliveredNotificationsWithIdentifiers:identifier.identifiers];
                            [JSPUSH_NOTIFICATIONCENTER removePendingNotificationRequestsWithIdentifiers:identifier.identifiers];
                            break;
                        }
                        case JSPushNotificationStatePending:
                        {
                            [JSPUSH_NOTIFICATIONCENTER removePendingNotificationRequestsWithIdentifiers:identifier.identifiers];
                            break;
                        }
                        case JSPushNotificationStateDelivered:
                        {
                            [JSPUSH_NOTIFICATIONCENTER removeDeliveredNotificationsWithIdentifiers:identifier.identifiers];
                            break;
                        }
                        default:
                            break;
                    }
                }else{
                    switch (identifier.state) {
                        case JSPushNotificationStateAll:
                        {
                            [JSPUSH_NOTIFICATIONCENTER removeAllPendingNotificationRequests];
                            [JSPUSH_NOTIFICATIONCENTER removeAllDeliveredNotifications];
                            break;
                        }
                        case JSPushNotificationStatePending:
                        {
                            [JSPUSH_NOTIFICATIONCENTER removeAllPendingNotificationRequests];
                            break;
                        }
                        case JSPushNotificationStateDelivered:
                        {
                            [JSPUSH_NOTIFICATIONCENTER removeAllDeliveredNotifications];
                            break;
                        }
                        default:
                            break;
                    }
                }
            }
        }
#endif
    }else{
        
        Class UIApplicationClass = NSClassFromString(@"UIApplication");
        if (!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]){
            return;
        }
        
        if ([UIApplication class] && [UIApplication sharedApplication]) {
            
            BOOL hasResponsed10BelowMethods = ([[UIApplication sharedApplication] respondsToSelector:@selector(cancelLocalNotification:)]) && ([[UIApplication sharedApplication] respondsToSelector:@selector(cancelAllLocalNotifications)]) && ([[UIApplication sharedApplication] respondsToSelector:@selector(scheduledLocalNotifications)]);
            
            if (!hasResponsed10BelowMethods) {
                return;
            }
            
            if(identifier.notificationObj != nil){
                [[UIApplication sharedApplication] cancelLocalNotification:identifier.notificationObj];
            }else if ( (identifier == nil) || (![JSPushUtilities jspush_validateArray:identifier.identifiers])){
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
            }else{
                
                NSArray *notis = [[UIApplication sharedApplication] scheduledLocalNotifications];
                for (UILocalNotification *noti in notis) {
                    for (NSString *iden in identifier.identifiers) {
                        NSString *notiIden =  noti.userInfo[JSPUSHSERVICE_LOCALNOTI_IDENTIFIER];
                        if ([notiIden isEqualToString:iden]) {
                            [[UIApplication sharedApplication] cancelLocalNotification:noti];
                        }
                    }
                }
                
            }
        }
    }

}

+ (void)findNotification:(JSNotificationIdentifier *)identifier {
    
    if (identifier == nil) {
        JSPUSHLog(@"if you want to find notification.identifier musn't nil");
        return;
    }
    
    if (JSPUSH_IOS_10_0) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        switch (identifier.state) {
            case JSPushNotificationStateAll:
            {
                
                [JSPUSH_NOTIFICATIONCENTER getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                    
                    __block NSMutableArray *finds = [NSMutableArray array];

                    __block NSArray *pendingResults = nil;
                    if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                        pendingResults = requests;
                    }else{
                        NSMutableArray *findRequests = [NSMutableArray array];
                        for (UNNotificationRequest *request in requests) {
                            for (NSString *iden in identifier.identifiers) {
                                if ([iden isEqualToString:request.identifier]) {
                                    [findRequests addObject:request];
                                }
                            }
                        }
                        pendingResults = [findRequests copy];
                    }
                    
                    
                    [JSPUSH_NOTIFICATIONCENTER getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
                        
                        NSArray *deliveredResults = nil;
                        if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                            deliveredResults = notifications;
                        }else{
                            NSMutableArray *findNotifications = [NSMutableArray array];
                            for (UNNotification *noti in notifications) {
                                for (NSString *iden in identifier.identifiers) {
                                    if ([iden isEqualToString:noti.request.identifier]) {
                                        [findNotifications addObject:noti];
                                    }
                                }
                            }
                            deliveredResults = [findNotifications copy];
                        }
                        
                        [finds addObjectsFromArray:pendingResults];
                        [finds addObjectsFromArray:deliveredResults];
                    
                        NSArray *allFinds = [finds copy];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (identifier.findCompletionHandler) {
                                identifier.findCompletionHandler(allFinds);
                            }else{
                                JSPUSHLog(@"identifier.findCompletionHandler is nil");
                            }
                        });


                    }];
                    
                    
                }];
                
                break;
            }
            case JSPushNotificationStatePending:
            {
                [JSPUSH_NOTIFICATIONCENTER getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                    
                    NSArray *results = nil;
                    if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                        results = requests;
                    }else{
                        NSMutableArray *findRequests = [NSMutableArray array];
                        for (UNNotificationRequest *request in requests) {
                            for (NSString *iden in identifier.identifiers) {
                                if ([iden isEqualToString:request.identifier]) {
                                    [findRequests addObject:request];
                                }
                            }
                        }
                        results = [findRequests copy];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (identifier.findCompletionHandler) {
                            identifier.findCompletionHandler(results);
                        }else{
                            JSPUSHLog(@"identifier.findCompletionHandler is nil");
                        }
                    });
                }];

                break;
            }
            case JSPushNotificationStateDelivered:
            {
                [JSPUSH_NOTIFICATIONCENTER getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
                    
                    NSArray *results = nil;
                    if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
                        results = notifications;
                    }else{
                        NSMutableArray *findNotifications = [NSMutableArray array];
                        for (UNNotification *noti in notifications) {
                            for (NSString *iden in identifier.identifiers) {
                                if ([iden isEqualToString:noti.request.identifier]) {
                                    [findNotifications addObject:noti];
                                }
                            }
                        }
                        results = [findNotifications copy];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (identifier.findCompletionHandler) {
                            identifier.findCompletionHandler(results);
                        }else{
                            JSPUSHLog(@"identifier.findCompletionHandler is nil");
                        }
                    });
                }];
                break;
            }
            default:
                break;
        }

#endif
    }else{
        
        NSArray *results = nil;
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];

        if (![JSPushUtilities jspush_validateArray:identifier.identifiers]) {
            results = localNotifications;
        }else{
            
            NSMutableArray *findNotifications = [NSMutableArray array];

            for (UILocalNotification *noti in localNotifications) {
                for (NSString *iden in identifier.identifiers) {
                    if ([iden isEqualToString:noti.userInfo[JSPUSHSERVICE_LOCALNOTI_IDENTIFIER]]) {
                        [findNotifications addObject:noti];
                    }
                }
            }
            results = [findNotifications copy];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (identifier.findCompletionHandler) {
                identifier.findCompletionHandler(results);
            }else{
                JSPUSHLog(@"identifier.findCompletionHandler is nil");
            }
        });
    }
    
}


# pragma mark - UNUserNotificationCenterDelegate

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jspushNotificationCenter:willPresentNotification:withCompletionHandler:)] ) {
        [self.delegate jspushNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jspushNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)]) {
        [self.delegate jspushNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
    }
}
#endif

#pragma mark - other

- (UIViewController *)viewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    return vc;
}



#pragma mark - Private Methods

# pragma mark  iOS 10 以上创建通知

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

+ (nullable UNNotificationRequest *)convertJSNotificationRequestToUNNotificationRequest:(JSNotificationRequest *)jsRequest {
    
    if (jsRequest == nil) {
        JSPUSHLog(@"error-request is nil!");
        return nil;
    }
    
    if (jsRequest.requestIdentifier == nil) {
        JSPUSHLog(@"error requestIdentifier is nil!");
        return nil;
    }
    
    UNNotificationContent *content = [self convertJSNotificationContentToUNNotificationContent:jsRequest.content];
    if (content == nil) {
        JSPUSHLog(@"error-request content is nil!");
        return nil;
    }
    //trigger为nil，则为立即触发
    UNNotificationTrigger *trigger = [self convertJSNotificationTriggerToUNPushNotificationTrigger:jsRequest.trigger];
    if (trigger == nil) {
        trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.0 repeats:NO];
    }
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:jsRequest.requestIdentifier content:content trigger:trigger];
    return request;
}

+ (nullable UNNotificationContent *)convertJSNotificationContentToUNNotificationContent:(JSNotificationContent *)jsContent {
    
    if (jsContent == nil) {
        JSPUSHLog(@"error-content is nil!");
        return nil;
    }
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    if (content) {
        if (jsContent.title && [content respondsToSelector:@selector(setTitle:)]) {
            content.title = jsContent.title;
        }
        
        if (jsContent.subtitle && [content respondsToSelector:@selector(setSubtitle:)]) {
            content.subtitle = jsContent.subtitle;
        }
        
        if (jsContent.body && [content respondsToSelector:@selector(setBody:)]) {
            content.body = jsContent.body;
        }
        
        if (jsContent.badge && [content respondsToSelector:@selector(setBadge:)]) {
            content.badge = jsContent.badge;
        }
        
        if (jsContent.categoryIdentifier && [content respondsToSelector:@selector(setCategoryIdentifier:)]) {
            content.categoryIdentifier = jsContent.categoryIdentifier;
        }
        
        if (jsContent.userInfo != nil) {
            NSMutableDictionary *userInfoM = [jsContent.userInfo mutableCopy];
            [userInfoM setValue:@"YES" forKey:kLocalNotificationFromJSPushServiceKey];
            jsContent.userInfo = [userInfoM copy];
        }else{
            NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
            [userInfoM setValue:@"YES" forKey:kLocalNotificationFromJSPushServiceKey];
            jsContent.userInfo = [userInfoM copy];
        }
        
        if ([content respondsToSelector:@selector(setUserInfo:)]) {
            content.userInfo = jsContent.userInfo;
        }
        
        //假如sound为空，或者为default，设置为默认声音
        if ([content respondsToSelector:@selector(setSound:)]) {
            if ( !([JSPushUtilities jspush_validateString:(jsContent.sound)]) || [jsContent.sound isEqualToString:@"default"]) {
                content.sound = [UNNotificationSound defaultSound];
            }else{
                content.sound = [UNNotificationSound soundNamed:jsContent.sound];
            }
        }
        
        if (jsContent.attachments && [content respondsToSelector:@selector(setAttachments:)]) {
            content.attachments = jsContent.attachments;
        }
        
        if (jsContent.threadIdentifier && [content respondsToSelector:@selector(setThreadIdentifier:)]) {
            content.threadIdentifier = jsContent.threadIdentifier;
        }
        
        if (jsContent.launchImageName && [content respondsToSelector:@selector(setLaunchImageName:)]) {
            content.launchImageName = jsContent.launchImageName;
        }
    }
    return content;
}

+ (nullable UNNotificationTrigger *)convertJSNotificationTriggerToUNPushNotificationTrigger:(JSNotificationTrigger *)jsTrigger {
    
    if (jsTrigger == nil) {
       UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.0 repeats:NO];
        return trigger;
    }
    //当fireDate不为nil，dateComponents为nil
    if ( (jsTrigger.fireDate != nil) && (jsTrigger.dateComponents == nil) ){
        NSDateComponents *dateC = [JSPushUtilities jspush_dateComponentsWithNSDate:jsTrigger.fireDate];
        if (dateC) {
            jsTrigger.dateComponents = dateC;
        }
    }
    
    UNNotificationTrigger *trigger = nil;
    
    if (jsTrigger.region != nil) {
        trigger = [UNLocationNotificationTrigger triggerWithRegion:jsTrigger.region repeats:jsTrigger.repeat];
    }else if (jsTrigger.dateComponents != nil){
        trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:jsTrigger.dateComponents repeats:jsTrigger.repeat];
    }else {
        trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:jsTrigger.timeInterval repeats:jsTrigger.repeat];
    }
    
    return trigger;
}

#endif

# pragma mark  iOS 10 以下创建本地通知

+ (UILocalNotification *)convertJSNotificationRequestToUILocalNotification:(JSNotificationRequest *)jsRequest {

    if (jsRequest == nil) {
        JSPUSHLog(@"error-request is nil!");
        return nil;
    }

    if (jsRequest.content == nil) {
        JSPUSHLog(@"error-content is nil!");
        return nil;
    }
    
    NSDate *fireDate = nil;
    
    if (jsRequest.trigger == nil) {
        fireDate = [NSDate date];
    }else if ( (jsRequest.trigger.fireDate == nil) && (jsRequest.trigger.dateComponents != nil) ) {
        //假如使用时，fireDate未设置，则将dateComponents转换为对应的fireDate
        NSDate *date = [JSPushUtilities jspush_dateWithNSDateComponents:jsRequest.trigger.dateComponents];
        if (date) {
            fireDate = date;
        }
    }else if((jsRequest.trigger.fireDate != nil) && (jsRequest.trigger.dateComponents == nil)){
        fireDate = jsRequest.trigger.fireDate;
    }
    
    UILocalNotification *noti = [self setLocalNotification:fireDate alertTitle:jsRequest.content.title alertBody:jsRequest.content.body badge:jsRequest.content.badge alertAction:jsRequest.content.action identifierKey:jsRequest.requestIdentifier userInfo:jsRequest.content.userInfo soundName:jsRequest.content.sound region:jsRequest.trigger.region regionTriggersOnce:jsRequest.trigger.repeat category:jsRequest.content.categoryIdentifier];
    
    return noti;
}

+ (UILocalNotification *)setLocalNotification:(NSDate *)fireDate
                                   alertTitle:(NSString *)alertTitle
                                    alertBody:(NSString *)alertBody
                                        badge:(NSNumber *)badge
                                  alertAction:(NSString *)alertAction
                                identifierKey:(NSString *)notificationKey
                                     userInfo:(NSDictionary *)userInfo
                                    soundName:(NSString *)soundName
                                       region:(CLRegion *)region
                           regionTriggersOnce:(BOOL)regionTriggersOnce
                                     category:(NSString *)category NS_AVAILABLE_IOS(8_0) {
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        if([notification respondsToSelector:@selector(setTimeZone:)]){
            notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        }
        
        if(fireDate && [notification respondsToSelector:@selector(setFireDate:)]){
            notification.fireDate = fireDate;
        }
        
        // 设置重复间隔
        // notification.repeatInterval = kCFCalendarUnitDay;
        
        // 设置提醒的文字内容
         if(JSPUSH_SYSTEM_VERSION_GREATER_THAN(@"8.2")){
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= JSPUSH_IPHONE_8_2) )
         if([notification respondsToSelector:@selector(setAlertTitle:)]){
                //8.2才支持,默认是应用名称
                notification.alertTitle = alertTitle;
         }
#endif
         }
        
        if(alertBody && [notification respondsToSelector:@selector(setAlertBody:)]){
            notification.alertBody   = alertBody;     //显示主体
        }
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= JSPUSH_IPHONE_8_0) )
        if(JSPUSH_IOS_8_0){
            if(category && [notification respondsToSelector:@selector(setCategory:)]){
                notification.category = category;
            }
            //设置地理位置
            if(region){
                if([notification respondsToSelector:@selector(setRegion:)]){
                    notification.region = region;
                }
                if([notification respondsToSelector:@selector(setRegionTriggersOnce:)]){
                    notification.regionTriggersOnce = regionTriggersOnce;
                }
            }
        }
#endif
        //设置侧滑按钮文字
        
         if([notification respondsToSelector:@selector(setHasAction:)]){
             notification.hasAction = YES;
         }
         if(alertAction && [notification respondsToSelector:@selector(setAlertAction:)]){
             notification.alertAction = alertAction;
         }
        
        // 通知提示音
        if([notification respondsToSelector:@selector(setSoundName:)]){
            if(soundName){
                notification.soundName = soundName;     //默认提示音：UILocalNotificationDefaultSoundName
            }else{
                notification.soundName = UILocalNotificationDefaultSoundName;
            }
        }
        
        // 设置应用程序右上角的提醒个数
        if([notification respondsToSelector:@selector(setApplicationIconBadgeNumber:)]){
            if(badge != nil){
                NSInteger badgeNum = [badge integerValue];
                if(badgeNum == 0){
                    notification.applicationIconBadgeNumber = 0;
                }else if(badgeNum > 0){
                    notification.applicationIconBadgeNumber = badgeNum;
                }else if(badgeNum < 0){
                    notification.applicationIconBadgeNumber++;
                }
            }
        }
        
        // 设定通知的userInfo，用来标识该通知
        NSMutableDictionary *aUserInfo = nil;
        if(userInfo){
            aUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        }else{
            aUserInfo = [NSMutableDictionary dictionary];
        }
        
        if(aUserInfo){
            if(notificationKey){
                aUserInfo[JSPUSHSERVICE_LOCALNOTI_IDENTIFIER] = notificationKey;
            }
            aUserInfo[kLocalNotificationFromJSPushServiceKey] = @"YES";
            if([notification respondsToSelector:@selector(setUserInfo:)]){
                notification.userInfo = [aUserInfo copy];
            }
        }
    }
    return notification;
}

# pragma mark- Other

+ (BOOL)isFromJSPushService:(id)usernotication
{
    if (usernotication == nil) return NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        if ([usernotication isKindOfClass:[UNNotification class]]) {
            UNNotification *unNoti = (UNNotification *)usernotication;
            if (unNoti == nil) return NO;
            if (unNoti.request.content.userInfo && [unNoti.request.content.userInfo[kLocalNotificationFromJSPushServiceKey] isEqualToString:@"YES"]) {
                return YES;
            }else{
                return NO;
            }
            
        }else if ([usernotication isKindOfClass:[UNNotificationResponse class]]){
            UNNotificationResponse *unResp = (UNNotificationResponse *)usernotication;
            if (unResp == nil || unResp.notification == nil) return NO;
            if (unResp.notification.request.content.userInfo && [unResp.notification.request.content.userInfo[kLocalNotificationFromJSPushServiceKey] isEqualToString:@"YES"]) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
#endif
    }else{
        if([usernotication isKindOfClass: [UILocalNotification class]]){
            UILocalNotification *locaoNoti = (UILocalNotification *)usernotication;
            if (locaoNoti) {
                if ( (locaoNoti.userInfo[kLocalNotificationFromJSPushServiceKey]) && ([locaoNoti.userInfo[kLocalNotificationFromJSPushServiceKey] isEqualToString:@"YES"])) {
                    return YES;
                }
            }
        }else{
            return NO;
        }
    }
    return NO;
}

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

+ (UNNotification *)getUNNotification:(id)obj
{
    UNNotification *unNoti = nil;
    if ([obj isKindOfClass:[UNNotification class]]) {
        unNoti = (UNNotification *)obj;
        if (unNoti == nil) return nil;
    }else if ([obj isKindOfClass:[UNNotificationResponse class]]){
        UNNotificationResponse *unResp = (UNNotificationResponse *)obj;
        if (unResp == nil || unResp.notification == nil) return nil;
        unNoti = unResp.notification;
        if (unNoti == nil) return nil;
    }else{
        return nil;
    }
    return unNoti;
}

#endif

@end
