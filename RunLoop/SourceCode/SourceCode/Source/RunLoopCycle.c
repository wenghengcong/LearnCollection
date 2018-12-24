//
//  RunLoopCycle.c
//  SourceCode
//
//  Created by WengHengcong on 2018/12/24.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#include <stdio.h>

/** 真正执行RunLoop运行循环的逻辑处理 */
static int32_t __CFRunLoopRun(CFRunLoopRef rl, CFRunLoopModeRef rlm, CFTimeInterval seconds, Boolean stopAfterHandle, CFRunLoopModeRef previousMode) {
    
    int32_t retVal = 0;
    do {
        if (rlm->_observerMask & kCFRunLoopBeforeTimers)
            // 2. 通知 Observers: RunLoop 即将处理 Timer 回调。
            __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeTimers);
        if (rlm->_observerMask & kCFRunLoopBeforeSources)
            // 3. 通知 Observers: RunLoop 即将处理 Source
            __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeSources);
        // 4. 处理Blocks
        __CFRunLoopDoBlocks(rl, rlm);
        
        // 5. 处理 Source0 (非port) 回调(可能再次处理Blocks)
        Boolean sourceHandledThisLoop = __CFRunLoopDoSources0(rl, rlm, stopAfterHandle);
        if (sourceHandledThisLoop) {
            // 处理Blocks
            __CFRunLoopDoBlocks(rl, rlm);
        }
        
        Boolean poll = sourceHandledThisLoop || (0ULL == timeout_context->termTSR);
        
        if (MACH_PORT_NULL != dispatchPort && !didDispatchPortLastTime) {
            // 6. 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。
            msg = (mach_msg_header_t *)msg_buffer;
            if (__CFRunLoopServiceMachPort(dispatchPort, &msg, sizeof(msg_buffer), &livePort, 0, &voucherState, NULL)) {
                goto handle_msg;
            }
        }
        
        if (!poll && (rlm->_observerMask & kCFRunLoopBeforeWaiting))
            // 7. 通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
            __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeWaiting);
        __CFRunLoopSetSleeping(rl);
        CFAbsoluteTime sleepStart = poll ? 0.0 : CFAbsoluteTimeGetCurrent();
        do {
            msg = (mach_msg_header_t *)msg_buffer;
            // 8. RunLoop开始休眠：等待消息唤醒，调用 mach_msg 等待接收 mach_port 的消息。
            // • 一个基于 port 的Source 的事件。
            // • 一个 Timer 到时间了
            // • RunLoop 自身的超时时间到了
            // • 被其他什么调用者手动唤醒
            __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort, poll ? 0 : TIMEOUT_INFINITY, &voucherState, &voucherCopy);
        } while (1);

        __CFRunLoopUnsetSleeping(rl);
        if (!poll && (rlm->_observerMask & kCFRunLoopAfterWaiting))
            // 9. 通知 Observers: RunLoop 结束休眠（被某个消息唤醒）
            __CFRunLoopDoObservers(rl, rlm, kCFRunLoopAfterWaiting);
    handle_msg:;
        // 收到消息，处理消息。
        __CFRunLoopSetIgnoreWakeUps(rl);
        
        if (MACH_PORT_NULL == livePort) {
            CFRUNLOOP_WAKEUP_FOR_NOTHING();
            // handle nothing
        } else if (livePort == rl->_wakeUpPort) {
            CFRUNLOOP_WAKEUP_FOR_WAKEUP();
        } else if (rlm->_timerPort != MACH_PORT_NULL && livePort == rlm->_timerPort) {
            CFRUNLOOP_WAKEUP_FOR_TIMER();
            // 9.1 处理Timer：如果一个 Timer 到时间了，触发这个Timer的回调。
            if (!__CFRunLoopDoTimers(rl, rlm, mach_absolute_time())) {
                __CFArmNextTimerInMode(rlm, rl);
            }
        } else if (livePort == dispatchPort) {
            CFRUNLOOP_WAKEUP_FOR_DISPATCH();
            _CFSetTSD(__CFTSDKeyIsInGCDMainQ, (void *)6, NULL);
            // 9.2 处理GCD Async To Main Queue：如果有dispatch到main_queue的block，执行block。
            __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
        } else {
            CFRUNLOOP_WAKEUP_FOR_SOURCE();
            voucher_t previousVoucher = _CFSetTSD(__CFTSDKeyMachMessageHasVoucher, (void *)voucherCopy, os_release);
            CFRunLoopSourceRef rls = __CFRunLoopModeFindSourceForMachPort(rl, rlm, livePort);
            if (rls) {
                mach_msg_header_t *reply = NULL;
                // 9.3 处理Source1：如果一个 Source1 (基于port) 发出事件了，处理这个事件
                sourceHandledThisLoop = __CFRunLoopDoSource1(rl, rlm, rls, msg, msg->msgh_size, &reply) || sourceHandledThisLoop;
                if (NULL != reply) {
                    (void)mach_msg(reply, MACH_SEND_MSG, reply->msgh_size, 0, MACH_PORT_NULL, 0, MACH_PORT_NULL);
                    CFAllocatorDeallocate(kCFAllocatorSystemDefault, reply);
                }
            }
        }
        // 10. 处理Blocks
        __CFRunLoopDoBlocks(rl, rlm);
        
        // 11. 根据前面的处理结果，决定流程
        // 11.1 当下面情况发生时，退出RunLoop
        if (sourceHandledThisLoop && stopAfterHandle) {
            retVal = kCFRunLoopRunHandledSource;
        } else if (timeout_context->termTSR < mach_absolute_time()) {
            // 11.1.1 超出传入参数标记的超时时间了
            retVal = kCFRunLoopRunTimedOut;
        } else if (__CFRunLoopIsStopped(rl)) {
            // 11.1.2 当前RunLoop已经被外部调用者强制停止了
            __CFRunLoopUnsetStopped(rl);
            retVal = kCFRunLoopRunStopped;
        } else if (rlm->_stopped) {
            // 11.1.3 当前运行模式已经被停止
            rlm->_stopped = false;
            retVal = kCFRunLoopRunStopped;
        } else if (__CFRunLoopModeIsEmpty(rl, rlm, previousMode)) {
            // 11.1.4 source/timer/observer一个都没有了
            retVal = kCFRunLoopRunFinished;
        }
        voucher_mach_msg_revert(voucherState);
        os_release(voucherCopy);
        // 11.2 如果没超时，mode里不为空也没停止，loop也没被停止，那继续loop。
    } while (0 == retVal);
    
    return retVal;
}

SInt32 CFRunLoopRunSpecific(CFRunLoopRef rl, CFStringRef modeName, CFTimeInterval seconds, Boolean returnAfterSourceHandled) {
    // RunLoop正在释放，完成返回
    if (__CFRunLoopIsDeallocating(rl)) return kCFRunLoopRunFinished;
    __CFRunLoopLock(rl);
    // 根据modeName 取出当前的运行Mode
    CFRunLoopModeRef currentMode = __CFRunLoopFindMode(rl, modeName, false);
    // 如果mode里没有source/timer/observer, 直接返回。
    int32_t result = kCFRunLoopRunFinished;
    
    if (currentMode->_observerMask & kCFRunLoopEntry )
        // 1. 通知 Observers: 进入RunLoop。
        __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopEntry);
        // 2---11，RunLoop的运行循环的核心代码
    result = __CFRunLoopRun(rl, currentMode, seconds, returnAfterSourceHandled, previousMode);
    
    if (currentMode->_observerMask & kCFRunLoopExit )
        // 12. 通知 Observers: 退出RunLoop
        __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
    
    rl->_currentMode = previousMode;
    return result;
}
// RunLoop 运行循环
void CFRunLoopRun(void) {
    int32_t result;
    do {
        // 调用RunLoop执行函数
        result = CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
    } while (kCFRunLoopRunStopped != result && kCFRunLoopRunFinished != result);
}
