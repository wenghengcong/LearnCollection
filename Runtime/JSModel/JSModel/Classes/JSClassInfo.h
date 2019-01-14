//
//  JSClassInfo.h
//  JSModel
//
//  Created by WengHengcong on 16/6/12.
//  Copyright © 2016年 Beijing Jingdong Century Trading Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, JSEncodingType) {
    JSEncodingTypeMask              = 0xFF, ///< mask of type value
    JSEncodingTypeChar,             //c
    JSEncodingTypeInt,              //i
    JSEncodingTypeShort,            //s
    JSEncodingTypeLong,             //l
    JSEncodingTypeLongLong,         //q
    JSEncodingTypeUChar,            //C
    JSEncodingTypeUInt,             //I
    JSEncodingTypeUShort,           //S
    JSEncodingTypeULong,            //L
    JSEncodingTypeULongLong,        //Q
    JSEncodingTypeFloat,            //f
    JSEncodingTypeDouble,           //d
    JSEncodingTypeBool,             //B
    JSEncodingTypeVoid,             //v
    JSEncodingTypePointer,          //*
    JSEncodingTypeId,               //@
    JSEncodingTypeUnknown,          //?
    JSEncodingTypeBlock,            //@?
    JSEncodingTypeClass,            //#
    JSEncodingTypeSEl,              //:
    JSEncodingTypeCArray,           //[
    JSEncodingTypeUnion,            //(
    JSEncodingTypeStruct,           //{
    JSEncodingTypeIvar,             //^{objc_ivar=}
    JSEncodingTypeMethod,           //^{objc_method=}
};

@interface JSClassInfo : NSObject

@end


@interface JSClassPropertyInfo : NSObject

@property (nonatomic, assign, readonly) objc_property_t property; ///< property

@property (nonatomic, strong, readonly) NSString    *name;
@property (nonatomic, assign, readonly) JSEncodingType type;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nullable, nonatomic, assign, readonly) Class cls; ///< may be nil

@property (nonatomic, assign, readonly) BOOL isNSClass;
@property (nonatomic, assign, readonly) BOOL isNumber;


- (instancetype)initWithProperty:(objc_property_t)property;

@end

NS_ASSUME_NONNULL_END