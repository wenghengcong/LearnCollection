关于iOS系统通知的方方面面。

Everything tha about notification in iOS.

[En](https://github.com/wenghengcong/iOSNotifications/blob/master/README_EN.md)

****
## iOS  bugs

#### 	1.  iOS 10.0.0 bug：点击通知，不响应

​		https://forums.developer.apple.com/thread/62267

​		https://forums.developer.apple.com/thread/54332

​		https://forums.developer.apple.com/thread/54322

​		[如何解决？去看看](http://wenghengcong.com/2016/10/%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF%EF%BC%88%E5%85%AD%EF%BC%89%EF%BC%9A%E6%9B%B4%E5%A4%9A%E7%9A%84%E6%B3%A8%E6%84%8F%E7%82%B9/)

#### 	2.  iOS 10.0.0 bug：自定义声音无法播放

​		[ios10 custom push notification sound not playing](http://stackoverflow.com/questions/39400703/ios10-custom-push-notification-sound-not-playing)
​		[local notification plays only default sound after app update](https://forums.developer.apple.com/thread/63186)
​		[UNNotificationSound not playing custom sound](https://forums.developer.apple.com/message/183937)

#### 3. iOS 11 Notification携带图片展示被截图

​		在iOS 10.2以下，如果带图片的通知，显示出来会被截。[[参考](https://forums.developer.apple.com/message/154320#154320)]。

​		可以自定义截图，[[API](https://developer.apple.com/reference/usernotifications/unnotificationattachmentoptionsthumbnailclippingrectkey)] .

​		[[讨论](http://stackoverflow.com/questions/39086878/media-attachment-crops-image-in-ios-10-notification)]

#### 4. iOS 11 部分beta版本或11.1部分版本可能收不到静默推送

​	[Silent push notifications never received in iOS 11](http://www.openradar.me/34182776)

​	 [Silent pushes not delivered to the app on iOS 11](https://stackoverflow.com/questions/44796613/silent-pushes-not-delivered-to-the-app-on-ios-11)

*****

## iOS 10的新框架

​	[活久见的重构 - iOS 10 UserNotifications 框架解析](https://onevcat.com/2016/08/notification/)

​	[Notifications in iOS 10](https://swifting.io/blog/2016/08/22/23-notifications-in-ios-10/)

​	[iOS10通知框架UserNotification理解与应用](https://my.oschina.net/u/2340880/blog/747781#OSC_h3_10)

****

## 开发者文档翻译及拓展

以下翻译的苹果原文档，现在均已经失效。

1. [通知那些事儿（一）：简介](http://wenghengcong.com/2016-04-%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF%EF%BC%88%E4%B8%80%EF%BC%89%EF%BC%9A%E7%AE%80%E4%BB%8B/)
2. [通知那些事儿（二）：深度剖析本地与远程通知](http://wenghengcong.com/2016-04-%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF%EF%BC%88%E4%BA%8C%EF%BC%89%EF%BC%9A%E6%B7%B1%E5%BA%A6%E5%89%96%E6%9E%90%E6%9C%AC%E5%9C%B0%E4%B8%8E%E8%BF%9C%E7%A8%8B%E9%80%9A%E7%9F%A5/)
3. [通知那些事儿（三）：注册、调度及处理用户通知](http://wenghengcong.com/2016-04-%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF%EF%BC%88%E4%B8%89%EF%BC%89%EF%BC%9A%E6%B3%A8%E5%86%8C%E3%80%81%E8%B0%83%E5%BA%A6%E5%8F%8A%E5%A4%84%E7%90%86%E7%94%A8%E6%88%B7%E9%80%9A%E7%9F%A5/)
4. [通知那些事儿（四）：Apple Push Notification Service](http://wenghengcong.com/2016-05-%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF%EF%BC%88%E5%9B%9B%EF%BC%89%EF%BC%9AApple-Push-Notification-Service/)
5. [通知那些事儿（五）：远程通知有效载荷](http://wenghengcong.com/2016-05-%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF%EF%BC%88%E4%BA%94%EF%BC%89%EF%BC%9A%E8%BF%9C%E7%A8%8B%E9%80%9A%E7%9F%A5%E6%9C%89%E6%95%88%E8%BD%BD%E8%8D%B7/)
6. [通知那些事儿（六）：更多的注意点](http://wenghengcong.com/2016-10-%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF%EF%BC%88%E5%85%AD%EF%BC%89%EF%BC%9A%E6%9B%B4%E5%A4%9A%E7%9A%84%E6%B3%A8%E6%84%8F%E7%82%B9/)

****

## 测试工具	

​	**推荐**：[PushFly](https://github.com/wenghengcong/BFPushFly)在Puhsher基础上，增加了对中文的支持，以及增加推送模板。

​	[Pusher](https://github.com/noodlewerk/NWPusher)最新的客户端，更新及时，支持iOS 10.

​	[Knuff](https://github.com/KnuffApp/Knuff)是一个用来测试远程推送的客户端。

​	[Houston](https://github.com/nomad/houston)简易实现了发送APNs通知。

​	[SmartPush](https://github.com/shaojiankui/SmartPush)一款IOS苹果远程推送测试程序,Mac OS下的APNS工具APP。

​	[APNS / GCM Tester](http://apns-gcm.bryantan.info/) 在线测试工具。

*****

## 博客或文档

* [Local and Remote Notification Programming Guide](https://developer.apple.com/library/mac/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/Introduction.html#//apple_ref/doc/uid/TP40008194-CH1-SW1)
* [极光推送](http://blog.jpush.cn/)
* [Push Notifications Tutorial: Getting Started](https://www.raywenderlich.com/123862/push-notifications-tutorial)
* [Push Issues](https://developer.apple.com/library/ios/technotes/tn2265/_index.html)
* [iOS 推送全解析，你不可不知的所有 Tips](http://blog.jiguang.cn/ios_push_overall/)
* [服务器推送证书](http://docs.getui.com/mobile/ios/apns/)
* [iOS开发各种证书问题](http://blog.csdn.net/li_shuang_ls/article/details/52259512)
* [第三方服务推送名词](http://docs.getui.com/more/word/)
* [iOS 证书一览](http://www.wenghengcong.com/2016/07/iOS%E8%AF%81%E4%B9%A6%E4%B8%80%E8%A7%88/)

*****

## 第三方服务

* [极光推送](https://www.jpush.cn/)

  多次用过极光推送，服务相对来说还算稳定，功能齐全，支持分类、别名和标签。

  API简洁，开发文档完整，推荐！

  有收费服务。

* [友盟推送](http://mobile.umeng.com/push)

  友盟是较早做APP应用相关服务的，其最大的优势是服务联动，包括统计服务、崩溃跟踪等都可以采用友盟的。推送也做的不错。用过一次，没什么特别体会。

* [百度云推送](http://push.baidu.com/)
* [腾讯信鸽](http://xg.qq.com/)

  起步比较晚，功能相对简单，试用过，没极光和友盟专业，但是背靠腾讯，应该会慢慢完善。

  目前不推荐。

* [个推](http://www.getui.com/)

  功能最丰富，开发文档也很完整，没用过。

* [云巴推送](http://yunba.io/products/push/)

  采用[MQTT](https://github.com/wenghengcong/MQTTExplore)协议实现的推送。可以研究下这个技术。

******

## 最佳实践


​	[This Demo](https://github.com/wenghengcong/PushNotificationEverything/tree/master/PushSettingsDemo)

​	[UserNotificationDemo](https://github.com/onevcat/UserNotificationDemo)

## 推送的分发处理

1. 推送处理管理类——PushRouterManager

   ```objectivec
   /**
    注册类名和key映射关系

    @param className 自定义实现的类
    @param key 类名对应的key
    */
   + (void)registerClassName:(NSString *)className withKey:(NSString *)key;
   ```


   /**
​    需要在自定义实现的类中实现的方法

    @param userinfo 推送的userinfo
    @param compeletion 处理推送后需要返回的回调
    */
   + (void)handleRouterWithUserinfo:(NSDictionary *)userinfo compeletion:(RouterDispatchCompeletionBlock)compeletion;

   ```

   ​

2. 业务处理类——ServiceOne、ServiceTwo。

   业务处理类必须按如下实现：

   ```Objectivec
   /**
    在load方法中注册当前Service与key的对应关系
    */
   + (void)load
   {
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           [PushRouterManager registerClassName:NSStringFromClass([self class]) withKey:@"serviceOne"];
       });
   }

   /**
    自定义Service处理

    @param userinfo 推送的userinfo
    */
   - (void)handlePushWithUserinfo:(NSDictionary *)userinfo
   {
       NSLog(@"hanlde service one");
   }

   ```

   在load中注册该类与key的映射关系，并实现对应推送处理方法handlePushWithUserinfo。

   ​

3. 在Appdelegate中实现消息推送分发

   ```objective-c
   - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
   {
       [PushRouterManager handleRouterWithUserinfo:userInfo compeletion:^(NSString *className, NSDictionary *resultInfo) {
           NSLog(@"class:%@-userin:%@", className, resultInfo);
       }];
    }
   ```

4. 注意，推送需要包含key: className。

   ```json
   {
    "aps":{
   	"alert":"Testing.. (0)",
   	"badge":1,
   	"sound":"default"
   	},
     "key":"ServiceOne"
   }
   ```



以上实现，具体可参照代码。



****

## 问答

| About Settings                           |
| :--------------------------------------- |
| [detect “Allow Notifications” is on/off for iOS8](http://stackoverflow.com/questions/25111644/detect-allow-notifications-is-on-off-for-ios8) |
| [Push Notification ON or OFF Checking in iOS](http://stackoverflow.com/questions/20374801/push-notification-on-or-off-checking-in-ios) |
| [iOS 8 enabled device not receiving PUSH notifications after code update](http://stackoverflow.com/questions/25909568/ios-8-enabled-device-not-receiving-push-notifications-after-code-update) |
| [Show on Lock Screen push notification settings?](http://stackoverflow.com/questions/36697355/show-on-lock-screen-push-notification-settings) |



| Receive notification twice               |
| :--------------------------------------- |
| [Reset push notification settings for app](http://stackoverflow.com/questions/2438400/reset-push-notification-settings-for-app?lq=1) |
| [iOS Push Notification Banner shown twice for a single Push](http://stackoverflow.com/questions/33047914/ios-push-notification-banner-shown-twice-for-a-single-push) |


| device token                             |
| :--------------------------------------- |
| [Does the APNS device token ever change, once created?](http://stackoverflow.com/questions/6652242/does-the-apns-device-token-ever-change-once-created) |
| [does app give different device token on re-installing again](http://stackoverflow.com/questions/33888962/does-app-give-different-device-token-on-re-installing-again) |
| [极光推送的设备唯一性标识 RegistrationID](http://blog.jpush.cn/registrationid/) |

| unique id for ios device                 |
| :--------------------------------------- |
| [UIDevice uniqueIdentifier Deprecated - What To Do Now?](http://stackoverflow.com/questions/6993325/uidevice-uniqueidentifier-deprecated-what-to-do-now) |
| [Always get a unique device id in iOS 7](http://stackoverflow.com/questions/19606773/always-get-a-unique-device-id-in-ios-7) |
| [objective C iOS Device ID in iOS7](http://stackoverflow.com/questions/19329765/objective-c-ios-device-id-in-ios7) |
| [iOS unique user identifier](http://stackoverflow.com/questions/7273014/ios-unique-user-identifier?lq=1) |
| [Unique id in ios](http://stackoverflow.com/questions/20453785/unique-id-in-ios) |



### 角标

**以iOS 10.3测试为准**

1.   UIApplication的applicationIconBadgeNumber属性既影响角标，也会影响通知栏。

    1) 当applicationIconBadgeNumber > 0时
    
    ​	1-1）包含历史通知，角标变化，通知栏通知不变。
    
    ​	1-2）不包含历史通知，角标变化，无通知栏推送。
    
    2) 当applicationIconBadgeNumber<＝0时：
    
    ​	2-1）包含历史通知，历史通知中只要有一条通知badge>0，清除角标，清空通知栏。
    
    ​	2-2）包含历史通知，历史通知中所有通知badge=0，或无badge字段。无角标，通知栏不变。
    
    ​	2-3）包含历史通知，历史通知中所有badge<0，无角标，通知栏不变。
    
    ​	2-4）不包含历史通知，无角标，无通知栏推送。

2. 远程推送payload的badge字段，既影响角标，也会影响通知栏。

    1） 推送payload不带badge

    ​       无角标，通知栏不变。

    2） 推送 payload 带角标badge

    ​	2-1）badge>0，不管是否有历史通知，角标变化，通知栏不变。

    ​	2-2）badge=0，历史通知中只要有一条通知badge>0，清除角标，清空通知栏。

    ​	2-3）badge<0，不管是否有历史通知角，无角标，通知栏不变。

    ​

3.   UILocalNotification的applicationIconBadgeNumber属性既影响角标，也会影响通知栏。

   参考4中的**“清理角标，但不清理通知中心”**说明

   ​

4.    清理角标，但不清理通知中心

   ​

   iOS 11，需要通过下面方法：

   ```objective-c
   [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
   ```

   iOS 11以下，则通过：

   ```objective-c
   UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];  
       clearEpisodeNotification.applicationIconBadgeNumber = -1;  
       [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];  。
   ```

   ​

角标清除是指，角标数字进行增减，跟`设置`中角标设置无关。



### 参考

[【经验】清除appIcon的推送数量（badgeNumber），但是在系统通知栏保留推送通知的方法](http://blog.csdn.net/hherima/article/details/54601418)http://blog.csdn.net/hherima/article/details/54601418)

[Clear applicationIconBadgeNumber without removing notifications not working](https://stackoverflow.com/questions/37789581/clear-applicationiconbadgenumber-without-removing-notifications-not-working)



### alert/body 显示

iOS 9：横幅弹出，最多显示两行，横幅下拉时完整显示，通知中心最多显示四行。超出之后会以“…”在末尾显示。

iOS 10：横幅弹出，最多显示两行，横幅下拉时完整显示，通知中心最多显示四行。超出之后会以“…”在末尾显示。

iOS 11：

****

## 如何自己实现推送

TODO:

1. 服务器；
2. iOS SDK；
   1. ~~第一步：创建本地通知，测试DEMO；~~
   2. 第二步：服务器通信SDK（采用MQTT）；
3. 性能测试；
4. 翻译最新的[Guide](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/index.html);

*****

## 参考

* iOS API接口参考

  - [个推](http://docs.getui.com/mobile/ios/api/)
  - [百度云推送](http://push.baidu.com/doc/ios/api)
  - [极光推送](http://docs.jpush.io/client/ios_api/)