//
//  BFPerson.h
//  位操作
//
//  Created by WengHengcong on 2018/12/12.
//  Copyright © 2018 WengHengcong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFPerson : NSObject

@property (assign, nonatomic, getter=isTall) BOOL tall;
@property (assign, nonatomic, getter=isRich) BOOL rich;
@property (assign, nonatomic, getter=isHansome) BOOL handsome;

@end

NS_ASSUME_NONNULL_END
