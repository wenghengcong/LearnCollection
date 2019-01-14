//
//  FunNameApi.m
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "FunNameApi.h"

@implementation FunNameApi
{
    NSString *_username;
    NSString *_password;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

/**
 *  设置配置的API，
 *  1.如果设置过基地址，那么就只要返回相对地址即可
 *  2.如果没有基地址，那么需要返回完整的URL
 *  3.如果地址中包含可变参数，那么就需要buildCustomUrlRequest方法中设置。
 *  @return
 */
- (NSString *)requestUrl {
    
    /**
     *  可以在appDelegate.h中设置基地址
     */
    //YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    //config.baseUrl = @"http://yuantiku.com";
    //config.cdnUrl = @"http://fen.bi";
    
    // “http://www.yuantiku.com” is set in YTKNetworkConfig, so we ignore it
    return @"/iphone/register";
}


/**
 *  设置请求是get请求，还是post请求（还有其他请求头参数）
 *
 *  @return <#return value description#>
 */
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

/**
 *  返回自定义的url，主要用于url中有可变的参数。
 *
 *  @return
 */
- (NSURLRequest *)buildCustomUrlRequest {
    
    NSString *buildUrl = [NSString stringWithFormat:@"url...."];
    NSURL *url = [NSURL URLWithString:buildUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    return urlRequest;
}


/**
 *  将实例变量与api参数一一对应
 *
 *  @return <#return value description#>
 */
- (id)requestArgument {
    return @{
             @"username": _username,
             @"password": _password
             };
}

/**
 *  对返回的结果进行json校验
 *
 *  @return <#return value description#>
 */
- (id)jsonValidator {
    
    return @{
             @"username":[NSString class],
             @"password":[NSString class]
             };
    
}

/**
 *  缓存时间
 *
 *  @return <#return value description#>
 */
- (NSInteger)cacheTimeInSeconds {
    return 60 * 3;
}

- (NSString *)userId {
    return [[[self responseJSONObject] objectForKey:@"userId"] stringValue];
}
@end
