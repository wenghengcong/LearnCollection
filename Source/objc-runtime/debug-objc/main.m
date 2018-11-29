
//  main.m
//  debug-objc
//
//  Created by closure on 2/24/16.
//
//

#import <Foundation/Foundation.h>
#import "BFPerson.h"
#import "BFPerson+Study.h"
#import "BFPerson+Work.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, Begin explore objc!");
        BFPerson *person = [[BFPerson alloc] init];
        [person test];
        [person study];
    }
    return 0;
}
