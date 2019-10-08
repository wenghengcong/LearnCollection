****

关于iOS系统通知的方方面面。

Everything tha about notification in iOS.

[Cn](https://github.com/wenghengcong/iOSNotifications/blob/master/README.md)

****

## iOS bugs

#### 	1.  iOS 10.0.0 bug：click push,but not launch app

​		https://forums.developer.apple.com/thread/62267

​		https://forums.developer.apple.com/thread/54332

​		https://forums.developer.apple.com/thread/54322

​		[Solution](http://wenghengcong.com/2016/10/%E9%80%9A%E7%9F%A5%E9%82%A3%E4%BA%9B%E4%BA%8B%E5%84%BF%EF%BC%88%E5%85%AD%EF%BC%89%EF%BC%9A%E6%9B%B4%E5%A4%9A%E7%9A%84%E6%B3%A8%E6%84%8F%E7%82%B9/)

#### 	2. iOS 10.0.0 bug：custom sound

​		[ios10 custom push notification sound not playing](http://stackoverflow.com/questions/39400703/ios10-custom-push-notification-sound-not-playing)

​		[local notification plays only default sound after app update](https://forums.developer.apple.com/thread/63186)

​		[UNNotificationSound not playing custom sound](https://forums.developer.apple.com/message/183937)



*****


## iOS 10 new framework

[Notifications in iOS 10](https://swifting.io/blog/2016/08/22/23-notifications-in-ios-10/)

****

### Testing

[Puhser](https://github.com/noodlewerk/NWPusher) is a Mac client for testing push,Support iOS 10.

[Knuff](https://github.com/KnuffApp/Knuff) is a Mac client for testing push notification.

[Houston](https://github.com/nomad/houston) is a simple gem for sending Apple Push Notifications.

[SmartPush](https://github.com/shaojiankui/SmartPush)iOS Push Notification Debug App.

[APNS / GCM Tester](http://apns-gcm.bryantan.info/) Online testing.

*****

### Blog/Doc

* [Local and Remote Notification Programming Guide](https://developer.apple.com/library/mac/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/Introduction.html#//apple_ref/doc/uid/TP40008194-CH1-SW1)

* [Push Notifications Tutorial: Getting Started](https://www.raywenderlich.com/123862/push-notifications-tutorial)

* [Push Issues](https://developer.apple.com/library/ios/technotes/tn2265/_index.html)

*****

### Best Practice

[This Demo](https://github.com/wenghengcong/PushNotificationEverything/tree/master/PushSettingsDemo)

[UserNotificationDemo](https://github.com/onevcat/UserNotificationDemo)



****

### Q&A

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



****

## Push Server

TODO:

1. Push Server
2. iOS SDK
3. Performance testing

*****

## Ref

* iOS API Ref

  - [个推](http://docs.getui.com/mobile/ios/api/)
  - [百度云推送](http://push.baidu.com/doc/ios/api)
  - [极光推送](http://docs.jpush.io/client/ios_api/)