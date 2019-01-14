//
//  JSBHttpActionManager.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBHttpActionManager.h"


@interface JSBHttpActionManager()

@property (nonatomic,assign)    BOOL    output_respone;
@property (nonatomic,assign)    BOOL    output_error;
@property (nonatomic,retain)    AFHTTPRequestOperationManager * httpRequestMgr;

-(NSString *) getBaseURLString;

@end

@implementation JSBHttpActionManager

/**
 *  获得base url
 *
 *  @return 根据版本返回base url
 */
-(NSString *) ham_getBaseURLString
{
    NSString * hostname = nil;
    
#if defined(PROJECT_DEVELOPMENT)
    
    hostname = @"http://development.jungle.com/app/v1";
    
#elif defined(PROJECT_TEST)
    
    hostname = @"http://test.jungle.com/app/v1";
    
    
#elif defined(PROJECT_PRODUCTION)
    
    hostname = @"http://app.jungle.com/app/v1";
    
    
#elif defined(PROJECT_UAT)
    
    hostname = @"http://uat.jungle.com/app/v1";
    
#endif
    
    NSString * base_url_string = [[NSString alloc] initWithFormat:@"%@",hostname];
    return base_url_string;
}

+ (id)sharedManager
{
    static JSBHttpActionManager *sharedMgr = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedMgr = [[self alloc]init];
        sharedMgr.output_error = TRUE;
        sharedMgr.output_respone = TRUE;
        
        NSURL * base_url = [NSURL URLWithString:[sharedMgr getBaseURLString]];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:base_url];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedMgr.httpRequestMgr = manager;

    });
    
    return sharedMgr;
}

- (AFHTTPRequestOperationManager *) getHttpRequestMgr
{
    return self.httpRequestMgr;
}

-(void) clearCookies
{
    NSURL * base_url = [NSURL URLWithString:[[JSBHttpActionManager sharedManager] ham_getBaseURLString]];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: base_url];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}


@end
