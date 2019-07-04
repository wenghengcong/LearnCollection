//
//  HOAPMLoadMonitor.m
//  启动优化
//
//  Created by Hunt on 2019/7/4.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

#import "HOAPMLoadMonitor.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#include <limits.h>
#include <mach-o/dyld.h>
#include <mach-o/nlist.h>
#include <string.h>

#define TIMESTAMP_NUMBER(interval)  [NSNumber numberWithLongLong:interval*1000*1000]

unsigned int count;
const char **classes;

static NSMutableArray *_loadInfoArray;

@implementation HOAPMLoadMonitor

+ (void)load {
    
    _loadInfoArray = [[NSMutableArray alloc] init];
    
    
    int imageCount = (int)_dyld_image_count();
    
    for(int iImg = 0; iImg < imageCount; iImg++) {
        
        const char* path = _dyld_get_image_name((unsigned)iImg);
        NSString *imagePath = [NSString stringWithUTF8String:path];
        
        NSBundle* mainBundle = [NSBundle mainBundle];
        NSString* bundlePath = [mainBundle bundlePath];
        
        if ([imagePath containsString:bundlePath] && ![imagePath containsString:@".dylib"]) {
            classes = objc_copyClassNamesForImage(path, &count);
            
            for (int i = 0; i < count; i++) {
                CFAbsoluteTime time1 = CFAbsoluteTimeGetCurrent();

                NSString *className = [NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding];
                if (![className isEqualToString:@""] && className) {
                    Class class = object_getClass(NSClassFromString(className));
                    
                    SEL originalSelector = @selector(load);
                    SEL swizzledSelector = @selector(HOAPM_Load);
                    
                    Method originalMethod = class_getClassMethod(class, originalSelector);
                    Method swizzledMethod = class_getClassMethod([HOAPMLoadMonitor class], swizzledSelector);
                    
                    BOOL hasMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
                    
                    if (!hasMethod) {
                        BOOL didAddMethod = class_addMethod(class,
                                                            swizzledSelector,
                                                            method_getImplementation(swizzledMethod),
                                                            method_getTypeEncoding(swizzledMethod));
                        
                        if (didAddMethod) {
                            swizzledMethod = class_getClassMethod(class, swizzledSelector);
                            
                            method_exchangeImplementations(originalMethod, swizzledMethod);
                        }
                    }
                    
                }
                CFAbsoluteTime time2 =CFAbsoluteTimeGetCurrent();
                
                NSLog(@"%@ Load time:%f",className,  (time2 - time1) * 1000);
            }
        }
    }
    

}

+ (void)HOAPM_Load {
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    [self HOAPM_Load];
    
    CFAbsoluteTime end =CFAbsoluteTimeGetCurrent();
    // 时间精度 us
    NSDictionary *infoDic = @{@"st":TIMESTAMP_NUMBER(start),
                              @"et":TIMESTAMP_NUMBER(end),
                              @"name":NSStringFromClass([self class])
                              };
    
    [_loadInfoArray addObject:infoDic];
}

@end
