---
title: iOS：应用瘦身
date: 2018-02-07 07:22:01
categories:
- iOS
tags:
---





[App Thinning in Xcode](https://developer.apple.com/videos/play/wwdc2015/404/)

[What is app thinning? (iOS, tvOS, watchOS)](https://help.apple.com/xcode/mac/current/#/devbbdc5ce4f)

[Reducing the size of my App](https://developer.apple.com/library/archive/qa/qa1795/_index.html)

# 资源瘦身

[ WWDC: Introducing On Demand Resources](https://developer.apple.com/videos/play/wwdc2015/214/)





## 可执行文件瘦身

[构建版本文件大小](https://help.apple.com/app-store-connect/#/dev611e0a21f)

[Max size of an iOS application](https://stackoverflow.com/questions/4753100/max-size-of-an-ios-application)





# >>>>>>>>>>>>>>>>>>>>>>>>>>瘦身策略<<<<<<<<<<<<<<<<<<<<<<

iOS 除去编译优化的策略，下面是一些可行的方法。

统计工具：LinkMap <https://github.com/huanxsd/LinkMap>

AppCode: 代码工具，静态检查、无用代码

# 1.功能下线

### 和产品、服务端、外部调用方沟通。

### 1.1    灰度、降级：评估

### 1.2    次级功能点：评估

### 1.3    已下线功能：服务端客户端均下线功能，删除。

###   1.4    服务端已停止服务等：和产品沟通后，在当前版本删除；

# 2. 删除无用代码

### 2.1     无用代码删除  <https://github.com/pmd/pmd>    Appcode

### 2.2     Log代码注释

### 2.3     清除冗余import文件头  <https://github.com/dblock/fui>

### 2.4     清理无用变量（全局变量、临时变量）、字符串常量

# 3. 重用

### 后面导出整个京东的头文件，便于查找。

### 3.1     视图空间的重用，弹窗、按钮等。先去JDBCoreComponentModule、JDBUIKitModule等公共组件找。

### 3.2     分类方法的重用，慎重添加iOS 系统类的分类方法，会导致启动延时，以及方法重复，甚至不可预测的崩溃。在JDBBusinessFoundationModule、JDDBaseModule等组件。

### 3.3     宏定义的重用。

# 4. 代码重构及优化

### 4.1    减少方法名和类名长度：OC注重“见名知义”（不推荐）

### 4.2    代码重构，减少重复代码      <https://github.com/pmd/pmd>

### 4.3   自定义视图或控件时，尽量减少“功能全、定制化程度高”的考虑，保证视图或控件“当前可用，下两个版本可扩展”，不用考虑到下面三个版本的事情。

### 4.4   整合类：单个类文件过少代码，将多个简单类，放在同一个类文件下。比如多个Openapp协议文件，放于同一个类文件。

# 5. RN

### RN、Flutter等技术改造。