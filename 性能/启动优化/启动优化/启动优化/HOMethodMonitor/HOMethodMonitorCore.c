//
//  HOMethodMonitorCore.m
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights rHOerved.
//

#include "HOMethodMonitorCore.h"
#include <fishhook.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/timeb.h>
#include <objc/message.h>
#include <objc/runtime.h>
#include <dispatch/dispatch.h>
#include <pthread.h>

static inline uint64_t currentTime(void);

static unsigned long _min_time_cost = 1000;  /// ms
static bool _enableMethodMonitor = false;
static pthread_key_t _thread_key;
__unused static id (*orig_objc_msgSend)(id, SEL, ...);

static HOMethodMonitorIgnore _ignoreHandler;
static HOMethodMonitorRecord _recordHandler;

#pragma mark - Hook

static inline HOMethodInvocationStack * getMethodInvocationStack() {
    HOMethodInvocationStack *stack = (HOMethodInvocationStack *)pthread_getspecific(_thread_key);
    if (stack == NULL) {
        stack = (HOMethodInvocationStack *)malloc(sizeof(HOMethodInvocationStack));
        stack->index = -1;
        stack->isMainThread = pthread_main_np();
        pthread_setspecific(_thread_key, stack);
    }
    return stack;
}

static void releaseMethodInvocationStack(void *ptr) {
    HOMethodInvocationStack *stack = (HOMethodInvocationStack *)ptr;
    free(stack);
}

void before_objc_msgSend(id self, SEL _cmd, uintptr_t lr) {
    HOMethodInvocationStack *stack = getMethodInvocationStack();
    if (stack) {
        HOMethodInvocation *invocation = HOMethodInvocationCreate(self, _cmd, lr);
        if (stack->index >= 0) {
            invocation->top = stack->currentInvocation;
        }
        stack->currentInvocation = invocation;
        stack->index++;
        invocation->depth = stack->index;
        if (_enableMethodMonitor) {
            invocation->cls = object_getClass(self);
            invocation->time = currentTime();
            invocation->uuid = malloc(sizeof(char) * 40);
            srand((unsigned)invocation->time);
            sprintf(invocation->uuid, "%p_%llu_%d", self, invocation->time, rand());
        }
    }
}

uintptr_t after_objc_msgSend() {
    HOMethodInvocationStack *stack = getMethodInvocationStack();
    HOMethodInvocation *invocation = stack->currentInvocation;
    
    if (_enableMethodMonitor) {
        invocation->time = currentTime() - invocation->time;
        if (invocation->time > _min_time_cost) {
            if (class_isMetaClass(invocation->cls)) {
                invocation->isClassMethod = true;
                invocation->className = object_getClassName(invocation->object);
            }
            else {
                invocation->isClassMethod = false;
                invocation->className = object_getClassName((id)invocation->cls);
            }
            invocation->cmdName = sel_getName(invocation->cmd);
            if (!_ignoreHandler || _ignoreHandler(invocation) == 0) {
                !_recordHandler ?: _recordHandler(invocation);
            }
        }
    }
    
    stack->currentInvocation = invocation->top;
    stack->index--;
    return HOMethodInvocationRelease(invocation);
}

#if __aarch64__
#define call(b, value) \
__asm volatile ("stp x8, x9, [sp, #-16]!\n"); \
__asm volatile ("mov x12, %0\n" :: "r"(value)); \
__asm volatile ("ldp x8, x9, [sp], #16\n"); \
__asm volatile (#b " x12\n");

/// 依次将寄存器数据入栈
#define save() \
__asm volatile ( \
"stp x8, x9, [sp, #-16]!\n" \
"stp x6, x7, [sp, #-16]!\n" \
"stp x4, x5, [sp, #-16]!\n" \
"stp x2, x3, [sp, #-16]!\n" \
"stp x0, x1, [sp, #-16]!\n");

/// 依次将寄存器数据出栈
#define load() \
__asm volatile ( \
"ldp x0, x1, [sp], #16\n" \
"ldp x2, x3, [sp], #16\n" \
"ldp x4, x5, [sp], #16\n" \
"ldp x6, x7, [sp], #16\n" \
"ldp x8, x9, [sp], #16\n" );

#define link(b, value) \
__asm volatile ("stp x8, lr, [sp, #-16]!\n"); \
__asm volatile ("sub sp, sp, #16\n"); \
call(b, value); \
__asm volatile ("add sp, sp, #16\n"); \
__asm volatile ("ldp x8, lr, [sp], #16\n");

/// 程序执行完成,返回将继续执行lr中的函数
#define ret() __asm volatile ("ret\n");

#endif
__attribute__((__naked__))
static void hook_objc_msgSend() {
    #if __aarch64__
    /// before之前保存objc_msgSend的参数
    save()
    
    /// 将objc_msgSend执行的下一个函数地址传递给before_objc_msgSend的第二个参数x0 self, x1 _cmd, x2: lr address
    __asm volatile ("mov x2, lr\n");
    __asm volatile ("mov x3, x4\n");
    
    // Call our before_objc_msgSend.
    call(blr, &before_objc_msgSend)
    
    /// 恢复objc_msgSend参数，并执行
    load()
    
    // Call through to the original objc_msgSend.
    /// after之前保存objc_msgSend执行完成的参数
    call(blr, orig_objc_msgSend)
    
    // Save original objc_msgSend return value.
    save()
    
    // Call our after_objc_msgSend.
    /// 调用 after_objc_msgSend
    call(blr, &after_objc_msgSend)
    
    // rHOtore lr
    /// 将after_objc_msgSend返回的参数放入lr,恢复调用before_objc_msgSend前的lr地址
    __asm volatile ("mov lr, x0\n");
    
    /// 恢复objc_msgSend执行完成的参数
    // Load original objc_msgSend return value.
    load()
    
    // return
    /// 方法结束,继续执行lr
    ret()
    #endif
}

void HOMethodMonitorStart(void) {
    #if __aarch64__
    _enableMethodMonitor = true;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_key_create(&_thread_key, &releaseMethodInvocationStack);
        rebind_symbols((struct rebinding[6]){ {"objc_msgSend", (void *)hook_objc_msgSend, (void **)&orig_objc_msgSend}, }, 1);
    });
    #endif
}

void HOMethdMonitorStop(void) {
    _enableMethodMonitor = false;
}

void HOMethodMonitorSetMinCostTime(unsigned int time_us) {
    _min_time_cost = time_us;
}

void HOMethodMonitorSetIgnoreHandler(HOMethodMonitorIgnore ignore) {
    _ignoreHandler = ignore;
}

void HOMethodMonitorSetRecordHandler(HOMethodMonitorRecord record) {
    _recordHandler = record;
}

void HOMethodMonitorSetMinTimeCost(unsigned long minTimeCost) {
    _min_time_cost = minTimeCost;
}

#pragma mark ----

static inline uint64_t currentTime() {
    struct timeval now;
    gettimeofday(&now, NULL);
    return (now.tv_sec % 100) * 1000000 + now.tv_usec;
}
