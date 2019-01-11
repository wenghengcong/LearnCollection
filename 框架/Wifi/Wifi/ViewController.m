//
//  ViewController.m
//  Wifi
//
//  Created by WengHengcong on 2017/3/3.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

#import "ViewController.h"
#import "SimplePing.h"
#import <SystemConfiguration/CaptiveNetwork.h>

//
#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>

#import "getgateway.h"

@interface ViewController ()<SimplePingDelegate>

@property (nonatomic ,strong) SimplePing *pinger;
@property (nonatomic ,copy) NSString *hostName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.hostName = @"m.baidu.com";
    [self ping];
    [self getWifiInfo];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Ping

- (void)ping
{
    SimplePing *pinger = [[SimplePing alloc] initWithHostName:self.hostName];
    self.pinger = pinger;
    
    pinger.delegate = self;
    pinger.addressStyle = SimplePingAddressStyleICMPv4;
    [pinger start];
}

/**
 *  start成功，也就是准备工作做完后的回调
 */
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    // 发送测试报文数据
    [self.pinger sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@",error);
    [self.pinger stop];
}

// 发送测试报文成功的回调方法
- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    NSLog(@"#%u sent", sequenceNumber);
}

//发送测试报文失败的回调方法
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    NSLog(@"#%u send failed: %@", sequenceNumber, error);
}

// 接收到ping的地址所返回的数据报文回调方法
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    NSLog(@"#%u received, size=%zu", sequenceNumber, packet.length);
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    NSLog(@"#%s",__func__);
}

#pragma mark - Wifi

- (void)getWifiInfo
{
    NSDictionary *ssidInfo = [self fetchSSIDInfo];
    NSLog(@"ssidInfo    %@",ssidInfo);
    
    NSString *wifiName = [self wifiName];
    NSLog(@"wifi name   %@",wifiName);
    
    NSString *gateway = [self getGatewayIpForCurrentWiFi];
    NSLog(@"gateway   %@",gateway);

    NSString *ip = [self getGatewayIpForCurrentWiFi];
    NSLog(@"ip   %@",ip);

    NSDictionary *moreInfo = [self getLocalInfoForCurrentWiFi];
    NSLog(@"moreInfo    %@",moreInfo);
    
    [self getSignalStrength];
}

//获取WiFi 信息，返回的字典中包含了WiFi的名称、路由器的Mac地址、还有一个Data(转换成字符串打印出来是wifi名称)
- (NSDictionary *)fetchSSIDInfo {
    
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

- (NSString *)wifiName
{
    NSDictionary *ssidInfo = [self fetchSSIDInfo];
    NSString *wifiName = ssidInfo[@"SSID"];
    return wifiName;
}

#pragma mark - More Wifi Info

/**
 WiFi的网关地址
 */
- (NSString *)getGatewayIpForCurrentWiFi {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL) {
            /*/
             int i=255;
             while((i--)>0)
             //*/
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    //ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    //routerIP----192.168.1.255 广播地址
                    NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    //--192.168.1.106 本机地址
                    NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    //--255.255.255.0 子网掩码地址
                    NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    //--en0 端口地址
                    NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                    
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    in_addr_t i = inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x = &i;
    
    char *s = getdefaultgateway(x);
    NSString *ip=   [[NSString alloc] initWithFormat:@"%s",s];
    return ip;
}

/**
 本机在WiFi环境下的IP地址
 */
- (NSString *)getLocalIPAddressForCurrentWiFi
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    return address;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        freeifaddrs(interfaces);
    }
    return nil;
}


/**
 获取广播地址、子网掩码、端口
 */
- (NSMutableDictionary *)getLocalInfoForCurrentWiFi {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    //----192.168.1.255 广播地址
                    NSString *broadcast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    if (broadcast) {
                        [dict setObject:broadcast forKey:@"broadcast"];
                    }
                    NSLog(@"broadcast address--%@",broadcast);
                    //--192.168.1.106 本机地址
                    NSString *localIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    if (localIp) {
                        [dict setObject:localIp forKey:@"localIp"];
                    }
                    NSLog(@"local device ip--%@",localIp);
                    //--255.255.255.0 子网掩码地址
                    NSString *netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    if (netmask) {
                        [dict setObject:netmask forKey:@"netmask"];
                    }
                    NSLog(@"netmask--%@",netmask);
                    //--en0 端口地址
                    NSString *interface = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    if (interface) {
                        [dict setObject:interface forKey:@"interface"];
                    }
                    NSLog(@"interface--%@",interface);
                    return dict;
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return dict;
}

/**
 获取Wifi信号强度
 */
- (void)getSignalStrength{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
    
    NSLog(@"signal %d", signalStrength);
}


- (void)getNetworkType
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    for (id subview in subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    NSLog(@"NONE");
                    break;
                case 1:
                    NSLog(@"2G");
                    break;
                case 2:
                    NSLog(@"3G");
                    break;
                case 3:
                    NSLog(@"4G");
                    break;
                case 5:
                {
                    NSLog(@"WIFI");
                }
                    break;
                default:
                    break;
            }
        }
    }
}

@end
