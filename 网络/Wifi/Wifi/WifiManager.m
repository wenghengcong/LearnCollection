//
//  hvGateway.m
//  appMaker
//
//  Created by leo on 13-11-11.
//  Copyright (c) 2013年 heimavista.com. All rights reserved.
//

#import "WifiManager.h"
#import "getgateway.h"

#include <sys/socket.h>
//for ifaddrs
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation WifiManager

@synthesize wifiBroadcastAddress = _wifiBroadcastAddress;
@synthesize wifiGateWay = _wifiGateWay;
@synthesize wifiInterface = _wifiInterface;
@synthesize wifiIP = _wifiIP;
@synthesize wifiNetMast = _wifiNetMast;

- (NSDictionary *) getWifiInformation
{
	NSMutableDictionary * wifiInformation = [[NSMutableDictionary alloc] init];
	_wifiGateWay = [NSString stringWithFormat:@"%@",[self defaultGateWay]];
	
	if (_wifiGateWay == nil) {
		_wifiGateWay = [NSString stringWithFormat:@"%@",@""];
	}
	if (_wifiBroadcastAddress == nil) {
		_wifiBroadcastAddress = [NSString stringWithFormat:@"%@",@""];
	}
	if (_wifiIP == nil) {
		_wifiIP = [NSString stringWithFormat:@"%@",@""];
	}
	if (_wifiInterface == nil) {
		_wifiInterface = [NSString stringWithFormat:@"%@",@""];
	}
	if (_wifiNetMast == nil) {
		_wifiNetMast = [NSString stringWithFormat:@"%@",@""];
	}
	[wifiInformation setObject:_wifiBroadcastAddress forKey:WifiBroadcastAddress];
	[wifiInformation setObject:_wifiInterface forKey:WifiInterface];
	[wifiInformation setObject:_wifiIP forKey:WifiIP];
	[wifiInformation setObject:_wifiGateWay forKey:WifiGateWay];
	[wifiInformation setObject:_wifiNetMast forKey:WifiNetMast];
	return wifiInformation;
}

#pragma mark - 
#pragma makr - wifi methods
- (NSString *) defaultGateWay
{
	NSString * vlcGateWay;
	NSString* routerIP= [self routerIp];
	NSLog(@"local device ip address----%@",routerIP);
	
	
	in_addr_t i =inet_addr([routerIP cStringUsingEncoding:NSUTF8StringEncoding]);
	in_addr_t* x =&i;
	char * r= getdefaultgateway(x);
	
	//char*转换为NSString
	vlcGateWay = [[NSString alloc] initWithFormat:@"%s",r];
	NSLog(@"gateway: %@",vlcGateWay);
	return vlcGateWay;
}

//返回广播地址，利用广播地址获取网关
- (NSString *) routerIp {
	
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					// Get NSString from C String //ifa_addr
					//ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
					//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
					
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					
					//routerIP----192.168.1.255 广播地址
					NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
					_wifiBroadcastAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
					
					//--192.168.1.106 本机地址
					NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
					_wifiIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					
					//--255.255.255.0 子网掩码地址
					NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
					_wifiNetMast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
					
					//--en0 端口地址
					NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
					_wifiInterface = [NSString stringWithUTF8String:temp_addr->ifa_name];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}


@end
