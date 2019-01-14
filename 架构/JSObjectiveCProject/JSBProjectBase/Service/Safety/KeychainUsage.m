//
//  KeychainUsage.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/4.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "KeychainUsage.h"
#import "KeychainItemWrapper.h"

@interface KeychainUsage()

@property (nonatomic,retain)    KeychainItemWrapper     *   keychain;

@end

@implementation KeychainUsage




- (void)howToSetKeyChain {

    
    /**
     reference:http://b2cloud.com.au/tutorial/using-the-keychain-to-store-passwords-on-ios/
    */
    
    /**
     各个字段简要说明：
     kSecAttrAccount:
     This holds account information, something like an email address or username
     
     kSecValueData:
     This is for the secure data. Passwords, session keys, anything of the sort
     
     kSecAttrAccessible:
     When the information above is available. You must specify one of the following:
        kSecAttrAccessibleWhenUnlocked,
        kSecAttrAccessibleAfterFirstUnlock,
        kSecAttrAccessibleAlways,
        kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
        kSecAttrAccessibleAlwaysThisDeviceOnly.
     
     For most applications kSecAttrAccessibleWhenUnlocked is probably the best option, which means the information is only available when the device is unlocked and will be transferred between backups to other devices
    
     
     */
    
    
    /**
     keychain使用说明
      The identifier should be unique per keychain item, two different identifiers will represent two different bits of information. The access group can be nil unless you want to share this keychain item among multiple apps.
     */
    
    
    
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Account Number"
                                                                       accessGroup:@"YOUR_APP_ID_HERE.com.yourcompany.AppIdentifier"];
    
    [wrapper setObject:(__bridge NSString*)kSecAttrAccessibleWhenUnlocked forKey:(id)kSecAttrAccessible];

    //保存帐号密码
    [wrapper setObject:@"<帐号>" forKey:(id)kSecAttrAccount];
    [wrapper setObject:@"<密码>" forKey:(id)kSecValueData];

    //从keychain里取出帐号密码
    NSString *username = [wrapper objectForKey:(id)kSecAttrAccount];
    NSString *password = [wrapper objectForKey:(id)kSecValueData];
    
    //清空设置
    [wrapper resetKeychainItem];
    
}

@end
