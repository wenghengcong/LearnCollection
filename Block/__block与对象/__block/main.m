//
//  main.m
//  __block
//
//  Created by WengHengcong on 2018/12/9.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        __block BFPerson *blockPerson = [[BFPerson alloc] init];
        BFPerson *objectPerson = [[BFPerson alloc] init];
        void(^block)(void) = ^ {
            NSLog(@"person is %@ %@", blockPerson, objectPerson);
        };
    }
    return 0;
}
