---
title: macOS：Macbook 使用
date: 2018-06-17 09:50:56
categories:
 	- macOS
tags:
 	- terminal
	- 隐藏文件
	- 快捷键
---



# Mac设置命令

- 隐藏文件

  ```sh
  $ defaults write com.apple.finder AppleShowAllFiles -bool false
  ```

- 





# 快捷键



# 日常使用

## 关闭摄像头

```sh
sudo chmod a-r /System/Library/Frameworks/CoreMediaIO.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
sudo chmod a-r /System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/AVC.plugin/Contents/MacOS/AVC
sudo chmod a-r /System/Library/QuickTime/QuickTimeUSBVDCDigitizer.component/Contents/MacOS/QuickTimeUSBVDCDigitizer
sudo chmod a-r /Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera
sudo chmod a-r /Library/CoreMediaIO/Plug-Ins/FCP-DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera
```

## 开启摄像头

```sh
sudo chmod a+r /System/Library/Frameworks/CoreMediaIO.framework/Versions/A/Resources/VDC.plugin/Contents/MacOS/VDC
sudo chmod a+r /System/Library/PrivateFrameworks/CoreMediaIOServicesPrivate.framework/Versions/A/Resources/AVC.plugin/Contents/MacOS/AVC
sudo chmod a+r /System/Library/QuickTime/QuickTimeUSBVDCDigitizer.component/Contents/MacOS/QuickTimeUSBVDCDigitizer
sudo chmod a+r /Library/CoreMediaIO/Plug-Ins/DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera
sudo chmod a+r /Library/CoreMediaIO/Plug-Ins/FCP-DAL/AppleCamera.plugin/Contents/MacOS/AppleCamera	
```





# 优化

## Spotlight关闭

mds_stores就是后台在建立索引等信息的进程。在建立这些信息的时候，需要对这些文件进行读取分析，并且写入索引等导致磁盘读写非常大。

### spotlight：

```sh
//关闭
$ sudo launchctl unload -w /System/Library/LaunchAgents/com.apple.Spotlight.plist

//开启
$ sudo launchctl load -w /System/Library/LaunchAgents/com.apple.Spotlight.plist
```



### mds_stores：

```sh
//关闭
$ sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

//开启
$ sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
```

或者

```sh
$ sudo mdutil -a -i off
$ sudo mdutil -a -i on

//参考https://apple.stackexchange.com/questions/144474/mds-and-mds-stores-constantly-consuming-cpu
```

