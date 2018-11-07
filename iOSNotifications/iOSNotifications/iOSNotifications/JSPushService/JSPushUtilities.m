//
//  JSPushUtilities.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/13.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "JSPushUtilities.h"

@implementation JSPushUtilities


+ (BOOL)jspush_validateString:(NSString *)str
{
    if (str && [str isKindOfClass:[NSString class]] && str.length > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)jspush_validateDictionary:(NSDictionary *)dic
{
    if (dic && [dic isKindOfClass:[NSDictionary class]] && dic.allKeys.count > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)jspush_validateArray:(NSArray *)arr
{
    if (arr && [arr isKindOfClass:[NSArray class]] && (arr.count > 0)) {
        return YES;
    }
    return NO;
}

+ (NSString *)jspush_parseDeviceToken:(id)devicetoken
{
    NSString * tokenVal = nil;
    if ([devicetoken isKindOfClass:[NSData class]])
    {
        tokenVal = [devicetoken description];
        tokenVal = [tokenVal stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        tokenVal = [tokenVal stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    else if ([devicetoken isKindOfClass:[NSString class]])
    {
        tokenVal = devicetoken;
    }
    return tokenVal;
}


+ (NSDate *)jspush_dateWithNSDateComponents:(NSDateComponents *)dateComponents
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    gregorian.timeZone = [NSTimeZone defaultTimeZone];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    return date;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (NSDateComponents *)jspush_dateComponentsWithNSDate:(NSDate *)date
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:date];
    return dateComponents;
}
#pragma clang diagnostic pop


# pragma mark - Log

+ (void)jspush_file:(char *)sourceFile function:(char *)functionName line:(int)lineNumber format:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    //    NSString * file = [NSString stringWithCString:sourceFile encoding:NSUTF8StringEncoding];
    //        NSString * func = [NSString stringWithCString:functionName encoding:NSUTF8StringEncoding];
    NSString * log  = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    //    NSLog(@"%@:%d %@; ", [file lastPathComponent], lineNumber, log);
    NSLog(@"JSPUSHLog:%@",log);
    
}

@end
