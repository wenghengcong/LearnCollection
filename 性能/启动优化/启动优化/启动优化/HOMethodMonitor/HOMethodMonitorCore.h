//
//  HOMethodMonitorCore.h
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights rHOerved.
//

#ifndef HOMethodMonitorCore_h
#define HOMethodMonitorCore_h

#include <stdio.h>
#include "HOMethodMonitorUtils.h"

typedef int (*HOMethodMonitorIgnore)(HOMethodInvocation *invocation);
typedef void (*HOMethodMonitorRecord)(HOMethodInvocation *invocation);

void HOMethodMonitorStart(void);
void HOMethdMonitorStop(void);
void HOMethodMonitorSetIgnoreHandler(HOMethodMonitorIgnore ignore);
void HOMethodMonitorSetRecordHandler(HOMethodMonitorRecord record);
void HOMethodMonitorSetMinTimeCost(unsigned long minTimeCost);  /// us

#endif /* HOMethodMonitorCore_h */
