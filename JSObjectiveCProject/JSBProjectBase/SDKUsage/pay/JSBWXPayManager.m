//
//  JSBWXPayManager.m
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/20.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBWXPayManager.h"

@implementation JSBWXPayManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static JSBWXPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[JSBWXPayManager alloc] init];
    });
    return instance;
}

- (void)wxPayWithOrderStr:(PayReq *)payReq callback:(WxPayCallBack*)callBack {
    
    if (payReq != nil) {
    
        //发送请求到微信，等待微信返回onResp
        if ([WXApi sendReq:payReq]) {
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",@"appid",payReq.partnerId,payReq.prepayId,payReq.nonceStr,(long)payReq.timeStamp,payReq.package,payReq.sign );
            
        }else {
            NSLog(@"error");

        }
    }

}

#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req {
    
}
-(void) onResp:(BaseResp*)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
