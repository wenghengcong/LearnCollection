---
title: 做一个合格的iOS招聘官
date: 2018-05-07 10:09:49
tags:
---



# 简历筛选





# 电话面试

1. 
2. 





# 现场面试



## 对象和类的内存布局





## 离屏渲染

1. 自定义圆角的实现？

   //按正方形来算.长的一半就是半径.按照这个去设置就是圆角了,长方形的话则按短的那一边 _imageView.layer.cornerRadius = iamgeView.width/2; 

   _imageView.layer.masksToBounds = YES;``` 

   这样做对于少量的图片，这个没有什么问题，但是数量比较多的时候,UITableView滑动可能不是那么流畅，屏幕的帧数下降，影响用户体验。

   2.使用layer的mask遮罩和CAShapLayer 创建圆形的CAShapeLaer对象,设置为View的mask属性,这样也可以达到圆角的效果,但是前面提到过了,使用mask属性会离屏渲染,不仅这样,还曾加了一个 CAShapLayer对象.着实不可以取.  

   3.使用带圆形的透明图片.(求个切图大师 - - ). 

   4.CoreGraphics自定义绘制圆角.  提到CoreGraphics,还有一种 特殊的"离屏渲染"方式 不得不提,那就是drawRect方法.触发的方式: 如果我们重写了 drawRect方法,并且使用CoreGraphics技术去绘制.就设计到了CPU渲染,整个渲染,由CPU在app内同步完成,渲染之后再交给GPU显示.(这种方式对性能的影响不是很高) > tip：CoreGraphic通常是线程安全的，所以可以进行异步绘制，然后在主线程上更新.

    

2. 离屏渲染是什么，如何检测？

3. 开发中哪些情况会触发离屏渲染；

   ```
   1) drawRect
   2) layer.shouldRasterize = true;
   3) 有mask或者是阴影(layer.masksToBounds, layer.shadow*)；
    3.1) shouldRasterize（光栅化）
    3.2) masks（遮罩）
    3.3) shadows（阴影）
    3.4) edge antialiasing（抗锯齿）
    3.5) group opacity（不透明）
   4) Text（UILabel, CATextLayer, Core Text, etc）...
   ```

4. 如何优化，或者说如何避免离屏渲染；





## 消息转发机制

### 1. 动态方法解析

// 类方法专用

 \+ (BOOL)resolveClassMethod:(SEL)sel 

// 对象方法专用 
\+ (BOOL)resolveInstanceMethod:(SEL)sel

```objc
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *method = NSStringFromSelector(sel);
    if ([@"playPiano" isEqualToString:method]) {
        /**
         添加方法
         
         @param self 调用该方法的对象
         @param sel 选择子
         @param IMP 新添加的方法，是c语言实现的
         @param 新添加的方法的类型，包含函数的返回值以及参数内容类型，eg：void xxx(NSString *name, int size)，类型为：v@i
         */
        class_addMethod(self, sel, (IMP)playPiano, "v");
        return YES;
    }
    return NO;
}
```

### 2. 备援接受者

```objc
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSString *seletorString = NSStringFromSelector(aSelector);
    if ([@"playPiano" isEqualToString:seletorString]) {
        Student *s = [[Student alloc] init];
        return s;
    }
    // 继续转发
    return [super forwardingTargetForSelector:aSelector];
}
```



### 3. 完整的消息转发





## Runloop

1. 程序启动过程与程APP生命周期
2. 运行原理？
3. 集中输入源，定义了集中模式？
4. 应用



# 算法

1. 排序

   快排：

   如下的三步用于描述快排的流程：

   - 在数组中随机取一个值作为标兵
   - 对标兵左、右的区间进行划分(将比标兵大的数放在标兵的右面，比标兵小的数放在标兵的左面，如果倒序就反过来)
   - 重复如上两个过程，直到选取了所有的标兵并划分(此时每个标兵决定的区间中只有一个值，故有序)

2. 





#工作经验







# 解决问题的能力







# 性格