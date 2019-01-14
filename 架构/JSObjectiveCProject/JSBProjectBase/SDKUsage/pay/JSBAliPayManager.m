//
//  JSBPayManager.m
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/20.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBAliPayManager.h"

#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

typedef enum : NSUInteger {
    AliPayReturnStatusSuccess = 9000,           //订单支付成功
    AliPayReturnStatusHanding = 8000,           //正在处理中
    AliPayReturnStatusFailure = 4000,           //订单支付失败
    AliPayReturnStatusUserCancel = 6001,        //用户中途取消
    AliPayReturnStatusNetworkError = 6002,      //网络连接出错
} AliPayReturnStatus;


@implementation JSBAliPayManager

/**
 *  test
 */
- (void)generateOrder {
    /*
     *商户的唯一的parnter和seller。*签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    NSString *partner = @"";
    NSString *seller = @"";
    NSString *privateKey = @"";
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    ObjAliOrder *order = [[ObjAliOrder alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO];
    order.productName = @"商品标题";
    order.productDescription = @"商品描述";
    order.amount = @"0.01"; //商品价格
    order.notifyURL =  @"http://www.xxx.com";
    
    /*
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    */
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    /*
     *以下是由客户端生成私钥
     //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
     id<DataSigner> signer = CreateRSADataSigner(privateKey);
     NSString *signedString = [signer signString:orderSpec];
     
     //将签名成功字符串格式化为订单字符串,请严格按照该格式
     NSString *orderString = nil;
     if (signedString != nil) {
     orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
     orderSpec, signedString, @"RSA"];
     
     [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
     }];
     }
     */
}


- (void)aliPayWithOrderStr:(NSString *)orderStr callback:(AliPayCallBack*)callBack{
    
    
    //严格来说，一般私钥由服务器生成并返回
    //【特别注意，同步结果校验的逻辑，必须放在服务端处理，切记不要放在客户端】【强烈建议商户直接依赖服务端的异步通知，忽略同步返回】
    //对获取的返回结果数据进行处理
    //商户在客户端同步通知接收模块或服务端异步通知接收模块获取支付宝返回的结果数据后，可以结合商户自身业务逻辑进行数据处理（如：订单更新、自动充值到会员账号中等）。同步通知结果仅用于结果展示，入库数据需以异步通知为准。
    //异步即一个网络请求为准
    
    //应用注册scheme,在Info.plist定义URL types
    NSString *appScheme = @"demoscheme";
    
    if ( (orderStr==nil) || (orderStr.length == 0) ) {
        //签名私钥出错
        return;
        
    }

    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        /**
         *  同步返回结果
         *  resultStatus={9000};        状态代码
         *  memo={};                    提示信息
         *  result={partner="2088101568358171"&seller_id="xxx@alipay.com"&out_trade_no="0819145412-6177"&subject="测试"&body="测试测试"&total_fee="0.01"&notify_url="http://notify.msp.hk/notify.htm"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&success="true"&sign_type="RSA"&sign="hkFZr+zE9499nuqDNLZEF7W75RFFPsly876QuRSeN8WMaUgcdR00IKy5ZyBJ4eldhoJ/2zghqrD4E2G2mNjs3aE+HCLiBXrPDNdLKCZgSOIqmv46TfPTEqopYfhs+o5fZzXxt34fwdrzN4mX6S13cr3UwmEV4L3Ffir/02RBVtU="}
             以上为本次操作返回的结果数据
         *
         */
        BOOL success = NO;
        NSNumber *resultStatus = [resultDic objectForKey:@"resultStatus"];
        
        if ([resultStatus isKindOfClass:[NSNumber class]] || [resultStatus isKindOfClass:[NSString class]]) {
            if (AliPayReturnStatusSuccess == resultStatus.integerValue) {
                success = YES;
            }else{
                success = NO;
            }
        }
        
        if (!success) {
            NSString *memo = [resultDic objectForKey:@"memo"];
            NSLog(@"memo = %@",memo);
        }else {
            
        }
        //回调
        if (callBack) {
            callBack(YES,resultDic);
        }
        
    }];
}

#pragma mark   ==============产生随机订单号==============

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
