//
//  JSBShareManager.m
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/21.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBShareManager.h"


/** *  分享*/
#define kShareSDKAppKey                 @"8a3680a04277"
#define kShareSDKAppSecret              @"21ddbcba202642848f07648302e37f9a"

#define kWeiboAppKey                     @"2795671058"
#define kWeiboAppSecret              @"af7c8480b9d8fffa002b71260fd2bb70"
#define kWeiboAppRedirectUri         @"http://wenghengcong.com/timeboy"

#define kWechatAppKey                     @"wx45bc8f80b6abd3f0"
#define kWechatAppSecret              @"0a0641f83a0ce281f5b4ef6bfb74ba5a"
#define kWechatAppRedirectUri         @"http://wenghengcong.com/timeboy"

#define kQQAppKey                     @"1104779958"
#define kQQAppSecret                 @"uqzithF4NO44rO4r"
#define kQQAppRedirectUri            @"http://wenghengcong.com/timeboy"


@implementation JSBShareManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static JSBShareManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[JSBShareManager alloc] init];
    });
    return instance;
}

/**
 *  下面方法在application: didFinishLaunchingWithOptions:方法中调用registerApp方法来初始化SDK并且初始化第三方平台
 */
- (void)configShareSDKPlatforms {
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:kShareSDKAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:kWeiboAppKey
                                           appSecret:kWeiboAppSecret
                                         redirectUri:kWeiboAppRedirectUri
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:kWechatAppKey
                                       appSecret:kWechatAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:kQQAppKey
                                      appKey:kQQAppSecret
                                    authType:SSDKAuthTypeBoth];
                 break;

             default:
                 break;
         }
     }];
    
}

- (void) showShareActionSheet:(ObjShareContent *)shareContent {
    /**
     * 在定制平台内容分享中，除了设置共有的分享参数外，还可以为特定的社交平台进行内容定制，
     * 如：其他平台分享的内容为“分享内容”，但新浪微博需要在原有的“分享内容”文字后面加入一条链接，则可以如下做法：
     **/
    __weak typeof(self) weakSelf = self;
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    
    if (imageArray) {
        
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:@"分享内容 http://mob.com"
                                                   title:@"分享标题"
                                                   image:[UIImage imageNamed:@"shareImg.png"]
                                                     url:nil
                                                latitude:0
                                               longitude:0
                                                objectID:nil
                                                    type:SSDKContentTypeImage];
        
        
        //进行分享
        [ShareSDK share:SSDKPlatformTypeSinaWeibo
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     break;
                 }
                 case SSDKResponseStateFail:
                 {

                     break;
                 }
                 case SSDKResponseStateCancel:
                 {

                     break;
                 }
                 default:
                     break;
             }
             
         }];
    }
    
}


@end
