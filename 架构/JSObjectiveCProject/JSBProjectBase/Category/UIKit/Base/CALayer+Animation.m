//
//  CALayer+JS.m
//  timeboy
//
//  Created by wenghengcong on 15/5/9.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "CALayer+Animation.h"

@implementation CALayer (Animation)


-(CAAnimation *)anim_shake:(NSArray *)rotations duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount{
    
    //创建关键帧动画
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //指定值
    kfa.values = rotations;
    
    //时长
    kfa.duration = duration;
    
    //重复次数
    kfa.repeatCount=repeatCount;
    
    //完成删除
    kfa.removedOnCompletion = YES;
    
    //添加
    [self addAnimation:kfa forKey:@"rotation"];
    
    return kfa;
}



-(CAAnimation *)anim_revers:(AnimReverDirection)direction duration:(NSTimeInterval)duration isReverse:(BOOL)isReverse repeatCount:(NSUInteger)repeatCount timingFuncName:(NSString *)timingFuncName{
    
    NSString *key = @"reversAnim";
    
    if([self animationForKey:key]!=nil){
        [self removeAnimationForKey:key];
    }
    
    NSString *directionStr = nil;
    
    if(AnimReverDirectionX == direction)directionStr=@"x";
    if(AnimReverDirectionY == direction)directionStr=@"y";
    if(AnimReverDirectionZ == direction)directionStr=@"z";
    
    //创建普通动画
    CABasicAnimation *reversAnim = [CABasicAnimation animationWithKeyPath:[NSString stringWithFormat:@"transform.rotation.%@",directionStr]];
    
    //起点值
    reversAnim.fromValue=@(0);
    
    //终点值
    reversAnim.toValue = @(M_PI_2);
    
    //时长
    reversAnim.duration = duration;
    
    //自动反转
    reversAnim.autoreverses = isReverse;
    
    //完成删除
    reversAnim.removedOnCompletion = YES;
    
    //重复次数
    reversAnim.repeatCount = repeatCount;
    
    //添加
    [self addAnimation:reversAnim forKey:key];
    
    return reversAnim;
}



/**
 *  转场动画
 *
 *  @param animType 转场动画类型
 *  @param subtype  转动动画方向
 *  @param curve    转动动画曲线
 *  @param duration 转动动画时长
 *
 *  @return 转场动画实例
 */
-(CATransition *)transitionWithAnimType:(TransitionAnimType)animType subType:(TransitionSubType)subType curve:(TransitionCurve)curve duration:(CGFloat)duration{
    
    NSString *key = @"transition";
    
    if([self animationForKey:key]!=nil){
        [self removeAnimationForKey:key];
    }
    
    
    CATransition *transition=[CATransition animation];
    
    //动画时长
    transition.duration=duration;
    
    //动画类型
    transition.type=[self animaTypeWithTransitionType:animType];
    
    //动画方向
    transition.subtype=[self animaSubtype:subType];
    
    //缓动函数
    transition.timingFunction=[CAMediaTimingFunction functionWithName:[self curve:curve]];
    
    //完成动画删除
    transition.removedOnCompletion = YES;
    
    [self addAnimation:transition forKey:key];
    
    return transition;
}



/*
 *  返回动画曲线
 */
-(NSString *)curve:(TransitionCurve)curve{
    
    //曲线数组
    NSArray *funcNames=@[kCAMediaTimingFunctionDefault,kCAMediaTimingFunctionEaseIn,kCAMediaTimingFunctionEaseInEaseOut,kCAMediaTimingFunctionEaseOut,kCAMediaTimingFunctionLinear];
    
    return [self objFromArray:funcNames index:curve isRamdom:(TransitionCurveRamdom == curve)];
}



/*
 *  返回动画方向
 */
-(NSString *)animaSubtype:(TransitionSubType)subType{
    
    //设置转场动画的方向
    NSArray *subtypes=@[kCATransitionFromTop,kCATransitionFromLeft,kCATransitionFromBottom,kCATransitionFromRight];
    
    return [self objFromArray:subtypes index:subType isRamdom:(TransitionSubtypesFromRamdom == subType)];
}




/*
 *  返回动画类型
 */
-(NSString *)animaTypeWithTransitionType:(TransitionAnimType)type{
    
    //设置转场动画的类型
    NSArray *animArray=@[@"rippleEffect",@"suckEffect",@"pageCurl",@"oglFlip",@"cube",@"reveal",@"pageUnCurl"];
    
    return [self objFromArray:animArray index:type isRamdom:(TransitionAnimTypeRamdom == type)];
}



/*
 *  统一从数据返回对象
 */
-(id)objFromArray:(NSArray *)array index:(NSUInteger)index isRamdom:(BOOL)isRamdom{
    
    NSUInteger count = array.count;
    
    NSUInteger i = isRamdom?arc4random_uniform((u_int32_t)count) : index;
    
    return array[i];
}



@end
