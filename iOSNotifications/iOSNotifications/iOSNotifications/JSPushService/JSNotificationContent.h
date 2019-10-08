//
//  JSNotificationContent.h
//  iOSNotifications
//
//  Created by WengHengcong on 2016/11/17.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushUtilities.h"

NS_ASSUME_NONNULL_BEGIN
/**
 通知内容实体类
 */
@interface JSNotificationContent : NSObject<NSCopying,NSCoding>

/**
 通知标题
 */
@property (nonatomic, copy) NSString *title;

/**
 通知副标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 通知内容
 */
@property (nonatomic, copy) NSString *body;

/**
 角标的数字。
 nil:如果不需要改变角标
 0:隐藏角标
 -1:表示对当前badge++
 */
@property (nonatomic, copy,nullable) NSNumber *badge;

/**
 弹框的按钮显示的内容（IOS 8默认为"打开", 其他默认为"启动",iOS10以上无效）
 */
@property (nonatomic, copy) NSString *action    NS_DEPRECATED_IOS(8_0, 10_0);

/**
 行为分类标识
 */
@property (nonatomic, copy) NSString *categoryIdentifier;

/**
 本地通知时可以设置userInfo来增加附加信息，远程通知时设置的payload通知内容作为此userInfo
 */
@property (nonatomic, copy) NSDictionary *userInfo;

/**
 声音名称，不设置则为默认声音
 */
@property (nonatomic, copy,nullable) NSString *sound;

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

/**
 附件，iOS10以上有效，需要传入UNNotificationAttachment对象数组类型
 */
@property (nonatomic, copy) NSArray *attachments NS_AVAILABLE_IOS(10_0);

/**
 线程或与通知请求相关对话的标识，iOS10以上有效，可用来对通知进行分组
 */
@property (nonatomic, copy) NSString *threadIdentifier NS_AVAILABLE_IOS(10_0);

/**
 启动图片名，iOS10以上有效，从通知启动时将会用到
 */
@property (nonatomic, copy) NSString *launchImageName NS_AVAILABLE_IOS(10_0);
#endif

@end

NS_ASSUME_NONNULL_END
