//
//  JSBHttpResponseResult.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBHttpResponseResult.h"

#define JSONRESKEY_ERRORCODE    @"error_code"
#define JSONRESKEY_DATA @"data"
#define JSONRESKEY_MESSAGE  @"error_desc"

@implementation JSBHttpResponseResult

+ (id) createWithResponeObject:(id) responeObject
{
    if( ![responeObject isKindOfClass:[NSDictionary class]] )
    {
        return nil;
    }
    NSDictionary * jsonDict = (NSDictionary *) responeObject;
    JSBHttpResponseResult * ret = [[JSBHttpResponseResult alloc] initWithJsonRespone:jsonDict];
    return ret;
}

- (id) initWithJsonRespone:(NSDictionary *) json
{
    self = [super init];
    if (self) {
        _json = json;
    }
    
    return self;
}

- (kServerErrorCode) getErrorCode
{
    
    NSString * error_code = [_json objectForKey:JSONRESKEY_ERRORCODE];
    int result = [error_code intValue];
    return result;
}

- (NSString *) getErrorMessge
{
    if( _json == nil  )
        return nil;
    
    
    NSString * result_message = [_json objectForKey:JSONRESKEY_MESSAGE];
    return result_message;
}

- (id) getResponseData
{
    if( _json == nil )
        return nil;
    
    id data = [_json objectForKey:JSONRESKEY_DATA];
    
    return data;
}

- (NSArray *) tryGetReponseDataInArray
{
    if( [[self getResponseData] isKindOfClass:[NSArray class]] )
        return (NSArray *)[self getResponseData];
    return nil;
}

- (NSDictionary *) getResponseFirstObject
{
    if( [self tryGetReponseDataInDictionary] )
        return [self tryGetReponseDataInDictionary];
    
    NSArray * list = [self tryGetReponseDataInArray];
    if( list.count > 0 )
    {
        if( [[list objectAtIndex:0] isKindOfClass:[NSDictionary class]] )
        {
            NSDictionary * ret = [list objectAtIndex:0];
            return ret;
        }
        
    }
    return nil;
}
- (NSDictionary *) tryGetReponseDataInDictionary
{
    if( [[self getResponseData] isKindOfClass:[NSDictionary class]] )
        return (NSDictionary *)[self getResponseData];
    return nil;
}

-(NSString *) description
{
    NSString * desc = [[NSString alloc] initWithFormat:@"Respone Code<%lu> , Message<%@> , Data<%@> " ,
                       [self getErrorCode] ,
                       [self getErrorMessge] ,
                       [[self getResponseData] description]];
    return desc;
}

@end
