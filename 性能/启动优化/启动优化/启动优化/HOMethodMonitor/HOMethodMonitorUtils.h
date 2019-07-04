//
//  HOMethodMonitorUtils.h
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights rHOerved.
//

#ifndef HOMethodMonitorUtils_h
#define HOMethodMonitorUtils_h

#include <stdio.h>
#include <objc/runtime.h>
#include <objc/message.h>
#include <stdlib.h>
#include <string.h>

#include <time.h>

struct HOMethodInvocation {
    const char *className;
    const char *cmdName;
    bool isClassMethod;
    uint64_t time;  // us
    uint depth;
    
    char *uuid;
    struct HOMethodInvocation *top;
    char *topUUid;
    
    struct HOMethodInvocation **childs;  /// 子级指针数组
    unsigned int child_count;   ///
    
    void *object;
    Class cls;
    SEL cmd;
    uintptr_t lr;
};
typedef struct HOMethodInvocation HOMethodInvocation;

struct HOMethodInvocationStack {
    bool isMainThread;
    int index;
    HOMethodInvocation *currentInvocation;
};
typedef struct HOMethodInvocationStack HOMethodInvocationStack;


static inline HOMethodInvocation * HOMethodInvocationInit() {
    HOMethodInvocation *invocation = malloc(sizeof(HOMethodInvocation));
    invocation->className = NULL;
    invocation->cmdName = NULL;
    invocation->isClassMethod = false;
    invocation->time = 0;
    invocation->depth = 0;
    
    invocation->uuid = NULL;
    invocation->top = NULL;
    invocation->topUUid = NULL;
    
    invocation->childs = NULL;
    invocation->child_count = 0;
    
    invocation->object = NULL;
    invocation->cmd = NULL;
    invocation->lr = 0;
    return invocation;
}

static inline HOMethodInvocation * HOMethodInvocationCreate(void *object, SEL cmd, uintptr_t lr) {
    HOMethodInvocation *invocation = HOMethodInvocationInit();
    invocation->object = object;
    invocation->cmd = cmd;
    invocation->lr = lr;
    invocation->uuid = NULL;
    return invocation;
}

static inline uintptr_t HOMethodInvocationRelease(HOMethodInvocation *invocation) {
    uintptr_t lr = invocation->lr;
    if (invocation->uuid) {
        free(invocation->uuid);
    }
    if (invocation->childs) {
        free(invocation->childs);
    }
    free(invocation);
    return lr;
}

static inline HOMethodInvocation * HOMethodInvocationCopy(HOMethodInvocation *invocation) {
    HOMethodInvocation *newInvocation = HOMethodInvocationInit();
    newInvocation->className = invocation->className;
    newInvocation->cmdName = invocation->cmdName;
    newInvocation->isClassMethod = invocation->isClassMethod;
    newInvocation->time = invocation->time;
    newInvocation->uuid = malloc(sizeof(char) * strlen(invocation->uuid));
    strcpy(newInvocation->uuid, invocation->uuid);
    newInvocation->depth = invocation->depth;
    return newInvocation;
}


#endif /* HOMethodMonitorUtils_h */
