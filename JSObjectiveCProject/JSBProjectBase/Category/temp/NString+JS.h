//
//  NString(JS).h
//  timeboy
//
//  Created by wenghengcong on 15/5/8.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>


typedef NS_ENUM(NSUInteger, NSStringScoreOption) {
    NSStringScoreOptionNone                         = 1 << 0,
    NSStringScoreOptionFavorSmallerWords            = 1 << 1,
    NSStringScoreOptionReducedLongStringPenalty     = 1 << 2
};

@interface NSString(JS)

/**
 *  比较字符串是否相等
 *
 *  @param string1 str1
 *  @param string2 str2
 *
 *  @return 相等 YES  否则 NO
 */
+ (BOOL)string:(NSString *)string1  isEqualToString:(NSString *)string2;
/**
 *  是否是空字符串
 *
 *  @param string
 */
+ (BOOL) isBlankString:(NSString *)string ;
- (BOOL) isBlankString;


#pragma mark- util

#pragma mark- trims
- (NSString *)stringByStrippingHTML;
- (NSString *)stringByRemovingScriptsAndStrippingHTML;

- (NSString *)trimmingWhitespace;
- (NSString *)trimmingWhitespaceAndNewlines;

#pragma mark- dictionary
-(NSDictionary *) dictionaryValue;


#pragma mark- urlencode
- (NSString *)urlEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)urlDecode;
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSDictionary *)dictionaryFromURLParameters;

#pragma mark- hash
@property (readonly) NSString *md5String;
@property (readonly) NSString *sha1String;
@property (readonly) NSString *sha256String;
@property (readonly) NSString *sha512String;
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

#pragma mark- uuid
+ (NSString *)UUID;

#pragma mark- score
- (CGFloat) scoreAgainst:(NSString *)otherString;
- (CGFloat) scoreAgainst:(NSString *)otherString fuzziness:(NSNumber *)fuzziness;
- (CGFloat) scoreAgainst:(NSString *)otherString fuzziness:(NSNumber *)fuzziness options:(NSStringScoreOption)options;


#pragma mark- encrypt
- (NSString*)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

- (NSString*)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

#pragma mark- base64 
+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

#pragma mark- contains
///判断URL中是否包含中文
- (BOOL)isContainChinese;

///是否包含空格
- (BOOL)isContainBlank;

///Unicode编码的字符串转成NSString
- (NSString *)makeUnicodeToString;

- (BOOL)containsCharacterSet:(NSCharacterSet *)set;

- (BOOL)containsString:(NSString *)string;

- (int)wordsCount;


- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisarray:(NSArray*)array;


#pragma mark- mime

- (NSString *)MIMEType;

+ (NSString *)MIMETypeForExtension:(NSString *)extension;

+ (NSDictionary *)MIMEDict;


#pragma mark- email
// Returns a string with the email address corrected for common domain typos.
// Supports misspelled variations for Gmail, Googlemail, Hotmail, Yahoo and Ymail.
// Replaces a ".con" suffix with ".com" for any domain.
// More domains can be easily added using a simple dictionary format.
//
// Some examples of bad email addresses that will be corrected:
//      robert@gmial.com -> robert@gmail.com        (1 error)
//      robert@gmial.con -> robert@gmail.com        (2 errors)
//      robert@hotmail.con -> robert@hotmail.com    (1 error)
//      robert@hoitmail.com -> robert@hotmail.com   (1 error)
//      robert@hoitmail.con -> robert@hotmail.com   (2 errors)
//      robert@aol.con -> robert@aol.com            (1 error)
//      robert.con@aol.con -> robert.con@aol.com    (1 error, but special case with multiple .con's)
//
// Besides correcting the typos, it also lowercases the email address.
// If the email address is invalid, returns the original value.
// Use - [isValidEmailAddress] to validate the email address first if necessary.
- (NSString *)stringByCorrectingEmailTypos;

// Validate the email syntax (not domains) using a RegEx pattern.
- (BOOL)isValidEmailAddress;


#pragma mark- html
- (NSString *)kv_decodeHTMLCharacterEntities;
- (NSString *)kv_encodeHTMLCharacterEntities;


@end
