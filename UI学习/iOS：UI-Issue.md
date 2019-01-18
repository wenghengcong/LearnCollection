---
title: iOS：UI Issue
description: iOS文章集合
categories:
  - iOS
date: 2018-10-30 17:33:13
tags:
---



## 页面跳转卡顿

* 网络数据请求



* 跳转时设置页面背景色

关键字：push、背景色

原因：UIViewController默认是一个空的，背景色为透明的页面。由于透明色颜色重叠后视觉上的问题



## 状态栏白色

1. Info.plist

View controller-based status bar appearance设置为NO

2. Project 选中项目

![project_status_bar](http://blog-1251606168.file.myqcloud.com/blog/2018-10-30-093827.png)



* 其他

  ```objectivec
  //viewcontroller
  override var preferredStatusBarStyle: UIStatusBarStyle 
  {    
      //LightContent
      return UIStatusBarStyle.lightContent
  
      //Default
      //return UIStatusBarStyle.default
  }
  
  //在didFinishLaunching
  UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
  ```



## 按钮不能点击

* 线程执行
* UserInteractionEnabled
* frame：父视图的小于子视图的frame，虽然能显示，但是不能点击
* 响应者链条中没有拦截点击事件