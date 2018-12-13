//
//  main.m
//  方法缓存探索
//
//  Created by WengHengcong on 2018/12/13.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFPerson.h"
#import "BFBoy.h"
#import "BFTallBoy.h"
#import "BFClassInfo.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        //1. 观察方法缓存相关结构体的底层结构
//        BFPerson *person = [[BFPerson alloc] init];
//        struct bf_objc_class *personClass = (__bridge struct bf_objc_class *)[BFPerson class];
//        [person personTest];
//        [person eat];
//        [person run];
//
//        cache_t personCache = personClass->cache;
//        bucket_t *personBuckets = personCache._buckets;
//
//        [person personTest];
//        [person eat];
//        [person run];
//
//        bucket_t bucket = personBuckets[(long long)@selector(personTest) & personCache._mask];
//        for (int i = 0; i <= personCache._mask; i++) {
//            bucket_t bucket = personBuckets[i];
//            NSLog(@"%s --- %p", bucket._key, bucket._imp);
//        }
        
        //2. hash
        BFTallBoy *tallBoy = [[BFTallBoy alloc] init];
        struct bf_objc_class *tallBoyClass = (__bridge struct bf_objc_class *)[BFTallBoy class];
        
        [tallBoy tallBoyTest];
        [tallBoy boyTest];
        [tallBoy personTest];
        
        [tallBoy tallBoyTest];
        [tallBoy boyTest];
        [tallBoy personTest];
        
        NSLog(@"=======================");
        
        cache_t tallBoyCache = tallBoyClass->cache;
        bucket_t *tallBoyBuckets = tallBoyCache._buckets;
        
        //输出该类所有的缓存方法
        for (int i = 0; i <= tallBoyCache._mask; i++) {
            bucket_t bucket = tallBoyBuckets[i];
            NSLog(@"index: %d:  %s - %p", i, bucket._key, bucket._imp);
        }
    
        NSLog(@"%s %p", @selector(tallBoyTest), tallBoyCache.imp(@selector(tallBoyTest)));
        NSLog(@"%s %p", @selector(boyTest), tallBoyCache.imp(@selector(boyTest)));
        NSLog(@"%s %p", @selector(personTest), tallBoyCache.imp(@selector(personTest)));
        
        for (int i = 0; i <= tallBoyCache._mask; i++) {
            bucket_t bucket = tallBoyBuckets[i];
            NSLog(@"index: %d:  %s - %p", i, bucket._key, bucket._imp);
        }
        NSLog(@"=======================");
    }
    return 0;
}


void testCode()
{
//    mask_t sizeOfTallBoyCache = tallBoyCache._mask + 1;
//    bucket_t *newBuckets = allocateBuckets(sizeOfTallBoyCache);
//
//    cache_key_t tallBoyTestKey =  bf_getKey(@selector(tallBoyTest));
//    bucket_t *tallBoyTestBucket = bf_findBucket2(newBuckets, sizeOfTallBoyCache, tallBoyTestKey);
//    IMP tallBoyTestMethod = [BFTallBoy methodForSelector:@selector(tallBoyTest)];
//    //        newBuckets->set((long long)@selector(tallBoyTest), tallBoyTestMethod); 该方法不能编译
//    tallBoyTestBucket->_key = tallBoyTestKey;
//    tallBoyTestBucket->_imp = tallBoyTestMethod;
//
//    cache_key_t boyTestKey =  bf_getKey(@selector(boyTest));
//    bucket_t *boyTestBucket = bf_findBucket2(newBuckets, sizeOfTallBoyCache, boyTestKey);
//    IMP boyTestMethod = [BFTallBoy methodForSelector:@selector(boyTest)];
//    boyTestBucket->_key = boyTestKey;
//    boyTestBucket->_imp = boyTestMethod;
//
//    cache_key_t psersonTestKey =  bf_getKey(@selector(personTest));
//    bucket_t *personTestBucket = bf_findBucket2(newBuckets, sizeOfTallBoyCache, psersonTestKey);
//    IMP personTestMethod = [BFTallBoy methodForSelector:@selector(personTest)];
//    personTestBucket->_key = psersonTestKey;
//    personTestBucket->_imp = personTestMethod;
}
