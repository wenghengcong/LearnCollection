//
//  BFPerson.m
//  动态方法解析
//
//  Created by WengHengcong on 2018/12/15.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import "BFPerson.h"
#import "BFBoy.h"
#import "BFGirl.h"
#import <objc/runtime.h>

@implementation BFPerson


/**
 1.未实现备援接收者
 */
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(eat)) {
//         // objc_msgSend([[BFBoy alloc] init], aSelector)
//        return [[BFBoy alloc] init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(eat)) {
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
        return signature;
    } else if (aSelector == @selector(eat:)) {
//        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
        // 以这种方式返回，注意不要使得BFBoy继承与BFPerson，否则假如BFBoy未实现methodSignatureForSelector，
        // 就会调用父类的methodSignatureForSelector，也就是本方法，会无限循环执行
        NSMethodSignature *signature = [[BFBoy alloc] methodSignatureForSelector:@selector(eat:)];
        return signature;
    } else if (aSelector == @selector(learnedNum)) {
        return [[BFGirl alloc] methodSignatureForSelector:@selector(learnedNum)];
    } else if (aSelector == @selector(learn:)) {
        return [[BFGirl alloc] methodSignatureForSelector:@selector(learn:)];
    } else if (aSelector == @selector(learnALot)) {
        return [[BFGirl alloc] methodSignatureForSelector:@selector(learnALot)];
    }
    return [super methodSignatureForSelector:aSelector];
}

// NSInvocation封装了一个方法调用，包括：方法调用者、方法名、方法参数
//    anInvocation.target 方法调用者
//    anInvocation.selector 方法名
//    [anInvocation getArgument:NULL atIndex:0]
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = anInvocation.selector;
    if (selector == @selector(eat)) {
        /*------------------测试转发流程------------------*/
        //！！！如果是下面这种方式直接调用，会崩溃。
        //因为target是assign，一赋值给target后，立即销毁，但target无法保留对象，所以在调用时会崩溃
//        anInvocation.target = [[BFBoy alloc] init];
//        [anInvocation invoke];
        
        //下面调用方式，在[anInvocation invoke]时，boy仍然保留
        [anInvocation invokeWithTarget:[[BFBoy alloc] init]];
        BFBoy *boy = [[BFBoy alloc] init];
        anInvocation.target = boy;
        [anInvocation invoke];
    } else if (selector == @selector(eat:)) {
        /*------------------测试参数------------------*/
        // 参数顺序：receiver、selector、other arguments
        NSString * name;
        [anInvocation getArgument:&name atIndex:2];
        NSLog(@"%@", name);
        
        //下面是修改selector以及参数
        name = @"banana";
        BFBoy *boy = [[BFBoy alloc] init];
        anInvocation.target = boy;
        //aSelector本来就是eat:，但是仍然可以修改，此处只针对测试用
        anInvocation.selector = @selector(eat:);
        [anInvocation setArgument:&name atIndex:2];
        [anInvocation invoke];
    }
    
    /*------------------测试返回值------------------*/
    /*
     1. !!! 取得返回值之前一定要赋值
     2. 返回的对象根据内存管理分为：
        2.1 assgign类型，如int
        2.2 copy类型，如NSString
        2.3 storng类型，如NSArray
     */
    if (selector == @selector(learnedNum)) {
        //1. assign类型，int，直接将int变量地址传入
        [anInvocation invokeWithTarget:[[BFGirl alloc] init]];
        int ret;
        [anInvocation getReturnValue:&ret];
        NSLog(@"invoke return value: %d", ret);
    } else if (selector == @selector(learn:)) {
        //2. copy类型，NSString，直接将copy变量地址传入
        [anInvocation invokeWithTarget:[[BFGirl alloc] init]];
        NSString *ret = [[NSString alloc] init];
        [anInvocation getReturnValue:&ret];
        NSLog(@"invoke return value: %@", ret);
    } else if (selector == @selector(learnALot)) {
        [anInvocation invokeWithTarget:[[BFGirl alloc] init]];
        
        //3. storng类型，如NSArray，会直接崩溃，如下代码
//        NSArray *ret = [NSArray array];
//        [anInvocation getReturnValue:&ret]; //ret指向的对象被销毁
//        NSLog(@"invoke return value: %@", ret);
//        NSLog(@"2------ret对象被销毁");
        
        /*
         1. 原因是getReturnValue方法，不会对传入的地址，进行对应的内存管理。
            1.1 assign以及copy，传入的地址，只需赋值，由系统进行管理
            1.2 而NSArray传入后，赋值后，因为没有被retain，在出了作用域，随即销毁
            1.3 由于调用处仍然获取了返回值，所以导致访问坏内存，会崩溃
        2. 出处 https://stackoverflow.com/questions/22018272/nsinvocation-returns-value-but-makes-app-crash-with-exc-bad-access
         */
        
        //解决以上崩溃，就是需要避免ARC时对象没有retain导致的崩溃。所以，只要将对象赋值给
        //__autoreleasing、__weak、__unsafe_unretained
        __weak NSArray* tempResultSet;
        [anInvocation getReturnValue:&tempResultSet];
//        NSArray *ret = tempResultSet;
//        NSLog(@"invoke return value: %@", ret);
        
//        void *tempResultSet;
//        [anInvocation getReturnValue:&tempResultSet];
//        NSString *resultSet = (__bridge NSString *)tempResultSet;
//        NSLog(@"invoke return value: %@", resultSet);

//        返回值长度
        NSMethodSignature *sig= [[BFBoy class] instanceMethodSignatureForSelector:@selector(learn:)];
        NSUInteger length = [sig methodReturnLength];
        //根据长度申请内存
        void *buffer = (void *)malloc(length);
        //为变量赋值
        [anInvocation getReturnValue:buffer];
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //case1: 替换实例方法
        Class selfClass = [self class];
        //case2: 替换类方法
//        Class selfClass = object_getClass([self class]);
        
        //源方法的SEL和Method
        SEL oriSEL = @selector(viewWillAppear:);
        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
        
        //交换方法的SEL和Method
        SEL cusSEL = @selector(customViewWillApper:);
        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
        
        //先尝试給源方法添加实现，这里是为了避免源方法没有实现的情况
        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
        if (addSucc) {
            //添加成功：将源方法的实现替换到交换方法的实现
            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即可
            method_exchangeImplementations(oriMethod, cusMethod);
        }
    });
}

@end
