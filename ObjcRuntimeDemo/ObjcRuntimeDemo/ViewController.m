//
//  ViewController.m
//  ObjcRuntimeDemo
//
//  Created by WengHengcong on 16/6/8.
//  Copyright © 2016年 Beijing Jingdong Century Trading Co., Ltd. All rights reserved.
//

#import "ViewController.h"

/*******************************************************************/
@interface TestSuperClass : NSObject

@property (nonatomic ,copy) NSString * superName;

@end

@implementation TestSuperClass

@end

/*******************************************************************/

@interface TestSubClass : TestSuperClass

@property (nonatomic ,copy) NSString     *subName;

@end

@implementation TestSubClass

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    return self;
}

@end

/*******************************************************************/

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //isKindOfClass：Returns a Boolean value that indicates whether the receiver is an instance of given class or an instance of any class that inherits from that class.
    
    //isMemberOfClass：Returns a Boolean value that indicates whether the receiver is an instance of a given class.
    
    //class实现
    //+ (Class)class {return self;}

    //- (Class)class {return object_getClass(self);}
    //Class object_getClass(id obj)
    //{
    //    if (obj) return obj->getIsa();
    //    else return Nil;
    //}
    
//    + (BOOL)isKindOfClass:(Class)cls {
//        for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
//            if (tcls == cls) return YES;
//        }
//        return NO;
//    }
//    
//    - (BOOL)isKindOfClass:(Class)cls {
//        for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
//            if (tcls == cls) return YES;
//        }
//        return NO;
//    }
    
    
//    + (BOOL)isMemberOfClass:(Class)cls {
//        return object_getClass((id)self) == cls;
//    }
//    
//    - (BOOL)isMemberOfClass:(Class)cls {
//        return [self class] == cls;
//    }

    TestSuperClass *sup = [[TestSuperClass alloc]init];
    TestSubClass   *sub = [[TestSubClass alloc]init];
    
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    
    NSLog(@"1. %d %d",res1,res2);
    
    BOOL res3 = [sup isKindOfClass:[TestSuperClass class]];
    BOOL res4 = [sup isKindOfClass:[TestSubClass class]];
    BOOL res5 = [sub isKindOfClass:[TestSuperClass class]];
    BOOL res6 = [sub isKindOfClass:[TestSubClass class]];
    
    NSLog(@"2. %d %d %d %d",res3,res4,res5,res6);
    
    
    BOOL res7 = [sup isMemberOfClass:[TestSuperClass class]];
    BOOL res8 = [sup isMemberOfClass:[TestSubClass class]];
    BOOL res9 = [sub isMemberOfClass:[TestSuperClass class]];
    BOOL res10 = [sub isMemberOfClass:[TestSubClass class]];
    
    NSLog(@"3. %d %d %d %d",res7,res8,res9,res10);
    
    BOOL res11 = [[sup class] isKindOfClass:[TestSuperClass class]];
    BOOL res12 = [[sup class] isKindOfClass:[TestSubClass class]];
    BOOL res13 = [[sub class] isKindOfClass:[TestSuperClass class]];
    BOOL res14 = [[sub class] isKindOfClass:[TestSubClass class]];
    
    NSLog(@"4. %d %d %d %d",res11,res12,res13,res14);
    
    BOOL res15 = [[sup class] isMemberOfClass:[TestSuperClass class]];
    BOOL res16 = [[sup class] isMemberOfClass:[TestSubClass class]];
    BOOL res17 = [[sub class] isMemberOfClass:[TestSuperClass class]];
    BOOL res18 = [[sub class] isMemberOfClass:[TestSubClass class]];
    
    NSLog(@"5. %d %d %d %d",res15,res16,res17,res18);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    }

@end
