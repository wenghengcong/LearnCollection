//
//  UIControl+JS.h
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef void (^UIControlActionBlock)(id weakSender);


@interface UIControlActionBlockWrapper : NSObject
@property (nonatomic, copy) UIControlActionBlock actionBlock;
@property (nonatomic, assign) UIControlEvents controlEvents;
- (void)invokeBlock:(id)sender;
@end

@interface UIControl(JS)


#pragma mark- block

- (void)touchDown:(void (^)(void))eventBlock;
- (void)touchDownRepeat:(void (^)(void))eventBlock;
- (void)touchDragInside:(void (^)(void))eventBlock;
- (void)touchDragOutside:(void (^)(void))eventBlock;
- (void)touchDragEnter:(void (^)(void))eventBlock;
- (void)touchDragExit:(void (^)(void))eventBlock;
- (void)touchUpInside:(void (^)(void))eventBlock;
- (void)touchUpOutside:(void (^)(void))eventBlock;
- (void)touchCancel:(void (^)(void))eventBlock;
- (void)valueChanged:(void (^)(void))eventBlock;
- (void)editingDidBegin:(void (^)(void))eventBlock;
- (void)editingChanged:(void (^)(void))eventBlock;
- (void)editingDidEnd:(void (^)(void))eventBlock;
- (void)editingDidEndOnExit:(void (^)(void))eventBlock;

#pragma mark- actionBlock
- (void)handleControlEvents:(UIControlEvents)controlEvents withBlock:(UIControlActionBlock)actionBlock;
- (void)removeActionBlocksForControlEvents:(UIControlEvents)controlEvents;

@end
