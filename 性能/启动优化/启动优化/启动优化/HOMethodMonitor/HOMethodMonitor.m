//
//  HOMethodMonitor.m
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights rHOerved.
//

#import "HOMethodMonitor.h"

#import <Foundation/Foundation.h>
#import "HOMethodMonitor.h"
#import "HOMethodMonitorCore.h"

static dispatch_queue_t _queue;
static int _kQueuHOpecific;
static CFStringRef _queuHOpecificValue = CFSTR("HOMethodMonitor");


@interface HOMethodMonitor ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSValue *> *> *stack;

- (void)recored:(HOMethodInvocation *)invocation;

@end

static inline int methodMonitorIgnore(HOMethodInvocation *invocation) {
    CFStringRef retrievedValue = dispatch_get_specific(&_kQueuHOpecific);
    if (retrievedValue && CFStringCompare(retrievedValue, _queuHOpecificValue, kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
        /// 忽略的线程
        return 1;
    }
    if (strcmp(invocation->className, "HOMethodMonitor") == 0) {
        return 1;
    }
    
    unsigned long len = strlen(invocation->className);
    if (len < 2) {
        return 0;
    }
    else if (invocation->className[0] == 'O' && invocation->className[1] == 'S') {
        return 1;
    }
    return 0;
}

static inline void methodMonitorRecord(HOMethodInvocation *invocation) {
    HOMethodInvocation *newInvocation = HOMethodInvocationCopy(invocation);
    if (newInvocation->depth > 0) {
        newInvocation->topUUid = malloc(strlen(invocation->top->uuid) + 1);
        memcpy(newInvocation->topUUid, invocation->top->uuid, strlen(invocation->top->uuid) + 1);
    }
    dispatch_async(_queue, ^{
        [[HOMethodMonitor shareInstance] recored:newInvocation];
    });
}


@implementation HOMethodMonitor

+ (instancetype)shareInstance {
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}


- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create("HOMethodMonitor", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(_queue, &_kQueuHOpecific, (void *)_queuHOpecificValue, (dispatch_function_t)CFRelease);
        self.minTimeCost = 0;
        
        HOMethodMonitorSetIgnoreHandler(methodMonitorIgnore);
        HOMethodMonitorSetRecordHandler(methodMonitorRecord);
        
        _stack = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)start {
    HOMethodMonitorStart();
}

- (void)stop {
    HOMethdMonitorStop();
}

- (void)recored:(HOMethodInvocation *)invocation {
    if (_enbaleDebug) {
        printf("[%s %s] %.2lfms\n", invocation->className, invocation->cmdName, invocation->time / 1000.0);
    }
    
    NSString *uuid = [NSString stringWithUTF8String:invocation->uuid];
    NSString *topUuid = nil;
    if (invocation->depth > 0) {
        topUuid = [NSString stringWithUTF8String:invocation->topUUid];
        NSMutableArray<NSValue *> *childs = [_stack objectForKey:topUuid];
        if (!childs) {
            childs = [NSMutableArray array];
            [_stack setObject:childs forKey:topUuid];
        }
        [childs addObject:[NSValue valueWithPointer:invocation]];
    }
    
    NSMutableArray *childs = [_stack objectForKey:uuid];
    if (childs && [childs isKindOfClass:[NSMutableArray class]]) {
        invocation->childs = malloc(sizeof(void *) * childs.count);
        invocation->child_count = (unsigned int)childs.count;
        for (int i=0; i<childs.count; i++) {
            invocation->childs[i] = [childs[i] pointerValue];
        }
        [_stack removeObjectForKey:uuid];
    }
    else {
        invocation->child_count = 0;
        invocation->childs = NULL;
    }
    
    if (invocation->depth == 0 && [_delegate respondsToSelector:@selector(methodMonitor:recordInvocation:)]) {
        /// 记录
        HOMethodInvocationEntity *entity = [HOMethodInvocationEntity new];
        entity.className = [NSString stringWithUTF8String:invocation->className];
        entity.cmdName = [NSString stringWithUTF8String:invocation->cmdName];
        entity.time = invocation->time / 1000.0;
        
        NSMutableString *desc = [NSMutableString string];
        [self descriptionMethodCall:invocation toString:desc];
        entity.stack = [desc copy];
        
        [_delegate methodMonitor:self recordInvocation:entity];
    }
    
}


#pragma mark - Ignore

- (void)addIgnoreQueue:(dispatch_queue_t)queue {
    dispatch_queue_set_specific(_queue, &_kQueuHOpecific, (void *)_queuHOpecificValue, (dispatch_function_t)CFRelease);
}

- (void)removeIgnoreQueue:(dispatch_queue_t)queue {
    dispatch_queue_set_specific(_queue, &_kQueuHOpecific, NULL, (dispatch_function_t)CFRelease);
}

#pragma mark - Utils

- (void)descriptionMethodCall:(HOMethodInvocation *)invocation toString:(NSMutableString *)string {
    /// self
    [string appendString:@">"];
    for (int d=0; d<invocation->depth; d++) {
        [string appendString:@"  "];
    }
    if (invocation->isClassMethod) {
        [string appendString:@"+ "];
    }
    else {
        [string appendString:@"- "];
    }
    [string appendFormat:@"[%s %s]\t%.2lfms\n", invocation->className, invocation->cmdName, invocation->time / 1000.0];
    /// childs
    for (int i=0; i<invocation->child_count; i++) {
        [self descriptionMethodCall:invocation->childs[i] toString:string];
    }
    free(invocation->uuid);
    free(invocation->childs);
    free(invocation);
}

#pragma mark - AccHOsor

- (void)setMinTimeCost:(double)minTimeCost {
    _minTimeCost = minTimeCost;
    HOMethodMonitorSetMinTimeCost(minTimeCost * 1000);
}

@end
