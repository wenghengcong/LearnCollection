//
//  hvGateway.h
//  appMaker
//
//  Created by leo on 13-11-11.
//  Copyright (c) 2013年 heimavista.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define WifiGateWay						@"gateway"
#define WifiIP								@"ip"
#define WifiBroadcastAddress			@"broadcast"
#define WifiNetMast						@"netmast"
#define WifiInterface					@"interface"

@interface WifiManager: NSObject
{
	NSString * _wifiGateWay; //网关
	NSString * _wifiIP;   //IP
	NSString * _wifiBroadcastAddress;   //广播地址
	NSString * _wifiNetMast;    //子网掩码
	NSString * _wifiInterface;  //en0端口
}

@property (nonatomic,copy,readonly) NSString * wifiGateWay;
@property (nonatomic,copy,readonly) NSString * wifiIP;
@property (nonatomic,copy,readonly) NSString * wifiBroadcastAddress;
@property (nonatomic,copy,readonly) NSString * wifiNetMast;
@property (nonatomic,copy,readonly) NSString * wifiInterface;

- (NSMutableDictionary *) getWifiInformation;

@end
