---
title: iOS：UIView
description: iOS文章集合
categories:
  - iOS
date: 2018-10-20 10:27:17
tags:
---



# 体系

![image-20190117184446213](http://blog-1251606168.file.myqcloud.com/blog_2018/2019-01-17-104446.png)



# 基本属性

* alpha
  * CGFloat 透明度
  * 0.0~1.0 透明~不透明
  * 0.0
    * 当前UIView及subviews都会隐藏
    * 当前UIView会从响应者链中移除，而响应者链中的下一个会成为第一响应者
  * 具有动画效果（CALayer隐式动画）
* hidden
  * BOOL 是否隐藏
  * YES
    * 当前的UIView和subview都会被隐藏，而不管subview的hidden值为多少
    * 当前UIView会从响应者链中移除，而响应者链中的下一个会成为第一响应者

* opaque
  * BOOL 是否不透明
  * 对UIView是否显示无影响
  * 计算重叠部分像素
    * Result是结果RGB值，Source为处在重叠顶部纹理的RGB值，Destination为处在重叠底部纹理的RGB值
    * Result = Source + Destination * (1 - SourceAlpha)
  * YES 不透明，显示顶部
    * Result=Source    SourceAlpha = 1.0
    * 顶部完全盖住底部
    * 提升绘制性能
    * 且SourceAlpha属性不为1.0
  * NO 透明的，显示叠加效果    SourceAlpha应该小于1.0



![image-20190117184152747](http://blog-1251606168.file.myqcloud.com/blog_2018/2019-01-17-104152.png)







# API

**setNeedsDisplay**

Marks the receiver’s entire bounds rectangle as needing to be redrawn.



**loadView**

Creates the view that the controller manages.



**setNeedsLayout**

Invalidates the current layout of the receiver and triggers a layout update during the next update cycle.



**layoutIfNeeded**

Lays out the subviews immediately, if layout updates are pending.







官方

[View Programming Guide for iOS](https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009503-CH1-SW2)

[UIView](https://developer.apple.com/documentation/uikit/uiview?language=objc)