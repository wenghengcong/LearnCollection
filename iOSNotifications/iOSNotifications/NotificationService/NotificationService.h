//
//  NotificationService.h
//  NotificationService
//
//  Created by WengHengcong on 2017/1/4.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>


/*
 Service Extension 现在只对远程通知的通知起效，你可以在通知 payload 中增加一个 mutable-content 值为 1 的项来启用内容修改
 mutable-content，经测试，APNS接受string和int。int，0是不经过Extension，不修改通知内容，。1则反之。
 如果是string，不管传什么值，都会经过Extension。即相当于1.
 */
/*
{
    "aps":{
        "alert":{
            "title":"Hurry Up!",
            "body":"Go to School~"
        },
        "sound":"default",
        "mutable-content":1,
    },
}
*/
@interface NotificationService : UNNotificationServiceExtension

@end
