//
//  NotificationViewController.m
//  NotificationContent
//
//  Created by WengHengcong on 2017/1/4.
//  Copyright © 2017年 WengHengcong. All rights reserved.
//

#import "NotificationViewController.h"

/*
 
 The UNNotificationContentExtension protocol provides the entry point for a Notification Content app extension, which displays a custom interface for your app’s notifications. You adopt this protocol in the custom UIViewController subclass that you use to present your interface. You create this type of extension to improve the way your notifications are presented, possibly by adding custom colors and branding or by incorporating media and other dynamic content into your notification interface.
 
 To define a Notification Content app extension, add a Notification Content extension target to the Xcode project containing your app. The default Xcode template contains a source file and storyboard for your view controller. The Info.plist file of the extension comes mostly configured. Specifically, the NSExtensionPointIdentifier key is set to the value com.apple.usernotifications.content-extension and the NSExtensionMainStoryboard key is set to the name of the project’s storyboard file. However, the NSExtensionAttribute key contains a dictionary of additional keys and values, some of which you must configure manually:
 
 UNNotificationExtensionCategory. (Required) The value of this key is a string or an array of strings. Each string contains the identifier of a category declared by the app using the UNNotificationCategory class.
 
 UNNotificationExtensionInitialContentSizeRatio. (Required) The value of this key is a floating-point number that represents the initial size of your view controller’s view expressed as a ratio of its height to its width. The system uses this value to set the initial size of the view controller while your extension is loading. For example, a value of 0.5 results in a view controller whose height is half its width. You can change the size of your view controller after your extension loads.
 
 UNNotificationExtensionDefaultContentHidden. (Optional) The value of this key is a Boolean. When set to YES, the system displays only your custom view controller in the notification interface. When set to NO, the system displays the default notification content in addition to your view controller’s content. Custom action buttons and the Dismiss button are always displayed, regardless of this setting. If you do not specify this key, the default value is set to NO.
 
 
 
 UNNotificationExtensionDefaultContentHidden          YES，就会隐藏通知的头部与尾部
 UNNotificationExtensionCategory                      对应的Category，是一个字符串数组，定义后，可以根据
 UNNotificationExtensionInitialContentSizeRatio       高度/宽度=ratio,该比例是基于sb文件中定制好的。
 
 NSExtensionMainStoryboard                            storyboard文件的名字
 NSExtensionPointIdentifier                           Notification Content的bundle id
 
 注意：category必须和Info.plist中的UNNotificationExtensionCategory一致。
 
 */



/*
 
 apns payload test demo
 
 {
    "aps": {
        "alert": {
            "title": "斯沃驰2016秋冬系列华丽上市",
            "body": "Swatch推出Magies D'Hiver系列新品！"
        },
        "sound": "default",
        "category": "pictureCat",
        "mutable-content": 1
    },
    "isqImgPath": "https://cdn.pixabay.com/photo/2017/01/06/22/24/giraffe-1959110_1280.jpg",
    "tImgPath": "https://cdn.pixabay.com/photo/2017/01/06/22/24/giraffe-1959110_1280.jpg",
    "title": "斯沃驰2016秋冬系列华丽上市",
    "content": "Swatch推出MagiesD'Hiver系列新品。该系列灵感来源于雪花的结晶构造，技术感十足，配以新潮迷彩色和爱尔兰式粗花呢，宛若置身壁炉旁。"
 }
 
 以上图片若无效，尝试：https://img30.360buyimg.com/EdmPlatform/jfs/t4000/43/1883011713/62578/a8ef6739/589ac88dNdacd97ed.jpg
 
 */

//内容
static NSString *forceTouchImageKey = @"tImgPath";
static NSString *forceTouchTitleKey = @"title";
static NSString *forceTouchContentKey = @"content";

static NSString *forceTouchCategoryPic = @"pictureCat";
static NSString *forceTouchCategoryLogistics = @"logisticsCategory";
static NSString *forceTouchCategoryDiscount = @"discountCategory";
static NSString *forceTouchCategoryDefault = @"defaultCat";

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    //    self.botText.numberOfLines = 3;
    self.view.backgroundColor = [UIColor clearColor];
    self.blurtImageV.hidden = YES;
    self.showImageV.backgroundColor = [UIColor clearColor];
    self.showImageV.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self.view bringSubviewToFront:self.blurtImageV];
    
    [self.starButton addTarget:self action:@selector(starButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.starButton];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion
{
    // Get the meeting ID from the original notification.
    NSDictionary *userinfo = response.notification.request.content.userInfo;
    NSString *actionIdentifier = response.actionIdentifier;
    if ([actionIdentifier isEqualToString:@"goodAction"]) {
        
        UNNotificationAction *goodDetailAction = [UNNotificationAction actionWithIdentifier:@"goodDetailAction" title:@"去商品详情看看" options:UNNotificationActionOptionForeground];
        if (@available(iOS 12.0, *)) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 120000) )
            NSArray *currentActions = self.extensionContext.notificationActions;
            if (currentActions.count > 1) {
                UNNotificationAction *badAction = currentActions[1];
                NSArray *newActionList = @[goodDetailAction, badAction];
                self.extensionContext.notificationActions = newActionList;
                
            }
#endif
        } else {
            // Fallback on earlier versions
        }
        
        completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
    } else if ([actionIdentifier isEqualToString:@"badAction"]) {
        if (@available(iOS 12.0, *)) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 120000) )
            //必须要调用该行，才会使得该页面消失
            [self.extensionContext dismissNotificationContentExtension];
#endif
        } else {
            // Fallback on earlier versions
        }
        completion(UNNotificationContentExtensionResponseOptionDismiss);
    } else if ([actionIdentifier isEqualToString:@"acceptAction"]) {
        
        completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
    } else if ([actionIdentifier isEqualToString:@"rejectAction"]) {

        completion(UNNotificationContentExtensionResponseOptionDismiss);
    } else if ([actionIdentifier isEqualToString:@"goodDetailAction"]) {
        if (@available(iOS 12.0, *)) {
            //默认交给宿主app处理
//            [self.extensionContext performNotificationDefaultAction];
        } else {
            // Fallback on earlier versions
        }
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    }
    
}

- (void)starButtonAction
{
    self.starButton.selected = !self.starButton.selected;
    NSString *starStr = @"（已收藏）";
    NSString *oriContent = self.contentLabel.text;
    if (self.starButton.selected) {
        if (![oriContent containsString:starStr]) {
            NSString *starContent = [NSString stringWithFormat:@"%@ %@",starStr, oriContent];
            self.contentLabel.text = starContent;
        }
    } else {
        if ([oriContent containsString:starStr]) {
            NSMutableString *mut = [oriContent mutableCopy];
            NSString *starContent = [mut stringByReplacingOccurrencesOfString:starStr withString:@""];
            self.contentLabel.text = starContent;
        }
    }
}

/**
 处理收到的通知
 */
- (void)didReceiveNotification:(UNNotification *)notification {
    
    //后加载didReceiveNotification
    /*
     注意加载图片的机制，要么在NotificationContent中文件夹中放置对应的图片
     */
    
    if ( (notification == nil) || (notification.request == nil) || (notification.request.content == nil) || (notification.request.content.userInfo) == nil) {
        return;
    }
    
    NSString *categoryId = notification.request.content.categoryIdentifier;
    __weak __typeof__(self) weakSelf = self;
    
    if ([categoryId isEqualToString:forceTouchCategoryPic] || [categoryId isEqualToString:forceTouchCategoryLogistics]
        || [categoryId isEqualToString:forceTouchCategoryDiscount]) {
        
        NSString *pushTitle = notification.request.content.userInfo[forceTouchTitleKey];
        NSString *pushContent = notification.request.content.userInfo[forceTouchContentKey];
        self.titleLabel.text = pushTitle;
        self.contentLabel.text = pushContent;
        [self defaultCategoryLayoutView];
        
        __strong __typeof__(self) strongSelf = weakSelf;
        //注意：image读取的层次结构
        NSString *urlFromNoti = notification.request.content.userInfo[forceTouchImageKey];
        if (strongSelf) {
            if (urlFromNoti) {
                [self downloadImageWithURL:urlFromNoti withCompletedHanlder:^(NSURL *fileUrl, NSData *data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data==nil) {
                            // [strongSelf defaultCategoryLayoutView];
                        }else{
                            UIImage *image = [UIImage imageWithData:data];
                            if (image) {
                                strongSelf.showImageV.image = [UIImage imageWithData:data] ;
                                [strongSelf pictureCategoryLayoutView];
                            }else{
                                // [strongSelf defaultCategoryLayoutView];
                            }
                        }
                    });
                    
                }];
            }else{
                [self defaultCategoryLayoutView];
            }
        }
        
    }else {
        
        NSString *pushTitle = @"手机京东";
        NSDictionary *aps = notification.request.content.userInfo[@"aps"];
        NSString *pushContent = nil;
        if (aps) {
            id alert = [aps objectForKey:@"alert"];
            if ( alert && [alert isKindOfClass:[NSString class]]) {
                pushContent = alert;
            }else if (alert && [alert isKindOfClass:[NSDictionary class]]){
                pushContent = [alert objectForKey:@"body"];
            }else{
                pushContent = @"";
            }
        }else{
            pushContent = @"";
        }
        self.titleLabel.text = pushTitle;
        self.contentLabel.text = pushContent;
        [self defaultCategoryLayoutView];
    }
    
}

#pragma mark -

/**
 默认无图的样式布局
 */
- (void)defaultCategoryLayoutView
{
    //    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 100);
    
    CGFloat fixH = [self.contentLabel sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)].height;
    
    if (fixH > 47.0) {
        fixH = 47.0;
        self.contentTop.constant = 2;
        self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 100);
    }else{
        CGFloat subHeight = 47-fixH;
        self.contentTop.constant = -1;
        self.contentHeight.constant = fixH;
        self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 100-subHeight);
    }
    
    self.blurtImageV.hidden = YES;
    self.imageHeight.constant = 0;
    self.blurImageH.constant = 0;
    [self.view layoutIfNeeded];
}

/**
 大图样式布局
 */
- (void)pictureCategoryLayoutView
{
    //    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 245);
    CGFloat fixH = [self.contentLabel sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)].height;
    
    if (fixH > 47.0) {
        fixH = 47.0;
        self.contentTop.constant = 10;
        self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 245);
    }else{
        CGFloat subHeight = 47-fixH;
        self.contentTop.constant = 7;
        self.contentHeight.constant = fixH;
        self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 245-subHeight);
    }
    
    self.blurtImageV.hidden = NO;
    self.imageHeight.constant = 138;
    self.blurImageH.constant = 138;
    [self.view layoutIfNeeded];
}


/**
 图片下载
 
 @param urlStr <#urlStr description#>
 @param completedHanlder <#completedHanlder description#>
 */
- (void)downloadImageWithURL:(NSString *)urlStr withCompletedHanlder:(void  (^)(NSURL *fileUrl , NSData *data))completedHanlder
{
    if (urlStr) {
        
        NSURL *url = [NSURL URLWithString:urlStr];
        if (!url) {
            return;
        }
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error == nil) {
                
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                if (documentsDirectoryURL) {
                    NSString *imageName = [response suggestedFilename];
                    documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:imageName];
                    
                    if (data && documentsDirectoryURL) {
                        if (completedHanlder) {
                            completedHanlder(documentsDirectoryURL,data);
                        }
                    }
                }
                
            }else{
                if (completedHanlder) {
                    completedHanlder(nil,nil);
                }
            }
            
        }];
        
        [task resume];
    }
}

@end
