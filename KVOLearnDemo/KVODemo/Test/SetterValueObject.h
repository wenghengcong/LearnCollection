//
//  SetterValueObject.h
//  KVODemo
//
//  Created by whc on 15/8/4.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  在KVC中，setValue:forKey方法，还是调用valueForKey:方法，一般按以下顺序设置：
 *  1.优先考虑“setName:”属性值方法，通过setter完成设置；
 *  2.无"setName:"方法，寻找该类名为_name的成员变量，不管是在类声明部分定义还是在类实现部分定义，也无论用哪个访问控制符修饰，这条KVC代码就是针对_name成员变量赋值的；
 *  3.无"setName:"方法，也无“_name”成员变量，那么就寻找该类名为name的成员变量管是在类声明部分定义还是在类实现部分定义，也无论用哪个访问控制符修饰，这条KVC代码就是针对name成员变量赋值的；
*   4.如果上面三条都没有找到，系统将会执行该对象的setValue:forUndefinedKey:方法。
 */
@interface SetterValueObject : NSObject{
    @package
//    NSString *name;
//    NSString *_name;
    
    int price;
}

//@property (copy ,nonatomic)NSString         *name;

@end
