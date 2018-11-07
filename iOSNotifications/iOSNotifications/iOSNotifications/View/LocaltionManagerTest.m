//
//  LocaltionManagerTest.m
//  iOSNotifications
//
//  Created by WengHengcong on 2017/3/20.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//

#import "LocaltionManagerTest.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface LocaltionManagerTest()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLGeocoder *geoC;
@property (nonatomic, strong) CLLocationManager *mylocationManager;

@end

@implementation LocaltionManagerTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initLocationManager];
    }
    
    return self;
}

- (void)checkLocaltionEnable
{
    if ([CLLocationManager locationServicesEnabled]){
        NSLog(@"Location Services Enabled");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            NSLog(@"kCLAuthorizationStatusNotDetermined");

        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
            NSLog(@"kCLAuthorizationStatusRestricted");

        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            NSLog(@"kCLAuthorizationStatusDenied");

        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
            NSLog(@"kCLAuthorizationStatusAuthorizedAlways");

        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");

        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized){
            NSLog(@"kCLAuthorizationStatusAuthorized");

        }
    }else{
        NSLog(@"Location Services Unabled");
    }
}

- (void)initLocationManager
{
    [self checkLocaltionEnable];
    if (nil == self.mylocationManager)
        self.mylocationManager = [[CLLocationManager alloc] init];
    
    self.mylocationManager.delegate = self;
    //设置定位的精度
    /**
     kCLLocationAccuracyBestForNavigation // 最适合导航
     kCLLocationAccuracyBest; // 最好的
     kCLLocationAccuracyNearestTenMeters; // 10m
     kCLLocationAccuracyHundredMeters; // 100m
     kCLLocationAccuracyKilometer; // 1000m
     kCLLocationAccuracyThreeKilometers; // 3000m
     */
    self.mylocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    //设置定位服务更新频率
    self.mylocationManager.distanceFilter = 500;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
    {
        
        [self.mylocationManager requestWhenInUseAuthorization];// 前台定位
        NSLog(@"当前的版本是%f",[[[UIDevice currentDevice] systemVersion] doubleValue]);
        
        //[mylocationManager requestAlwaysAuthorization];// 前后台同时定位
        
        /**
         info.plist文件中配置对应的键值， 否则以上请求授权的方法不生效
         NSLocationAlwaysUsageDescription : 允许在前后台获取GPS的描述
         NSLocationWhenInUseDescription : 允许在前台获取GPS的描述
         */
    }
    
    //开始更新用户位置
    [self.mylocationManager startUpdatingLocation];
    /**
     //判断定位功能是否可用(为了严谨起见，最好在使用定位功能前进行判断)
     BOOL serviceEnable = [self.mylocationManager locationServicesEnabled];
     
     //停止更新用户位置
     [self.mylocationManager stopUpdatingLocation];
     
     //监听设备朝向
     [self.mylocationManager startUpdatingHeading];
     [self.mylocationManager stopUpdatingHeading];
     */
    
    [self checkLocaltionEnable];
}


-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

#pragma mark - 位置监听

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"FlyElephant-http://www.cnblogs.com/xiaofeixiang");
}

/**
 *  更新到位置之后调用
 *
 *  @param manager   位置管理者
 *  @param locations 位置数组
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //获取最新的位置
    /**
     *  CLLocation 详解
     *  coordinate : 经纬度
     *  altitude : 海拔
     *  course : 航向
     *  speed ; 速度
     */
    CLLocation * currentLocation = [locations lastObject];
    CLLocationDegrees latitude=currentLocation.coordinate.latitude;
    CLLocationDegrees longitude=currentLocation.coordinate.longitude;
    
    // 1. 获取方向偏向
    NSString *angleStr = nil;
    
    switch ((int)currentLocation.course / 90) {
        case 0:
            angleStr = @"北偏东";
            break;
        case 1:
            angleStr = @"东偏南";
            break;
        case 2:
            angleStr = @"南偏西";
            break;
        case 3:
            angleStr = @"西偏北";
            break;
            
        default:
            angleStr = @"跑沟里去了!!";
            break;
    }
    
    // 2. 偏向角度
    NSInteger angle = 0;
    angle = (int)currentLocation.course % 90;
    
    // 代表正方向
    if (angle == 0) {
        NSRange range = NSMakeRange(0, 1);
        angleStr = [NSString stringWithFormat:@"正%@", [angleStr substringWithRange:range]];
    }
    
    NSLog(@"didUpdateLocations当前位置的纬度:%.2f--经度%.2f",latitude,longitude);
    
    //    [manager stopUpdatingLocation];
    
    //3.地理反编码
    [self reverseGeoCoder:currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLLocationDegrees latitude=newLocation.coordinate.latitude;
    CLLocationDegrees longitude=oldLocation.coordinate.longitude;
    NSLog(@"didUpdateToLocation当前位置的纬度:%.2f--经度%.2f",latitude,longitude);
}

#pragma mark - 用户授权监听

/**
 *  授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
            break;
        }
            // 问受限
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled])
            {
                NSLog(@"定位开启，但被拒");
            }else
            {
                NSLog(@"定位关闭，不可用");
            }
            //            NSLog(@"被拒");
            break;
        }
            // 获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
            //        case kCLAuthorizationStatusAuthorized: // 失效，不建议使用
        {
            NSLog(@"获取前后台定位授权");
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
}

#pragma mark - 朝向监听

/**
 *  简易指南针的实现
 *  手机朝向改变时调用
 *
 *  @param manager    位置管理者
 *  @param newHeading 朝向对象
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    /**
     *  CLHeading
     *  magneticHeading : 磁北角度
     *  trueHeading : 真北角度
     */
    
    NSLog(@"%f", newHeading.magneticHeading);
    
    CGFloat angle = newHeading.magneticHeading;
    
    // 把角度转弧度
    CGFloat angleR = angle / 180.0 * M_PI;
    
    // 旋转图片(指南针图片)
    [UIView animateWithDuration:0.25 animations:^{
        //        self.compassView.transform = CGAffineTransformMakeRotation(-angleR);
    }];
}


#pragma mark - 区域监听
/**
 *   进入区域
 *
 *  @param manager 位置管理
 *  @param region  区域
 */
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"进入区域--%@", region.identifier);
}

/**
 *  离开区域
 *
 *  @param manager 位置管理
 *  @param region  区域
 */
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"离开区域--%@", region.identifier);
}

/**
 *  监听是否在某个区域的状态
 *
 *  @param manager 位置管理
 *  @param state   状态（区域内/外）
 *  @param region  区域
 */
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    //state的值
    //CLRegionStateUnknown,
    //CLRegionStateInside,
    //CLRegionStateOutside
    NSLog(@"%zd", state);
}

#pragma mark - 地理编码

/**
 *  地理编码(地址转经纬度)
 */
- (void)geoCoder {
    
    NSString *address = @"";
    
    // 容错
    if([address length] == 0)
        return;
    
    [self.geoC geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        // CLPlacemark : 地标
        // location : 位置对象
        // addressDictionary : 地址字典
        // name : 地址详情
        // locality : 城市
        
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];;
            
            NSLog(@"address:%@-latitude:%@-longtitude:%@",pl.name,@(pl.location.coordinate.latitude).stringValue,@(pl.location.coordinate.longitude).stringValue);
        }else
        {
            NSLog(@"错误");
        }
    }];
}

#pragma mark - 反地理编码

/**
 *  反地理编码(经纬度---地址)
 *
 *  @param location 位置
 */
- (void)reverseGeoCoder:(CLLocation *)location {
    
    [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            CLLocation * location = pl.location;    //<+31.25208831,+121.42939760> +/- 100.00m (speed -1.00 mps / course -1.00) @ 16/5/8 中国标准时间 19:58:54
            CLRegion * region = pl.region;  //identifier:'<+31.25208350,+121.42937100> radius 197.13', center:<+31.25208350,+121.42937100>, radius:197.13m)
            NSTimeZone * timezone = pl.timeZone;        //Asia/Shanghai (GMT+8) offset 28800
            NSDictionary *addressDic = pl.addressDictionary;
            /**
             +31.25208831,+121.42939760 +/- 100.00m (speed -1.00 mps / course -1.00) @ 16/5/8 中国标准时间 19:58:54
             <+31.25208350,+121.42937100> radius 197.13', center:<+31.25208350,+121.42937100>, radius:197.13m
             Asia/Shanghai (GMT+8) offset 28800
             City = "上海市";
             Country = "中国";
             CountryCode = CN;
             FormattedAddressLines =     (
             "中国上海市普陀区石泉路街道中山北路1589号"
             );
             Name = "中国上海市普陀区石泉路街道中山北路1589号";
             State = "上海市";
             Street = "中山北路1589号";
             SubLocality = "普陀区";
             SubThoroughfare = "1589号";
             Thoroughfare = "中山北路";
             */
            NSString *name = pl.name;       //中国上海市普陀区石泉路街道中山北路1589号
            NSString *thoroughfare = pl.thoroughfare;   //通路:中山北路
            NSString *subThoroughfare = pl.subThoroughfare;     //指定街道级别的附加信息:1589号
            NSString *locality = pl.locality;           //城市:上海市
            NSString *subLocality = pl.subLocality;     //指定城市信息附加信息:普陀区
            NSString *administrativeArea = pl.administrativeArea;       //行政区域：上海市
            NSString *subAdministrativeArea = pl.subAdministrativeArea;     //nil
            NSString *postalCode = pl.postalCode;                   //邮编：nil
            NSString *ISOcountryCode = pl.ISOcountryCode;           //国家编码：CN
            NSString *country = pl.country;                         //国家：中国
            NSString *inlandWater = pl.inlandWater;                 //
            NSString *ocean = pl.ocean;                             //
            NSArray *areasOfInterest = pl.areasOfInterest;          //nil
            
        }else
        {
            NSLog(@"错误");
        }
    }];
}



@end
