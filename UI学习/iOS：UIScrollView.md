---
title: iOS：UIScrollView
description: iOS文章集合
categories:
  - iOS
date: 2018-10-20 10:27:46
tags:
---





三要素
* contentSize ----内容的尺寸，滚动范围
* contentOffset -----滚动的位置
* contentInset ------4周增加额外的滚动区域



![scrollview_size](http://blog-1251606168.file.myqcloud.com/blog_2018/2019-01-17-103013.png)





无法滚动
​	没有设置contentSize
​	scrollEnabled = NO
​	userInteractionEnabled = NO
​	没有取消autolayout功能



UIScrollViewDelegate
​	scrollViewWillBeginDragging:  				用户开始拖拽时
​	scrollViewDidScroll:   							具体滚动到某个位置时
​	scrollViewDidEndDragging:willDecelerate:		用户停止拖拽时



pagingEnabled





![UIScrollのプロパティ](http://blog-1251606168.file.myqcloud.com/blog_2018/2019-01-15-073621.png)







实践

[UIScrollView 实践经验](https://tech.glowing.com/cn/practice-in-uiscrollview/) 参考源码，放在**UI学习**文件夹

[理解 Scroll Views](https://objccn.io/issue-3-2/)





官方

[Scroll View Programming Guide for iOS](https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/UIScrollView_pg/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008179-CH1-SW1)

[UIScrollView class](https://developer.apple.com/documentation/uikit/uiscrollview?language=objc)