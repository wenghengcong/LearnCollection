//
//  ViewController.m
//  NSInvocationDemo
//
//  Created by Hunt on 2020/9/17.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self invocation_no_return_async_invoke];
}

- (void)invocation_no_return {
    
    SEL addIntSel = @selector(addInt:b:);
    NSMethodSignature *addIntSig = [self  methodSignatureForSelector:addIntSel];
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:addIntSig];
    [invo setTarget: self];
    [invo setSelector:addIntSel];
    
    int a=1;
    int b=2;
    [invo setArgument:&a atIndex:2];
    [invo setArgument:&b atIndex:3];
    NSLog(@"%d %d", a, b);
    
    int getA = 0;
    int getB = 0;
    [invo getArgument:&getA atIndex:2];
    [invo getArgument:&getB atIndex:3];
    NSLog(@"%d %d", getA, getB);

    [invo invoke];
}


/// 返回值是 int值
- (void)invocation_return_int {
    SEL addReturnSel = NSSelectorFromString(@"addReturn:b:");
    NSMethodSignature *addReturnSig = [self methodSignatureForSelector:addReturnSel];
    
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:addReturnSig];
    [invo setTarget: self];
    [invo setSelector:addReturnSel];
    
    int a=1;
    int b=2;
    int c=0;
    [invo setArgument:&a atIndex:2];
    [invo setArgument:&b atIndex:3];
    NSLog(@"%d %d", a, b);
    
    int getA = 0;
    int getB = 0;
    [invo getArgument:&getA atIndex:2];
    [invo getArgument:&getB atIndex:3];
    NSLog(@"%d %d", getA, getB);

//    [invo retainArguments];
    [invo getReturnValue:&c];
    NSLog(@"invoke before result: %d", c);
    
    //invoke
    [invo invoke];
    
    [invo getReturnValue:&c];
    NSLog(@"invoke after result: %d", c);
}



/// 返回值是 NSNumber，该类型有个有趣的点，如果值很小，使用 TaggedPointer，其内存管理相当于 assign，所以不会崩溃
/// 如果值很大，那么就默认使用 strong 修饰了，造成崩溃
- (void)invocation_return_number {
    
    SEL addReturnNumberSel = @selector(addReturnNumber:b:);
    NSMethodSignature *addReturnNumberSig = [self methodSignatureForSelector:addReturnNumberSel];
    
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:addReturnNumberSig];
    [invo setTarget: self];
    [invo setSelector:addReturnNumberSel];
    
    // 会崩溃
//    NSNumber *a = @1111111111111111111;
//    NSNumber *b = @2222222222222222222;
    
    // 不会崩溃，因为使用了 Tagged Pointer 技术
    NSNumber *a = @1;
    NSNumber *b = @2;
    
    NSNumber *c = 0;
    [invo setArgument:&a atIndex:2];
    [invo setArgument:&b atIndex:3];
    NSLog(@"%@ %@", a, b);
    
    NSNumber *getA = @0;
    NSNumber *getB = @0;
    [invo getArgument:&getA atIndex:2];
    [invo getArgument:&getB atIndex:3];
    NSLog(@"%@ %@", getA, getB);

//    [invo retainArguments];
    [invo getReturnValue:&c];
    NSLog(@"invoke before result: %@", c);
    
    //invoke
    [invo invoke];
    
    [invo getReturnValue:&c];
    NSLog(@"invoke after result: %@", c);
}


/// 返回值是 strong 类型的 NSArray，会崩溃
- (void)invocation_return_nsarray {
    
    SEL addReturnArraySel = @selector(addReturnArray:b:);
    NSMethodSignature *addReturnArraySig = [self methodSignatureForSelector:addReturnArraySel];
    
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:addReturnArraySig];
    [invo setTarget: self];
    [invo setSelector:addReturnArraySel];
    
    NSNumber *a = @1;
    NSNumber *b = @2;
    NSArray *c = [NSArray array];
    [invo setArgument:&a atIndex:2];
    [invo setArgument:&b atIndex:3];
    NSLog(@"%@ %@", a, b);
    
    NSNumber *getA = @0;
    NSNumber *getB = @0;
    [invo getArgument:&getA atIndex:2];
    [invo getArgument:&getB atIndex:3];
    NSLog(@"%@ %@", getA, getB);

//    [invo retainArguments];
    [invo getReturnValue:&c];
    NSLog(@"invoke before result: %@", c);
    
    //invoke
    [invo invoke];
    
    [invo getReturnValue:&c];
    NSLog(@"invoke after result: %@", c);
}

- (void)fixed_invocation_return_array {
    
    SEL addReturnArraySel = @selector(addReturnArray:b:);
    NSMethodSignature *addReturnArraySig = [self methodSignatureForSelector:addReturnArraySel];
    
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:addReturnArraySig];
    [invo setTarget: self];
    [invo setSelector:addReturnArraySel];
    
    NSNumber *a = @1;
    NSNumber *b = @2;
    __weak NSArray *c = [NSArray array];
    [invo setArgument:&a atIndex:2];
    [invo setArgument:&b atIndex:3];
    NSLog(@"%@ %@", a, b);
    
    NSNumber *getA = @0;
    NSNumber *getB = @0;
    [invo getArgument:&getA atIndex:2];
    [invo getArgument:&getB atIndex:3];
    NSLog(@"%@ %@", getA, getB);

//    [invo retainArguments];
    [invo getReturnValue:&c];
    NSLog(@"invoke before result: %@", c);
    
    //invoke
    [invo invoke];
    
    [invo getReturnValue:&c];
    NSLog(@"invoke after result: %@", c);
}

#pragma mark - Function

- (void)addInt:(int)a b:(int)b {
    int c = a + b;
    NSLog(@"addInt: c = %d", c);
}

- (int)addReturn:(int)a b:(int)b {
    int c = a + b;
    NSLog(@"addReturn: c = %d", c);
    return c;
}

- (NSNumber *)addReturnNumber:(NSNumber *)a b:(NSNumber *)b {
    NSNumber *c = @(a.longLongValue + b.longLongValue);
    NSLog(@"addReturnNumber: c = %@", c);
    return c;
}

- (NSArray *)addReturnArray:(NSNumber *)a b:(NSNumber *)b {
    NSNumber *c = @(a.intValue + b.intValue);
    NSLog(@"addReturnArray: c = %@", c);
    return @[a, b, c];
}

@end
