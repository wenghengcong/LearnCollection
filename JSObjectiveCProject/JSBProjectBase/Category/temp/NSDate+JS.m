//
//  NSDate+JS.m
//  timeboy
//
//  Created by wenghengcong on 15/5/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "NSDate+JS.h"

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
#define CYCalendarUnitYear NSCalendarUnitYear
#define CYCalendarUnitMonth NSCalendarUnitMonth
#define CYCalendarUnitWeek NSCalendarUnitWeekOfYear
#define CYCalendarUnitDay NSCalendarUnitDay
#define CYCalendarUnitHour NSCalendarUnitHour
#define CYCalendarUnitMinute NSCalendarUnitMinute
#define CYCalendarUnitSecond NSCalendarUnitSecond
#define CYCalendarUnitWeekday NSCalendarUnitWeekday
#define CYDateComponentUndefined NSDateComponentUndefined
#else
#define CYCalendarUnitYear NSYearCalendarUnit
#define CYCalendarUnitMonth NSMonthCalendarUnit
#define CYCalendarUnitWeek NSWeekOfYearCalendarUnit
#define CYCalendarUnitDay NSDayCalendarUnit
#define CYCalendarUnitHour NSHourCalendarUnit
#define CYCalendarUnitMinute NSMinuteCalendarUnit
#define CYCalendarUnitSecond NSSecondCalendarUnit
#define CYCalendarUnitWeekday NSWeekdayCalendarUnit
#define CYDateComponentUndefined NSUndefinedDateComponent
#endif

@implementation NSDate(JS)

-(NSString *)getNSDateDay
{
    return [self formattedDateWithFormat:@"yyyy-MM-dd"];
}

-(NSString *)getNSDateTime
{
    return [self formattedDateWithFormat:@"HH:mm"];
}

-(NSString *)getNSDate
{
    return [self formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
}

+ (NSDateFormatter*)stringDateFormatter
{
    static NSDateFormatter* formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return formatter;
}

+ (NSDate*)DateFromString:(NSString*)string
{
    return [[self stringDateFormatter] dateFromString:string];
}


- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:CYCalendarUnitYear | CYCalendarUnitMonth | CYCalendarUnitDay fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfDay] options:0] dateByAddingTimeInterval:-1];
}

#pragma mark -

- (NSDate *)beginningOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:CYCalendarUnitYear | CYCalendarUnitMonth | CYCalendarUnitWeekday | CYCalendarUnitDay fromDate:self];
    
    NSInteger offset = components.weekday - (NSInteger)calendar.firstWeekday;
    components.day = components.day - offset;
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekOfMonth = 1;
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfWeek] options:0] dateByAddingTimeInterval:-1];
}

#pragma mark -

- (NSDate *)beginningOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:CYCalendarUnitYear | CYCalendarUnitMonth fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfMonth] options:0] dateByAddingTimeInterval:-1];
}

#pragma mark -

- (NSDate *)beginningOfYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:CYCalendarUnitYear fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 1;
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfYear] options:0] dateByAddingTimeInterval:-1];
}


/**
 *  判断当前时间是否在某一天
 */
- (BOOL)isInDate:(NSDate *)date
{
    if (([self isEarlierThanOrEqualTo:[date endOfDay]]) && ([self isLaterThanOrEqualTo:[date beginningOfDay]])) {
        return YES;
    }
    return NO;
}

@end
