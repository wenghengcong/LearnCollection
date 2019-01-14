//
//  NString(JS).m
//  timeboy
//
//  Created by wenghengcong on 15/5/8.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import "NString+JS.h"
#import "NSData+JS.h"

// These are the correct versions of the domain names.
static const NSString *gmailDomain        = @"gmail.com";
static const NSString *googleMailDomain   = @"googlemail.com";
static const NSString *hotmailDomain      = @"hotmail.com";
static const NSString *yahooDomain        = @"yahoo.com";
static const NSString *yahooMailDomain    = @"ymail.com";


@implementation NSString(JS)

+ (BOOL)string:(NSString *)string1  isEqualToString:(NSString *)string2{
    if (string2 != nil) {
        if ([string1 isEqualToString:string2]||(string1 == nil && string2 == nil))
            return YES;
    }else{
        if (string1 == nil)
            return YES;
        return NO;
    }
    return NO;
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([string length]==0) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}
- (BOOL) isBlankString {
    if (self == nil || self == NULL) {
        
        return YES;
        
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([self length]==0) {
        return YES;
    }
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}

#pragma mark- util
/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.width);
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}



+ (NSString *)reverseString:(NSString *)strSrc
{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [strSrc length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[strSrc substringWithRange:subStrRange]];
    }
    return reverseString;
}


#pragma mark- trims
- (NSString *)stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}


- (NSString *)stringByRemovingScriptsAndStrippingHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString stringByStrippingHTML];
}


- (NSString *)trimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)trimmingWhitespaceAndNewlines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


#pragma mark- dictionary

-(NSDictionary *) dictionaryValue{
    NSError *errorJson;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;
}


#pragma mark- urlencode
- (NSString *)urlEncode {
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)urlDecode {
    return [self urlDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSDictionary *)dictionaryFromURLParameters
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}


#pragma mark- hash
- (NSString *)md5String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}
- (NSString *)sha1String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}
- (NSString *)sha256String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}
- (NSString *)sha512String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}
- (NSString *)hmacSHA1StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}
- (NSString *)hmacSHA256StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}
- (NSString *)hmacSHA512StringWithKey:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, keyData.bytes, keyData.length, messageData.bytes, messageData.length, mutableData.mutableBytes);
    return [self stringFromBytes:(unsigned char *)mutableData.bytes length:(int)mutableData.length];
}
#pragma mark Helpers
- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}


#pragma mark- uuid
+ (NSString *)UUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
    
    CFRelease(uuidRef);
    
    return (__bridge_transfer NSString *)uuid;
}


#pragma mark- score

- (CGFloat) scoreAgainst:(NSString *)otherString{
    return [self scoreAgainst:otherString fuzziness:nil];
}

- (CGFloat) scoreAgainst:(NSString *)otherString fuzziness:(NSNumber *)fuzziness{
    return [self scoreAgainst:otherString fuzziness:fuzziness options:NSStringScoreOptionNone];
}

- (CGFloat) scoreAgainst:(NSString *)anotherString fuzziness:(NSNumber *)fuzziness options:(NSStringScoreOption)options{
    NSMutableCharacterSet *workingInvalidCharacterSet = [NSCharacterSet lowercaseLetterCharacterSet];
    [workingInvalidCharacterSet formUnionWithCharacterSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    [workingInvalidCharacterSet addCharactersInString:@" "];
    NSCharacterSet *invalidCharacterSet = [workingInvalidCharacterSet invertedSet];
    
    NSString *string = [[[self decomposedStringWithCanonicalMapping] componentsSeparatedByCharactersInSet:invalidCharacterSet] componentsJoinedByString:@""];
    NSString *otherString = [[[anotherString decomposedStringWithCanonicalMapping] componentsSeparatedByCharactersInSet:invalidCharacterSet] componentsJoinedByString:@""];
    
    // If the string is equal to the abbreviation, perfect match.
    if([string isEqualToString:otherString]) return (CGFloat) 1.0f;
    
    //if it's not a perfect match and is empty return 0
    if([otherString length] == 0) return (CGFloat) 0.0f;
    
    CGFloat totalCharacterScore = 0;
    NSUInteger otherStringLength = [otherString length];
    NSUInteger stringLength = [string length];
    BOOL startOfStringBonus = NO;
    CGFloat otherStringScore;
    CGFloat fuzzies = 1;
    CGFloat finalScore;
    
    // Walk through abbreviation and add up scores.
    for(uint index = 0; index < otherStringLength; index++){
        CGFloat characterScore = 0.1;
        NSInteger indexInString = NSNotFound;
        NSString *chr;
        NSRange rangeChrLowercase;
        NSRange rangeChrUppercase;
        
        chr = [otherString substringWithRange:NSMakeRange(index, 1)];
        
        //make these next few lines leverage NSNotfound, methinks.
        rangeChrLowercase = [string rangeOfString:[chr lowercaseString]];
        rangeChrUppercase = [string rangeOfString:[chr uppercaseString]];
        
        if(rangeChrLowercase.location == NSNotFound && rangeChrUppercase.location == NSNotFound){
            if(fuzziness){
                fuzzies += 1 - [fuzziness floatValue];
            } else {
                return 0; // this is an error!
            }
            
        } else if (rangeChrLowercase.location != NSNotFound && rangeChrUppercase.location != NSNotFound){
            indexInString = MIN(rangeChrLowercase.location, rangeChrUppercase.location);
            
        } else if(rangeChrLowercase.location != NSNotFound || rangeChrUppercase.location != NSNotFound){
            indexInString = rangeChrLowercase.location != NSNotFound ? rangeChrLowercase.location : rangeChrUppercase.location;
            
        } else {
            indexInString = MIN(rangeChrLowercase.location, rangeChrUppercase.location);
            
        }
        
        // Set base score for matching chr
        
        // Same case bonus.
        if(indexInString != NSNotFound && [[string substringWithRange:NSMakeRange(indexInString, 1)] isEqualToString:chr]){
            characterScore += 0.1;
        }
        
        // Consecutive letter & start-of-string bonus
        if(indexInString == 0){
            // Increase the score when matching first character of the remainder of the string
            characterScore += 0.6;
            if(index == 0){
                // If match is the first character of the string
                // & the first character of abbreviation, add a
                // start-of-string match bonus.
                startOfStringBonus = YES;
            }
        } else if(indexInString != NSNotFound) {
            // Acronym Bonus
            // Weighing Logic: Typing the first character of an acronym is as if you
            // preceded it with two perfect character matches.
            if( [[string substringWithRange:NSMakeRange(indexInString - 1, 1)] isEqualToString:@" "] ){
                characterScore += 0.8;
            }
        }
        
        // Left trim the already matched part of the string
        // (forces sequential matching).
        if(indexInString != NSNotFound){
            string = [string substringFromIndex:indexInString + 1];
        }
        
        totalCharacterScore += characterScore;
    }
    
    if(NSStringScoreOptionFavorSmallerWords == (options & NSStringScoreOptionFavorSmallerWords)){
        // Weigh smaller words higher
        return totalCharacterScore / stringLength;
    }
    
    otherStringScore = totalCharacterScore / otherStringLength;
    
    if(NSStringScoreOptionReducedLongStringPenalty == (options & NSStringScoreOptionReducedLongStringPenalty)){
        // Reduce the penalty for longer words
        CGFloat percentageOfMatchedString = otherStringLength / stringLength;
        CGFloat wordScore = otherStringScore * percentageOfMatchedString;
        finalScore = (wordScore + otherStringScore) / 2;
        
    } else {
        finalScore = ((otherStringScore * ((CGFloat)(otherStringLength) / (CGFloat)(stringLength))) + otherStringScore) / 2;
    }
    
    finalScore = finalScore / fuzzies;
    
    if(startOfStringBonus && finalScore + 0.15 < 1){
        finalScore += 0.15;
    }
    
    return finalScore;
}



#pragma mark- encrypt
-(NSString*)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] encryptedWithAESUsingKey:key andIV:iv];
    NSString *encryptedString = [encrypted base64EncodedString];
    
    return encryptedString;
}

- (NSString*)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *decrypted = [[NSData dataWithBase64EncodedString:self] decryptedWithAESUsingKey:key andIV:iv];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

- (NSString*)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] encryptedWith3DESUsingKey:key andIV:iv];
    NSString *encryptedString = [encrypted base64EncodedString];
    
    return encryptedString;
}

- (NSString*)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv {
    NSData *decrypted = [[NSData dataWithBase64EncodedString:self] decryptedWith3DESUsingKey:key andIV:iv];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}


#pragma mark- base64
+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData dataWithBase64EncodedString:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}
- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}
- (NSString *)base64DecodedString
{
    return [NSString stringWithBase64EncodedString:self];
}
- (NSData *)base64DecodedData
{
    return [NSData dataWithBase64EncodedString:self];
}


#pragma mark- contains
///判断URL中是否包含中文
- (BOOL)isContainChinese
{
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
}

///是否包含空格
- (BOOL)isContainBlank
{
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

//Unicode编码的字符串转成NSString
- (NSString *)makeUnicodeToString
{
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    //NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (BOOL)containsCharacterSet:(NSCharacterSet *)set
{
    NSRange rang = [self rangeOfCharacterFromSet:set];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

/**
 *  @brief 是否包含字符串
 *
 *  @param string 字符串
 *
 *  @return YES, 包含; Otherwise
 */
- (BOOL)containsString:(NSString *)string
{
    NSRange rang = [self rangeOfString:string];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

/**
 *  @brief 获取字符数量
 */
- (int)wordsCount
{
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++)
    {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}

// If my string contains ony letters
- (BOOL)containsOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers
- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers
- (BOOL)containsOnlyNumbersAndLetters
{
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// If my string is available in particular array
- (BOOL)isInThisarray:(NSArray*)array
{
    for(NSString *string in array) {
        if([self isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark- mime
- (NSString *)MIMEType {
    return [[self class] MIMETypeForExtension:[self pathExtension]];
}

+ (NSString *)MIMETypeForExtension:(NSString *)extension {
    return [[self MIMEDict] valueForKey:[extension lowercaseString]];
}

+ (NSDictionary *)MIMEDict {
    NSDictionary * MIMEDict;
    // Lazy loads the MIME type dictionary.
    if (!MIMEDict) {
        
        // ???: Should I have these return an array of MIME types? The first element would be the preferred MIME type.
        
        // ???: Should I have a couple methods that return the MIME media type name and the MIME subtype name?
        
        // Values from http://www.w3schools.com/media/media_mimeref.asp
        // There are probably values missed, but this is a good start.
        // A few more have been added that weren't included on the original list.
        MIMEDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    // Key      // Value
                    @"",        @"application/octet-stream",
                    @"323",     @"text/h323",
                    @"acx",     @"application/internet-property-stream",
                    @"ai",      @"application/postscript",
                    @"aif",     @"audio/x-aiff",
                    @"aifc",    @"audio/x-aiff",
                    @"aiff",    @"audio/x-aiff",
                    @"asf",     @"video/x-ms-asf",
                    @"asr",     @"video/x-ms-asf",
                    @"asx",     @"video/x-ms-asf",
                    @"au",      @"audio/basic",
                    @"avi",     @"video/x-msvideo",
                    @"axs",     @"application/olescript",
                    @"bas",     @"text/plain",
                    @"bcpio",   @"application/x-bcpio",
                    @"bin",     @"application/octet-stream",
                    @"bmp",     @"image/bmp",
                    @"c",       @"text/plain",
                    @"cat",     @"application/vnd.ms-pkiseccat",
                    @"cdf",     @"application/x-cdf",
                    @"cer",     @"application/x-x509-ca-cert",
                    @"class",   @"application/octet-stream",
                    @"clp",     @"application/x-msclip",
                    @"cmx",     @"image/x-cmx",
                    @"cod",     @"image/cis-cod",
                    @"cpio",    @"application/x-cpio",
                    @"crd",     @"application/x-mscardfile",
                    @"crl",     @"application/pkix-crl",
                    @"crt",     @"application/x-x509-ca-cert",
                    @"csh",     @"application/x-csh",
                    @"css",     @"text/css",
                    @"dcr",     @"application/x-director",
                    @"der",     @"application/x-x509-ca-cert",
                    @"dir",     @"application/x-director",
                    @"dll",     @"application/x-msdownload",
                    @"dms",     @"application/octet-stream",
                    @"doc",     @"application/msword",
                    @"docx",    @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                    @"dot",     @"application/msword",
                    @"dvi",     @"application/x-dvi",
                    @"dxr",     @"application/x-director",
                    @"eps",     @"application/postscript",
                    @"etx",     @"text/x-setext",
                    @"evy",     @"application/envoy",
                    @"exe",     @"application/octet-stream",
                    @"fif",     @"application/fractals",
                    @"flr",     @"x-world/x-vrml",
                    @"gif",     @"image/gif",
                    @"gtar",    @"application/x-gtar",
                    @"gz",      @"application/x-gzip",
                    @"h",       @"text/plain",
                    @"hdf",     @"application/x-hdf",
                    @"hlp",     @"application/winhlp",
                    @"hqx",     @"application/mac-binhex40",
                    @"hta",     @"application/hta",
                    @"htc",     @"text/x-component",
                    @"htm",     @"text/html",
                    @"html",    @"text/html",
                    @"htt",     @"text/webviewhtml",
                    @"ico",     @"image/x-icon",
                    @"ief",     @"image/ief",
                    @"iii",     @"application/x-iphone",
                    @"ins",     @"application/x-internet-signup",
                    @"isp",     @"application/x-internet-signup",
                    @"jfif",    @"image/pipeg",
                    @"jpe",     @"image/jpeg",
                    @"jpeg",    @"image/jpeg",
                    @"jpg",     @"image/jpeg",
                    @"js",      @"application/x-javascript",
                    @"json",    @"application/json",   // According to RFC 4627  // Also application/x-javascript text/javascript text/x-javascript text/x-json
                    @"latex",   @"application/x-latex",
                    @"lha",     @"application/octet-stream",
                    @"lsf",     @"video/x-la-asf",
                    @"lsx",     @"video/x-la-asf",
                    @"lzh",     @"application/octet-stream",
                    @"m",       @"text/plain",
                    @"m13",     @"application/x-msmediaview",
                    @"m14",     @"application/x-msmediaview",
                    @"m3u",     @"audio/x-mpegurl",
                    @"man",     @"application/x-troff-man",
                    @"mdb",     @"application/x-msaccess",
                    @"me",      @"application/x-troff-me",
                    @"mht",     @"message/rfc822",
                    @"mhtml",   @"message/rfc822",
                    @"mid",     @"audio/mid",
                    @"mny",     @"application/x-msmoney",
                    @"mov",     @"video/quicktime",
                    @"movie",   @"video/x-sgi-movie",
                    @"mp2",     @"video/mpeg",
                    @"mp3",     @"audio/mpeg",
                    @"mpa",     @"video/mpeg",
                    @"mpe",     @"video/mpeg",
                    @"mpeg",    @"video/mpeg",
                    @"mpg",     @"video/mpeg",
                    @"mpp",     @"application/vnd.ms-project",
                    @"mpv2",    @"video/mpeg",
                    @"ms",      @"application/x-troff-ms",
                    @"mvb",     @"	application/x-msmediaview",
                    @"nws",     @"message/rfc822",
                    @"oda",     @"application/oda",
                    @"p10",     @"application/pkcs10",
                    @"p12",     @"application/x-pkcs12",
                    @"p7b",     @"application/x-pkcs7-certificates",
                    @"p7c",     @"application/x-pkcs7-mime",
                    @"p7m",     @"application/x-pkcs7-mime",
                    @"p7r",     @"application/x-pkcs7-certreqresp",
                    @"p7s",     @"	application/x-pkcs7-signature",
                    @"pbm",     @"image/x-portable-bitmap",
                    @"pdf",     @"application/pdf",
                    @"pfx",     @"application/x-pkcs12",
                    @"pgm",     @"image/x-portable-graymap",
                    @"pko",     @"application/ynd.ms-pkipko",
                    @"pma",     @"application/x-perfmon",
                    @"pmc",     @"application/x-perfmon",
                    @"pml",     @"application/x-perfmon",
                    @"pmr",     @"application/x-perfmon",
                    @"pmw",     @"application/x-perfmon",
                    @"png",     @"image/png",
                    @"pnm",     @"image/x-portable-anymap",
                    @"pot",     @"application/vnd.ms-powerpoint",
                    @"vppm",    @"image/x-portable-pixmap",
                    @"pps",     @"application/vnd.ms-powerpoint",
                    @"ppt",     @"application/vnd.ms-powerpoint",
                    @"pptx",    @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
                    @"prf",     @"application/pics-rules",
                    @"ps",      @"application/postscript",
                    @"pub",     @"application/x-mspublisher",
                    @"qt",      @"video/quicktime",
                    @"ra",      @"audio/x-pn-realaudio",
                    @"ram",     @"audio/x-pn-realaudio",
                    @"ras",     @"image/x-cmu-raster",
                    @"rgb",     @"image/x-rgb",
                    @"rmi",     @"audio/mid",
                    @"roff",    @"application/x-troff",
                    @"rtf",     @"application/rtf",
                    @"rtx",     @"text/richtext",
                    @"scd",     @"application/x-msschedule",
                    @"sct",     @"text/scriptlet",
                    @"setpay",  @"application/set-payment-initiation",
                    @"setreg",  @"application/set-registration-initiation",
                    @"sh",      @"application/x-sh",
                    @"shar",    @"application/x-shar",
                    @"sit",     @"application/x-stuffit",
                    @"snd",     @"audio/basic",
                    @"spc",     @"application/x-pkcs7-certificates",
                    @"spl",     @"application/futuresplash",
                    @"src",     @"application/x-wais-source",
                    @"sst",     @"application/vnd.ms-pkicertstore",
                    @"stl",     @"application/vnd.ms-pkistl",
                    @"stm",     @"text/html",
                    @"svg",     @"image/svg+xml",
                    @"sv4cpio", @"application/x-sv4cpio",
                    @"sv4crc",  @"application/x-sv4crc",
                    @"swf",     @"application/x-shockwave-flash",
                    @"t",       @"application/x-troff",
                    @"tar",     @"application/x-tar",
                    @"tcl",     @"application/x-tcl",
                    @"tex",     @"application/x-tex",
                    @"texi",    @"application/x-texinfo",
                    @"texinfo", @"application/x-texinfo",
                    @"tgz",     @"application/x-compressed",
                    @"tif",     @"image/tiff",
                    @"tiff",    @"image/tiff",
                    @"tr",      @"application/x-troff",
                    @"trm",     @"application/x-msterminal",
                    @"tsv",     @"text/tab-separated-values",
                    @"txt",     @"text/plain",
                    @"uls",     @"text/iuls",
                    @"ustar",   @"application/x-ustar",
                    @"vcf",     @"text/x-vcard",
                    @"vrml",    @"x-world/x-vrml",
                    @"wav",     @"audio/x-wav",
                    @"wcm",     @"application/vnd.ms-works",
                    @"wdb",     @"application/vnd.ms-works",
                    @"wks",     @"application/vnd.ms-works",
                    @"wmf",     @"application/x-msmetafile",
                    @"wps",     @"application/vnd.ms-works",
                    @"wri",     @"application/x-mswrite",
                    @"wrl",     @"x-world/x-vrml",
                    @"wrz",     @"x-world/x-vrml",
                    @"xaf",     @"x-world/x-vrml",
                    @"xbm",     @"image/x-xbitmap",
                    @"xla",     @"application/vnd.ms-excel",
                    @"xlc",     @"application/vnd.ms-excel",
                    @"xlm",     @"application/vnd.ms-excel",
                    @"xls",     @"application/vnd.ms-excel",
                    @"xlsx",    @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    @"xlt",     @"application/vnd.ms-excel",
                    @"xlw",     @"application/vnd.ms-excel",
                    @"xml",     @"text/xml",   // According to RFC 3023   // Also application/xml
                    @"xof",     @"x-world/x-vrml",
                    @"xpm",     @"image/x-xpixmap",
                    @"xwd",     @"image/x-xwindowdump",
                    @"z",       @"application/x-compress",
                    @"zip",     @"application/zip",
                    nil];
    }
    
    return MIMEDict;
}

#pragma mark- email
- (NSString *)stringByCorrectingEmailTypos
{
    if (![self isValidEmailAddress]) {
        NSLog(@"%@ is not a valid email address.", self);
        return self;
    }
    
    // Start with a lower-cased version of the original string.
    __block NSString *correctedEmailAddress = [self lowercaseString];
    
    // First replace a ".con" suffix with ".com".
    if ([correctedEmailAddress hasSuffix:@".con"]) {
        NSRange range = NSMakeRange(correctedEmailAddress.length - 4, 4);
        correctedEmailAddress = [correctedEmailAddress stringByReplacingOccurrencesOfString:@".con"
                                                                                 withString:@".com"
                                                                                    options:NSBackwardsSearch|NSAnchoredSearch
                                                                                      range:range];
    }
    
    // Now iterate through the bad domain names to find common typos.
    // Feel free to add to the dictionary below.
    // I got the original list from http://getintheinbox.com/2013/02/25/typo-traps/
    NSDictionary *typos = @{@"gogglemail.com":  googleMailDomain,
                            @"googlmail.com":   googleMailDomain,
                            @"goglemail.com":   googleMailDomain,
                            @"hotmial.com":     hotmailDomain,
                            @"hotmal.com":      hotmailDomain,
                            @"hoitmail.com":    hotmailDomain,
                            @"homail.com":      hotmailDomain,
                            @"hotnail.com":     hotmailDomain,
                            @"hotrmail.com":    hotmailDomain,
                            @"hotmil.com":      hotmailDomain,
                            @"hotmaill.com":    hotmailDomain,
                            @"yaho.com":        yahooDomain,
                            @"uahoo.com":       yahooDomain,
                            @"ayhoo.com":       yahooDomain,
                            @"ymial.com":       yahooMailDomain,
                            @"ymaill.com":      yahooMailDomain,
                            @"gmal.com":        gmailDomain,
                            @"gnail.com":       gmailDomain,
                            @"gmaill.com":      gmailDomain,
                            @"gmial.com":       gmailDomain,
                            };
    
    [typos enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        NSString *domainIncludingAtSymbol = [NSString stringWithFormat:@"@%@", key];
        if ([correctedEmailAddress hasSuffix:domainIncludingAtSymbol]) {
            // Found a bad domain.
            correctedEmailAddress = [correctedEmailAddress stringByReplacingOccurrencesOfString:key withString:object];
            *stop = YES;
        }
    }];
    
    return correctedEmailAddress;
}

- (BOOL)isValidEmailAddress
{
    // http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


#pragma mark- html
- (NSString *)kv_decodeHTMLCharacterEntities {
    if ([self rangeOfString:@"&"].location == NSNotFound) {
        return self;
    } else {
        NSMutableString *escaped = [NSMutableString stringWithString:self];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [self rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", (unsigned short) (160 + i)]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
        
        // The following five are not in the 160+ range
        
        // @"&amp;"
        NSRange range = [self rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 38]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [self rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 60]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [self rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 62]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&apos;"
        range = [self rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 39]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&quot;"
        range = [self rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", (unsigned short) 34]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unsigned short) tempInt] atIndex:entityRange.location];
                } else {
                    [escaped insertString:[NSString stringWithFormat:@"%C", (unsigned short) [value intValue]] atIndex:entityRange.location];
                } i = start.location;
            } else { i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        
        return escaped;    // Note this is autoreleased
    }
}

- (NSString *)kv_encodeHTMLCharacterEntities {
    NSMutableString *encoded = [NSMutableString stringWithString:self];
    
    // @"&amp;"
    NSRange range = [self rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"&"
                                 withString:@"&amp;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&lt;"
    range = [self rangeOfString:@"<"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"<"
                                 withString:@"&lt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&gt;"
    range = [self rangeOfString:@">"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@">"
                                 withString:@"&gt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    return encoded;
}

@end
