//
//  ViewController.m
//  TestWifi
//
//  Created by Nemo on 2024/6/9.
//

#import "ViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CoreLocation.h>
#import <NetworkExtension/NetworkExtension.h>
#import <CoreData/CoreData.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];

    // 配置 WiFi 网络
    [self configureWiFi];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        NSString *ssid = [self fetchSSIDInfo];
        if (ssid) {
            NSLog(@"Connected WiFi SSID: %@", ssid);
        } else {
            NSLog(@"Not connected to WiFi");
        }
    } else {
        NSLog(@"Location permission not granted");
    }
}



- (NSString *)fetchSSIDInfo {
    NSArray *interfaces = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSDictionary *SSIDInfo = nil;
    for (NSString *interface in interfaces) {
        SSIDInfo = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)interface);
        if (SSIDInfo && [SSIDInfo count]) {
            break;
        }
    }
    NSString *SSID = SSIDInfo[(NSString *)kCNNetworkInfoKeySSID];
    return SSID;
}

- (void)configureWiFi {
    NSString *ssid = @"YourWiFiNetwork";
    NSString *password = @"YourWiFiPassword";

    // 创建 WiFi 配置
    NEHotspotConfiguration *configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid passphrase:password isWEP:NO];
    configuration.joinOnce = YES;


    // 应用配置
    [[NEHotspotConfigurationManager sharedManager] applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            if (error.code == NEHotspotConfigurationErrorAlreadyAssociated) {
                NSLog(@"设备已连接到指定的 WiFi 网络");
            } else {
                NSLog(@"配置 WiFi 失败: %@", error.localizedDescription);
            }
        } else {
            NSLog(@"配置 WiFi 成功");
        }
    }];
}

- (void)showWiFiSettings {
    // 由于直接列出所有Wi-Fi不可行，可以引导用户去系统设置中选择
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}
@end
