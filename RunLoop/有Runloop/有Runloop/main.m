//
//  main.m
//  有Runloop
//
//  Created by WengHengcong on 2018/12/19.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

//int sleep_and_wait()
//{
//    // 等待消息
//    return 0;
//}
//
//int process_message(int message)
//{
//    //处理消息
//    return 0;
//}
//
//int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        int retVal = 0;
//        do {
//            // 睡眠中等待消息
//            int message = sleep_and_wait();
//            // 处理消息
//            retVal = process_message(message);
//        } while (0 == retVal);
//    }
//    return 0;
//}
