//
//  NSData+JS.h
//  timeboy
//
//  Created by whc on 15/6/5.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const GzipErrorDomain;

@interface NSData(JS)

#pragma mark- base64
//
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

#pragma mark- encrypt

/**
 *  利用AES加密数据
 *
 *  @param key key
 *  @param iv  <#iv description#>
 *
 *  @return data
 */
- (NSData *)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

/**
 *  利用3DES加密数据
 *
 *  @param key key
 *  @param iv  <#iv description#>
 *
 *  @return data
 */
- (NSData *)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

- (NSString *)UTF8String;

#pragma mark- gzip

/// GZIP压缩
- (NSData *)gzippedDataWithCompressionLevel:(float)level;

/// GZIP压缩
- (NSData *)gzippedData;

/// GZIP解压
- (NSData *)gunzippedData;

#pragma mark- jsdatacache

/**
 *  将URL作为key保存到磁盘里缓存起来
 *
 *  @param identifier url.absoluteString
 */
- (void)saveDataCacheWithIdentifier:(NSString *)identifier;

/**
 *  取出缓存data
 *
 *  @param identifier url.absoluteString
 *
 *  @return 缓存
 */
+ (NSData *)getDataCacheWithIdentifier:(NSString *)identifier;
@end
