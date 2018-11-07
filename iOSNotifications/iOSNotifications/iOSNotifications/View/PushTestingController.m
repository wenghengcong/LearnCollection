//
//  PushTestingController.m
//  iOSNotifications
//
//  Created by WengHengcong on 2016/12/14.
//  Copyright © 2016年 WengHengcong. All rights reserved.
//

#import "PushTestingController.h"
#import "LocaltionManagerTest.h"
#import "AppDelegate.h"

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
@interface PushTestingController ()<UITextFieldDelegate,JSServiceDelegate,UNUserNotificationCenterDelegate>
#else
@interface PushTestingController ()<UITextFieldDelegate>

#endif

/**
 各类开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pictureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mutipleSwtich;
@property (weak, nonatomic) IBOutlet UISwitch *slientSwitch;

@property (strong, nonatomic) NSArray   *switchArr;
/**
 时间轴
 */
@property (weak, nonatomic) IBOutlet UISlider *timeSlide;
@property (weak, nonatomic) IBOutlet UILabel *timeDesL;

/**
 输入ID文本框
 */
@property (weak, nonatomic) IBOutlet UITextField *notiIdenLbl;

@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@property (strong ,nonatomic) LocaltionManagerTest *localTest;

@end

@implementation PushTestingController

#pragma mark - View



- (void)loadView {
    
    [super loadView];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC loadView"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mutipleSwtich.on = NO;
    self.pictureSwitch.on = NO;
    self.videoSwitch.on = NO;
    self.soundSwitch.on = NO;
    self.slientSwitch.on = NO;
    self.logLabel.numberOfLines = 0;
    self.notiIdenLbl.delegate = self;
    //    [JSPushService sharedManager].delegate = self;
    
    self.switchArr = [NSArray arrayWithObjects:self.mutipleSwtich,self.pictureSwitch,self.videoSwitch,self.slientSwitch, nil];
    [self registerRemote];
    
    self.localTest = [[LocaltionManagerTest alloc] init];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewDidLoad"];
    
    //TODO:是否要将通知处理的代理，设置为当前类
//    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewWillAppear"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewDidAppear"];
    
}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewWillLayoutSubviews"];
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewDidLayoutSubviews"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewWillDisappear"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewDidDisappear"];
    
}

- (void)viewWillUnload {
    
    [super viewWillUnload];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewWillUnload"];
    
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC viewDidUnload"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [appDelegate wirteLogWithString:@"iOSNoti:MasterVC didReceiveMemoryWarning"];
    
}


# pragma mark - Category Test

- (void)alertUserOpenPush
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"允许通知？" message:@"通知打开，及时收到最新的资讯" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"好的", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else{
        [self registerRemote];
    }
}
- (void)registerRemote
{
    if (JSPUSH_IOS_12_0) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //临时授权 UNAuthorizationOptionProvisional
        if (@available(iOS 12.0, *)) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 120000) )
            UNAuthorizationOptions option = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionProvidesAppNotificationSettings | UNAuthorizationOptionProvisional;
            
            [JSPushService registerForRemoteNotificationTypes:option categories:[PushTestingController categoriesAction4Test]];
#endif
        } else {
            // Fallback on earlier versions
        }
    } else if (JSPUSH_IOS_10_0) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [JSPushService registerForRemoteNotificationTypes:7 categories:[PushTestingController categoriesAction4Test]];
    } else {
        [JSPushService registerForRemoteNotificationTypes:7 categories:[PushTestingController categoriesAction4Test]];
    }
    
}

+ (NSSet *)categoriesAction4Test
{
    //HCTEST:
    if (JSPUSH_IOS_12_0) {
        //iOS 10以上，通知代理设置，不设置，代理不调用。
        //在锁屏界面，通知栏，需要点击“查看”，才会显示“接受”、“拒绝”的按钮
        if (@available(iOS 12.0, *)) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 120000) )
            /**第一组按钮*/
            UNNotificationAction *acceptAction = [UNNotificationAction actionWithIdentifier:@"acceptAction" title:@"接受" options:UNNotificationActionOptionDestructive];
            
            UNNotificationAction *rejectAction = [UNNotificationAction actionWithIdentifier:@"rejectAction" title:@"拒绝" options:UNNotificationActionOptionForeground];
            
            //注意，输入的action，点击action后，会在Action列表显示：接受、拒绝、输入你想几点起
            UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"inputAction" title:@"请输入您需要预约配送的时间" options:UNNotificationActionOptionForeground textInputButtonTitle:@"确定" textInputPlaceholder:@"再晚1小时吧"];
            
            //intentIdentifiers: INStartAudioCallIntentIdentifier
            //form <Intents/INIntentIdentifiers.h>
            NSString *summaryFormat = @"%u 条物流通知 商品：%@";
            NSString *hiddenPreviewsPlaceholder = @"%u 消息";
            
            UNNotificationCategory *logisticsCate = [UNNotificationCategory categoryWithIdentifier:@"logisticsCategory" actions:@[acceptAction,rejectAction,inputAction] intentIdentifiers:@[@""] hiddenPreviewsBodyPlaceholder:hiddenPreviewsPlaceholder categorySummaryFormat:summaryFormat options:UNNotificationCategoryOptionCustomDismissAction];
            /**第一组按钮结束**/
            
            /**第二组按钮*/
            
            UNNotificationAction *goodAction = [UNNotificationAction actionWithIdentifier:@"goodAction" title:@"赞" options:UNNotificationActionOptionDestructive];
            
            UNNotificationAction *badAction = [UNNotificationAction actionWithIdentifier:@"badAction" title:@"踩" options:UNNotificationActionOptionForeground];
            
            NSString *disCountSummaryFormat = @"%u 条优惠触达 by%@发布";
            NSString *disCountHdenPreviewsPlaceholder = @"%u 消息";
            UNNotificationCategory *discountCate = [UNNotificationCategory categoryWithIdentifier:@"discountCategory" actions:@[goodAction,badAction] intentIdentifiers:@[@""] hiddenPreviewsBodyPlaceholder:disCountHdenPreviewsPlaceholder categorySummaryFormat:disCountSummaryFormat options:UNNotificationCategoryOptionCustomDismissAction];
            /**第二组按钮结束**/
            NSSet *set = [NSSet setWithObjects:logisticsCate, discountCate,nil];
            return set;
#endif
        } else {
            // Fallback on earlier versions
        }
        
        return nil;
        
    } else if (JSPUSH_IOS_10_0) {
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
        
        //iOS 10以上，通知代理设置，不设置，代理不调用。
        //在锁屏界面，通知栏，需要点击“查看”，才会显示“接受”、“拒绝”的按钮
        
        /**第一组按钮*/
        UNNotificationAction *acceptAction = [UNNotificationAction actionWithIdentifier:@"acceptAction" title:@"接受" options:UNNotificationActionOptionDestructive];
        
        UNNotificationAction *rejectAction = [UNNotificationAction actionWithIdentifier:@"rejectAction" title:@"拒绝" options:UNNotificationActionOptionForeground];
        
        //注意，输入的action，点击action后，会在Action列表显示：接受、拒绝、输入你想几点起
        UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"inputAction" title:@"输入你想几点起" options:UNNotificationActionOptionForeground textInputButtonTitle:@"确定" textInputPlaceholder:@"再晚1小时吧"];
        
        //intentIdentifiers: INStartAudioCallIntentIdentifier
        //form <Intents/INIntentIdentifiers.h>
        UNNotificationCategory *wakeUpCate = [UNNotificationCategory categoryWithIdentifier:@"customUI" actions:@[acceptAction,rejectAction,inputAction] intentIdentifiers:@[@""] options:UNNotificationCategoryOptionNone];
        
        /**第一组按钮结束**/
        
        /**第二组按钮*/
        
        UNNotificationAction *customAction1 = [UNNotificationAction actionWithIdentifier:@"acceptAction" title:@"上网冲浪" options:UNNotificationActionOptionDestructive];
        
        UNNotificationAction *customAction2 = [UNNotificationAction actionWithIdentifier:@"rejectAction" title:@"收藏" options:UNNotificationActionOptionForeground];
        
        UNNotificationCategory *customCate = [UNNotificationCategory categoryWithIdentifier:@"customUIWeb" actions:@[customAction1,customAction2] intentIdentifiers:@[@""] options:UNNotificationCategoryOptionNone];
        
        /**第二组按钮结束**/
        NSSet *set = [NSSet setWithObjects:wakeUpCate,customCate,nil];
        
        return set;
#else
        return nil;
#endif
    }else{
        /***************************测试category*******************************/
        /*注意：以下action注册，只在iOS10之前有效！！！  */
        //apns: {"aps":{"alert":"测试通知的快捷回复", "sound":"default", "badge": 1, "category":"alert"}}
        
        //接受按钮
        UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
        acceptAction.identifier = @"acceptAction";
        acceptAction.title = @"接受";
        acceptAction.activationMode = UIUserNotificationActivationModeForeground;  //当点击的时候，启动应用
        //拒绝按钮
        UIMutableUserNotificationAction *rejectAction = [[UIMutableUserNotificationAction alloc] init];
        rejectAction.identifier = @"rejectAction";
        rejectAction.title = @"拒绝";
        rejectAction.activationMode = UIUserNotificationActivationModeBackground;   //当点击的时候，不启动应用程序，在后台处理
        rejectAction.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        rejectAction.destructive = YES; //显示红色按钮（销毁、警告类按钮）
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"customUI";
        NSArray *actions = @[acceptAction, rejectAction];
        [categorys setActions:actions forContext:UIUserNotificationActionContextMinimal];
        
        NSSet *set = [NSSet setWithObjects:categorys,nil];
        return set;
    }
}

#pragma mark - LaunchOption 

+ (void)setupWithOption:(NSDictionary *)launchOptions {
    
    //在app没有被启动的时候，接收到了消息通知。这时候操作系统会按照默认的方式来展现一个alert消息，在app icon上标记一个数字，甚至播放一段声音。
    
    //用户看到消息之后，点击了一下action按钮或者点击了应用图标。如果action按钮被点击了，系统会通过调用application:didFinishLaunchingWithOptions:这个代理方法来启动应用，并且会把notification的payload数据传递进去。如果应用图标被点击了，系统也一样会调用application:didFinishLaunchingWithOptions:这个代理方法来启动应用，唯一不同的是这时候启动参数里面不会有任何notification的信息。
    NSString *logDic = [NSString stringWithFormat:@"iOSNoti:*** push original info:%@",launchOptions];
    
    [appDelegate wirteLogWithString:logDic];
    
    NSDictionary* remoteDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSDictionary* localDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    //iOS8.0新增Today Widget
    NSURL * launchUrl              = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSString * sourceApplicationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    if (remoteDictionary != nil){
        //处理app未启动的情况下，push跳转
        [appDelegate wirteLogWithString:@"iOSNoti:setup-remote notification"];
        
        NSString *log = [NSString stringWithFormat:@"iOSNoti:setup-%@",remoteDictionary[@"seg"]];
        
        [appDelegate wirteLogWithString:log];

    }else if (localDictionary != nil){
        // 本地消息
        [appDelegate wirteLogWithString:@"iOSNoti:setup-local notification"];
        
        NSString *log = [NSString stringWithFormat:@"iOSNoti:setup-%@",localDictionary[@"seg"]];
        
        [appDelegate wirteLogWithString:log];
    }else{
        [appDelegate wirteLogWithString:@"iOSNoti:setup-other"];
    }
}

#pragma mark - Content View Action

- (IBAction)changePushFireTime:(id)sender {
    
    UISlider *sli = (UISlider *)sender;
    float value = sli.value;
    sli.value = (int)(value+0.5);
    self.timeDesL.text = [NSString stringWithFormat:@"%.0fs",sli.value];
}

- (IBAction)addNotification:(id)sender {
    [self.navigationController pushViewController:nil animated:YES];
    return;
    if (self.mutipleSwtich.isOn) {
        [self test_addMutipleNotification];
    }else if (self.videoSwitch.isOn){
        [self test_addVideoNotication];
    }else if (self.pictureSwitch.isOn){
        [self test_addPictureNotication];
    }else {
        [self test_addTextNotofication];
    }
}

- (IBAction)removeNotification:(id)sender {
    [self test_removeNotification];
}

- (IBAction)updateNotification:(id)sender {
    [self test_updateTextNotofication];
}

- (IBAction)findNotification:(id)sender {
    [self test_findNotification];
}

/**
 开关值更改
 */
- (IBAction)switchValueChanged:(id)sender {
    
    UISwitch *swi = (UISwitch *)sender;
    if (swi == self.soundSwitch) {
        
    }else{
        if (swi.isOn) {
            for (UISwitch *other in self.switchArr) {
                if (other != swi) {
                    other.on = NO;
                }
            }
        }
    }
    
}


#pragma mark - JSPushRegisterDelegate
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

/**
 收到通知的代理方法
 参考 UNUserNotificationCenterDelegate
 */
- (void)jspushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSString *log = [NSString stringWithFormat:@"iOSNoti:JSPushRegisterDelegate receive notification%@",notification];
    
    [appDelegate wirteLogWithString:log];
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

- (void)jspushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSString *log = [NSString stringWithFormat:@"iOSNoti:JSPushRegisterDelegate receive response%@",response];
    
    [appDelegate wirteLogWithString:log];
    completionHandler();
}
#endif


#pragma mark - private method

- (void)test_removeNotification
{
    JSNotificationIdentifier *iden = [JSNotificationIdentifier identifireWithIdentifiers:@[self.notiIdenLbl.text] state:JSPushNotificationStateAll];
    [JSPushService removeNotification:iden];
    
    NSString *logStr = [NSString stringWithFormat:@"移除通知：id-%@",iden.identifiers];
    [self logNextActionString:logStr];
}

- (void)test_findNotification
{
    JSNotificationIdentifier *iden = [JSNotificationIdentifier identifireWithIdentifiers:@[self.notiIdenLbl.text] state:JSPushNotificationStateAll];
   
    __block NSArray * identifiers = [iden.identifiers copy];
    iden.findCompletionHandler = ^(NSArray * result){
        NSString *logStr = [NSString stringWithFormat:@"查找通知：id-%@-%lu",identifiers,result.count];
        [self logNextActionString:logStr];
    };

    [JSPushService findNotification:iden];
}

- (void)test_updateTextNotofication
{
    JSNotificationContent *content = [[JSNotificationContent alloc] init];
    content.title = @"需求评审更新为-测试用例评审";
    content.subtitle = @"测试用例评审-新消息接入";
    content.body = @"测试用例评审-针对本期接入的新消息进行验证，保证落地页跳转正确，落参正确。";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"研发、测试、产品、项目",@"与会人员",@"12月15日",@"时间",nil];
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    
    //传递NSTimeInterval作为触发时间
    JSNotificationTrigger *trigger = [JSNotificationTrigger triggerWithTimeInterval:self.timeSlide.value repeats:NO];
    
    JSNotificationRequest *request = [JSNotificationRequest requestWithIdentifier:self.notiIdenLbl.text content:content trigger:trigger withCompletionHandler:^(id  _Nullable result) {
    }];
    
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"更新通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];
}

# pragma mark - Notification Types

- (void)test_addTextNotofication
{
    JSNotificationContent *content = [[JSNotificationContent alloc] init];
    content.title = @"需求评审";
    content.subtitle = @"iOS 10适配工作";
    content.body = @"全面采用iOS 10新框架，需要封装一套完整的API供其他模块调用。";
    content.badge = @1;
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"研发、测试、产品、项目",@"与会人员",@"12月5日",@"时间",nil];
    
    //传递NSDateComponents作为触发时间
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateC = [cal components:unitFlags fromDate:date];
    dateC.second = dateC.second + self.timeSlide.value;
#pragma clang diagnostic pop

    JSNotificationTrigger *trigger = [JSNotificationTrigger triggerWithDateMatchingComponents:dateC repeats:NO];

    JSNotificationRequest *request = [[JSNotificationRequest alloc]init];
    request.requestIdentifier = self.notiIdenLbl.text;
    request.content = content;
    request.trigger = trigger;
    request.completionHandler = ^void (id result){
    };
    
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"添加文本通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];
}

- (void)test_addPictureNotication
{
    JSNotificationContent *content = [[JSNotificationContent alloc] init];
    content.title = @"物流通知";
    content.subtitle = @"你的宝贝在路上，注意查收~";
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * imageUrl = [[NSBundle mainBundle] URLForResource:@"joy" withExtension:@"jpg"];
    UNNotificationAttachment *imgAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageUrl options:nil error:&error];
    if (imgAtt) {
        content.attachments = @[imgAtt];
    }
#endif
    
    
    content.body = @"预计今天下午3：00~5：00准时送达。";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"商品",@"iPhone",@"白色",@"颜色",@"1月5日下午五点前",@"时间",nil];
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    
    //传递NSDate作为触发时间
    JSNotificationTrigger *trigger = [[JSNotificationTrigger alloc] init];
    NSDate *currentDate   = [NSDate date];
    currentDate = [currentDate dateByAddingTimeInterval:self.timeSlide.value];
    trigger.fireDate = currentDate;
    
    JSNotificationRequest *request = [JSNotificationRequest requestWithIdentifier:self.notiIdenLbl.text content:content trigger:trigger withCompletionHandler:^(id  _Nullable result) {
    }];
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"添加图片通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];

}

- (void)test_addVideoNotication
{
    JSNotificationContent *content = [[JSNotificationContent alloc] init];
    content.title = @"导购..";
    content.subtitle = @"如何选电脑";
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * mp4Url = [[NSBundle mainBundle] URLForResource:@"media" withExtension:@"mp4"];
    UNNotificationAttachment *mediaAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:mp4Url options:nil error:&error];
    content.attachments = @[mediaAtt];
#endif
    content.body = @"电脑小白，如何挑选自己心仪的电脑，技术达人分分钟教会你~";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"白色",@"颜色",@"1月5日下午三点",@"时间",nil];
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    
    JSNotificationTrigger *trigger = [JSNotificationTrigger triggerWithTimeInterval:self.timeSlide.value repeats:NO];
    
    JSNotificationRequest *request = [[JSNotificationRequest alloc]init];
    request.requestIdentifier = self.notiIdenLbl.text;
    request.content = content;
    request.trigger = trigger;
    request.completionHandler = ^void (id result){
    };
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"添加视频通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];
}

- (void)test_addMutipleNotification
{
    JSNotificationContent *content = [[JSNotificationContent alloc] init];
    content.title = @"来，听歌";
    content.subtitle = @"许嵩新曲-素颜";
    
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    NSError *error = nil;
    //注意URL是本地图片路径，而不是http
    //假如用网络地址，UNNotificationAttachment会创建失败，为nil
    NSURL * imageUrl = [[NSBundle mainBundle] URLForResource:@"joy" withExtension:@"png"];
    UNNotificationAttachment *imgAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageUrl options:nil error:&error];
    
    NSURL * mp4Url = [[NSBundle mainBundle] URLForResource:@"media" withExtension:@"mp4"];
    UNNotificationAttachment *mediaAtt = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:mp4Url options:nil error:&error];
    content.attachments = @[imgAtt,mediaAtt];
#endif
    
    content.body = @"~~~~~~~~~~播放中~~~~~";
    content.badge = @1;
    content.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"白色",@"颜色",@"1月5日下午三点",@"时间",nil];
    if (self.soundSwitch.isOn) {
        content.sound = @"wake.caf";
    }
    
    JSNotificationTrigger *trigger = [JSNotificationTrigger triggerWithTimeInterval:self.timeSlide.value repeats:NO];

    JSNotificationRequest *request = [[JSNotificationRequest alloc]init];
    request.requestIdentifier = self.notiIdenLbl.text;
    request.content = content;
    request.trigger = trigger;
    
    request.completionHandler = ^void (id result){
    };
    [JSPushService addNotification:request];
    NSString *logStr = [NSString stringWithFormat:@"添加混合通知：%@-%@",content.title,content.body];
    [self logNextActionString:logStr];
}

- (void)logNextActionString:(NSString *)next
{
    NSString *nextLog = [NSString stringWithFormat:@"%@\n%@",self.logLabel.text,next];
    self.logLabel.text = nextLog;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};

    CGRect rect = [self.logLabel.text boundingRectWithSize:CGSizeMake(self.logLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    if (rect.size.height > self.logLabel.frame.size.height) {
        self.logLabel.text = @"";
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - iOS 10

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )
    // 会屏蔽iOS10之前方法（设置对应的代理后）
/**
 *  在前台如何处理，通过completionHandler指定。如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
 // completionHandler(0)
 *  前台收到远程通知，进入这里
 *  前台收到本地通知，进入这里
 *  前台收到带有其他字段alert/sound/badge的静默通知，进入这里
 *  后台收到静默通知不会调用该方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
    [self wirteLogWithString:@"iOSNoti:iOSNoti:userNotificationCenter willPresentNotification"];
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到通知的请求
    UNNotificationContent *content = request.content; // 收到通知的消息内容
    
    NSNumber *badge = content.badge;  // 通知消息的角标
    NSString *body = content.body;    // 通知消息体
    UNNotificationSound *sound = content.sound;  // 通知消息的声音
    NSString *subtitle = content.subtitle;  // 通知消息的副标题
    NSString *title = content.title;  // 通知消息的标题
    
        //远程通知
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [self wirteLogWithString:@"iOSNoti:push"];
    }else{
            // 判断为本地通知
        NSString *log = [NSString stringWithFormat:@"iOSNoti:iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo];
        
        [self wirteLogWithString:log];
    }
    
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}


/**
 * 在用户与你通知的通知进行交互时被调用，包括用户通过通知打开了你的应用，或者点击或者触发了某个action
 * 后台收到远程通知，点击进入
 * 后台收到本地通知，点击进入
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
    [self wirteLogWithString:@"iOSNoti:userNotificationCenter didReceiveNotificationResponse"];
    /*
     >UNNotificationResponse
     >NSString *actionIdentifier
     >UNNotification *notification
     >NSDate *date
     >UNNotificationRequest *request
     >NSString *identifier
     >UNNotificationTrigger *trigger
     >UNNotificationContent *content
     >NSNumber *badge
     >NSString *body
     >NSString *categoryIdentifier
     >NSString *launchImageName
     >NSString *subtitle
     >NSString *title
     >NSString *threadIdentifier
     >UNNotificationSound *sound
     >NSArray <UNNotificationAttachment *> *attachments
     >NSDictionary *userInfo
     */
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到通知的请求
    UNNotificationContent *content = request.content; // 收到通知的消息内容
    
    NSNumber *badge = content.badge;  // 通知消息的角标
    NSString *body = content.body;    // 通知消息体
    UNNotificationSound *sound = content.sound;  // 通知消息的声音
    NSString *subtitle = content.subtitle;  // 通知消息的副标题
    NSString *title = content.title;  // 通知消息的标题
    
        //远程通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        NSString *actionIdentifier = response.actionIdentifier;
        if ([actionIdentifier isEqualToString:@"acceptAction"]) {
            
        }else if ([actionIdentifier isEqualToString:@"rejectAction"])
            {
            
            }else if ([actionIdentifier isEqualToString:@"inputAction"]){
                
                if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
                    
                    NSString *inputText = ((UNTextInputNotificationResponse *)response).userText;
                    NSString *log = [NSString stringWithFormat:@"iOSNoti:%@",inputText];
                    
                    [self wirteLogWithString:log];
                }
                
            }
        
    }else{
            // 判断为本地通知
        NSString *log = [NSString stringWithFormat:@"iOSNoti:iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo];
        
        [self wirteLogWithString:log];
        
        NSString *actionIdentifier = response.actionIdentifier;
        if ([actionIdentifier isEqualToString:@"acceptAction"]) {
            
        }else if ([actionIdentifier isEqualToString:@"rejectAction"])
            {
            
            }else if ([actionIdentifier isEqualToString:@"inputAction"]){
                
                if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
                    
                    NSString *inputText = ((UNTextInputNotificationResponse *)response).userText;
                    NSString *log = [NSString stringWithFormat:@"iOSNoti:%@",inputText];
                    
                    [self wirteLogWithString:log];
                }
                
            }
        
    }
    
    completionHandler();
    
}

#endif

# pragma mark - Log

- (void)wirteLogWithString:(NSString *)loginput
{
    NSLog(@"%@",loginput);
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"MessageLog.txt"];
    
    if (![fm fileExistsAtPath:fileName]) {
        NSString *str = @"测试数据\n";
        [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [fileHandle seekToEndOfFile];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    
    NSString *logDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *logLine = [NSString stringWithFormat:@"\n%@-%@",loginput,logDate];
    
    NSData *logData = [logLine dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:logData];
    
}

@end
