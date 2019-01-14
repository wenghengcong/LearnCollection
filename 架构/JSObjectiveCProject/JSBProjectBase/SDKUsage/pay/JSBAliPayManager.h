//
//  JSBPayManager.h
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/20.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjAliOrder.h"

typedef void(AliPayCallBack)(BOOL retrunStatus,NSDictionary *resultDic);

/**
 *  支付宝：
 文档中心：https://doc.open.alipay.com/doc2/detail.htm?spm=0.0.0.0.gjmRRl&treeId=59&articleId=103563&docType=1
 
 */

@interface JSBAliPayManager : NSObject

- (void)aliPayWithOrderStr:(NSString *)orderStr callback:(AliPayCallBack*)callBack;

@end
