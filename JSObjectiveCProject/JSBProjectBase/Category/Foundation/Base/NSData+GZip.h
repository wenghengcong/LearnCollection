//
//  NSData+GZip.h
//  CategoryCollection
//
//  Created by whc on 15/7/28.
//  Copyright (c) 2015年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(GZip)


#pragma mark- gzip

/// GZIP压缩
- (NSData *)gzippedDataWithCompressionLevel:(float)level;

/// GZIP压缩
- (NSData *)gzippedData;

/// GZIP解压
- (NSData *)gunzippedData;

@end
