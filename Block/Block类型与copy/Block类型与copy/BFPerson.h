//
//  BFPerson.h
//  Block类型与copy
//
//  Created by WengHengcong on 2018/12/8.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFPerson : NSObject
- (void)testCopy;
- (void)testStackBlockInMRC;
- (void)testBlockWithStrong;
@end

NS_ASSUME_NONNULL_END
