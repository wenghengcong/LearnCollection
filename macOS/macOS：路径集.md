---
title: macOS：路径集
date: 2018-09-12 09:21:06
description:
categories:
- macOS
tags:
- 路径
---



启动程序目录

/System/Library/LaunchDaemons



macOS NSUserDefaults 数据存储

[参考](https://stackoverflow.com/a/12637976/4124634)

```c
~/Library/Preferences/com.example.myapp.plist
~/Library/SyncedPreferences/com.example.myapp.plist

//沙盒环境
~/Library/Containers/com.example.myapp/Data/Library/Preferences/com.example.myapp.plist
~/Library/Containers/com.example.myapp/Data/Library/SyncedPreferences/com.example.myapp.plist
```



