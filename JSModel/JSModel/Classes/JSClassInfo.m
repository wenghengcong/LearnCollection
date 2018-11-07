//
//  JSClassInfo.m
//  JSModel
//
//  Created by WengHengcong on 16/6/12.
//  Copyright © 2016年 Beijing Jingdong Century Trading Co., Ltd. All rights reserved.
//

#import "JSClassInfo.h"
#import <CoreData/CoreData.h>

JSEncodingType JSEncodingGetType(NSString *typeEncoding) {

    const char *type = [typeEncoding UTF8String];
    if (!type) return JSEncodingTypeUnknown;
    size_t len = strlen(type);
    if(len == 0) return JSEncodingTypeUnknown;
    
    switch (*type) {
        case 'c':
            return JSEncodingTypeChar;
            break;
        case 'i':
            return JSEncodingTypeInt;
            break;
        case 's':
            return JSEncodingTypeShort;
            break;
        case 'l':
            return JSEncodingTypeLong;
            break;
        case 'q':
            return JSEncodingTypeLongLong;
            break;
        case 'C':
            return JSEncodingTypeUChar;
            break;
        case 'I':
            return JSEncodingTypeUInt;
            break;
        case 'S':
            return JSEncodingTypeUShort;
            break;
        case 'L':
            return JSEncodingTypeULong;
            break;
        case 'Q':
            return JSEncodingTypeULongLong;
            break;
        case 'f':
            return JSEncodingTypeFloat;
            break;
        case 'd':
            return JSEncodingTypeDouble;
            break;
        case 'B':
            return JSEncodingTypeBool;
            break;
        case 'v':
            return JSEncodingTypeVoid;
            break;
        case '*':
            return JSEncodingTypePointer;
            break;
        case '?':
            return JSEncodingTypeUnknown;
            break;
        case '#':
            return JSEncodingTypeClass;
            break;
        case ':':
            return JSEncodingTypeSEl;
            break;
        case '[':
            return JSEncodingTypeCArray;
            break;
        case '(':
            return JSEncodingTypeUnion;
            break;
        case '{':
            return JSEncodingTypeStruct;
            break;
        case '@':
            if (len == 2 && *(type+1) == '?') {
                return JSEncodingTypeBlock;
            }else{
                return JSEncodingTypeId;
            }
            break;
        case '^':
            //暂不处理
            break;
        default:
            break;
    }
    
    return JSEncodingTypeUnknown;
}


@implementation JSClassInfo

@end


@implementation JSClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    
    if(!property) return nil;
    self = [self init];
    _property = property;
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    const char *attributes = property_getAttributes(property);
    NSLog(@"name:%s,attributes:%s",name,attributes);
    
    if (attributes) {
        _typeEncoding = [NSString stringWithUTF8String:attributes];
        NSArray *typeArr = [_typeEncoding componentsSeparatedByString:@","];
        NSString *typeStr;
        
        if (typeArr) {
            typeStr = [typeArr[0] substringFromIndex:1];
        }
        
        if (typeStr.length >= 3) {
            // 去掉@"和"，截取中间的类型名称
            typeStr = [typeStr substringWithRange:NSMakeRange(2, typeStr.length-3)];
            _cls = NSClassFromString(typeStr);
            _isNSClass = [self isClassFromFoundation:_cls];
        }else{
            _type = JSEncodingGetType(typeStr);
            _cls = nil;
        }
        
        [self checkIsNumber];
        
    }
//    NSLog(@"%@--%lu--%@",_name,(unsigned long)_type,_cls);
    
    return self;
}

/**
 *  Foundation Class集合
 */
- (NSSet*)foundationClass {
    
    return [NSSet setWithObjects:
            [NSURL class],
            [NSDate class],
            [NSValue class],
            [NSDecimalNumber class],
            [NSNumber class],
            [NSData class],
            [NSMutableData class],
            [NSError class],
            [NSArray class],
            [NSMutableArray class],
            [NSDictionary class],
            [NSMutableDictionary class],
            [NSString class],
            [NSMutableString class],
            [NSAttributedString class],
            [NSSet class],
            [NSMutableSet class],nil];
    
}
/**
 *  是否是Foundation Class集合中的类
 */
- (BOOL)isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    
    __block BOOL result = NO;
    [[self foundationClass] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (void)checkIsNumber
{
    if (_cls) {
        if ( [_cls isSubclassOfClass:[NSNumber class]] || [_cls isSubclassOfClass:[NSDecimalNumber class]] ) {
            _isNumber = YES;
        }else{
            _isNumber = NO;
        }
    }else{
        NSArray *numberTypes = [NSArray arrayWithObjects:
                                @(JSEncodingTypeChar),             //c
                                @(JSEncodingTypeInt),              //i
                                @(JSEncodingTypeShort),            //s
                                @(JSEncodingTypeLong),             //l
                                @(JSEncodingTypeLongLong),         //q
                                @(JSEncodingTypeUChar),            //C
                                @(JSEncodingTypeUInt),             //I
                                @(JSEncodingTypeUShort),           //S
                                @(JSEncodingTypeULong),            //L
                                @(JSEncodingTypeULongLong),        //Q
                                @(JSEncodingTypeFloat),            //f
                                @(JSEncodingTypeDouble),           //d
                                @(JSEncodingTypeBool),             //B
                                nil];
        if ([numberTypes containsObject:@(_type)]) {
            _isNumber = YES;
        }else{
            _isNumber = NO;
        }
    }
}

@end