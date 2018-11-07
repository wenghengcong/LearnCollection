//
//  AliOrder.h
//  JSBProjectBase
//
//  Created by WengHengcong on 16/1/20.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjAliOrder : NSObject
/*
 *商户的唯一的parnter和seller。
 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
 */
@property(nonatomic, copy) NSString * partner;
/***  合作者身份ID*/
@property(nonatomic, copy) NSString * seller;
/***  订单ID（由商家自行制定）*/
@property(nonatomic, copy) NSString * tradeNO;
/***  商品标题*/
@property(nonatomic, copy) NSString * productName;
/***  商品描述 */
@property(nonatomic, copy) NSString * productDescription;
/***  商品价格*/
@property(nonatomic, copy) NSString * amount;
/***  回调URL*/
@property(nonatomic, copy) NSString * notifyURL;
/***  接口名称*/
@property(nonatomic, copy) NSString * service;
/***  支付类型。默认值为：1（商品购买）*/
@property(nonatomic, copy) NSString * paymentType;
/***  参数编码字符集*/
@property(nonatomic, copy) NSString * inputCharset;
/***  未付款交易的超时时间*/
@property(nonatomic, copy) NSString * itBPay;
/****/
@property(nonatomic, copy) NSString * showUrl;
/****/
@property(nonatomic, copy) NSString * rsaDate;//可选
/***  客户端号*/
@property(nonatomic, copy) NSString * appID;//可选
/***  商户业务扩展参数*/
@property(nonatomic, readonly) NSMutableDictionary * extraParams;

@end
