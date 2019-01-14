//
//  JSBWXPayManager.h
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/20.
//  Copyright © 2016年 JungleSong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WXApi.h"

/**
 *  微信支付：
 *  文档 https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=1_1#
 */

/*

 开发步骤：
	1.开发微信APP支付，需要先去微信开放平台申请移动应用，并开通微信支付功能，通过审核后方可进行开发；
	2.用XCode打开项目，【项目属性】-【Info】-【URL Schemes】设置微信开放平台申请的应用APPID，如图文件夹下"设置appid.jpg"所示。如果这的APPID设置不正确将无法调起微信支付；
	3.需要调用代码注册APPID：[WXApi registerApp:APP_ID withDescription:@"demo 2.0”];项目该APPID需与步骤2中APPID保持一致；
	4.支付请求：WXApiRequestHandler.m中的jumpToBizPay方法实现了唤起微信支付；
	5.支付完成回调：WXApiManager.m中的onResp方法中接收返回支付状态。
 
 */


typedef void(WxPayCallBack)(BOOL retrunStatus,NSDictionary *resultDic);


@interface JSBWXPayManager : NSObject<WXApiDelegate>

+ (instancetype)sharedManager;

- (void)wxPayWithOrderStr:(PayReq *)payReq callback:(WxPayCallBack*)callBack;

@end
