# 页面的生命循环周期

## 测试方法：

* loadView
* viewDidLoad
* viewWillAppear
* viewDidAppear
* viewWillDisappear
* viewDidDisappear

## 第一次加载主页面

> MasterVC loadView

> MasterVC viewDidLoad

> MasterVC viewWillAppear

> MasterVC viewDidAppear

## 第一次从主页面跳转到详情页

> MasterVC viewWillDisappear

> DetailVC loadView

> DetailVC viewDidLoad

> DetailVC viewWillAppear

> MasterVC viewDidDisappear

> DetailVC viewDidAppear

## 第一次从详情页回到主页面

> DetailVC viewWillDisappear

> MasterVC viewWillAppear

> DetailVC viewDidDisappear
 
> MasterVC viewDidAppear

## 第二次从主页面跳转到详情页
	
 同“第一次从主页面跳转到详情页”
	
## 第二次从详情页回到主页面

 同“第一次从详情页回到主页面”