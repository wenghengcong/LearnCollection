CloudKit



## 文档

主页：https://developer.apple.com/icloud/cloudkit/

官方开发指南：[CloudKit Quick Start](https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitQuickStart/EnablingiCloudandConfiguringCloudKit/EnablingiCloudandConfiguringCloudKit.html)

Raywenderlich [CloudKit Tutorial: Getting Started](https://www.raywenderlich.com/1000-cloudkit-tutorial-getting-started)

nshipster [CloudKit](https://nshipster.com/cloudkit/)



wwdc

[2015-What's New in CloudKit](https://developer.apple.com/videos/play/wwdc2015/704) 

[2015-CloudKit Tips and Tricks](https://developer.apple.com/videos/play/wwdc2015/715)

[2016-What's New with CloudKit](https://developer.apple.com/videos/play/wwdc2016/226)

[2016-CloudKit Best Practices](https://developer.apple.com/videos/play/wwdc2016/231)

[2017-Build Better Apps with CloudKit Dashboard](https://developer.apple.com/videos/play/wwdc2017/226/)





## 开发

**Private database**: Requires iCloud sign-in, separate database for every iCloud account, you cannot see user data in production and are not responsible for privacy issues.

**Shared database**: Requires iCloud sign-in, data can be shared between users, security rules can be configured.

**Public database**: No iCloud sign-in required for read-only access to the data.



A *Record Zone* (here noted as the *Default Zone*) is used to provide a logical organization to a private database by grouping records together. Custom zones support atomic transactions by allowing multiple records to be saved at the same time before processing other operations.



| Field Type | Class       | Description                                                  |
| ---------- | ----------- | ------------------------------------------------------------ |
| Asset      | CKAsset     | A large file that is associated with a record but stored separately |
| Bytes      | NSData      | A wrapper for byte buffers that is stored with the record    |
| Date/Time  | NSDate      | A single point in time                                       |
| Double     | NSNumber    | A double                                                     |
| Int(64)    | NSNumber    | An integer                                                   |
| Location   | CLLocation  | A geographical coordinate and altitude                       |
| Reference  | CKReference | A relationship from one object to another                    |
| String     | NSString    | An immutable text string                                     |
| List       | NSArray     | Arrays of any of the above field types                       |



## 注意





## Dashboard

### Data

Cloud kit的数据管理中心入口。在这里可以进行数据的字段，索引等内容设定。

### Logs

查看Cloud kit的服务日志，显示数据库操作，推送通知以及对应环境中的其他活动。

### Telemetry

查看对应环境中服务器端性能和数据库利用率的图表。

### Public Database Usage

查看公共数据库的使用情况图标，包括活跃用户、请求频率等。

### Api Access

管理API令牌和服务器密钥，允许对应环境进行web服务调用。



## Issue

1. 提示权限出问题

   在Security Roles中设置好读写权限。

2. 