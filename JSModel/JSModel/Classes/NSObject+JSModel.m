//
//  NSObject+JSModel.m
//  JSModel
//
//  Created by WengHengcong on 16/6/12.
//  Copyright © 2016年 Beijing Jingdong Century Trading Co., Ltd. All rights reserved.
//

#import "NSObject+JSModel.h"
#import "JSClassInfo.h"
#import <objc/runtime.h>

typedef struct property_t {
    const char *name;
    const char *attributes;
} *propertyStruct;


@implementation NSObject (JSModel)

+ (NSArray *)properties {
    
    NSMutableArray *propertiesArr = [NSMutableArray array];
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList(self, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        JSClassPropertyInfo *propertyInfo = [[JSClassPropertyInfo alloc]initWithProperty:property];
        [propertiesArr addObject:propertyInfo];
    }
    
    return [propertiesArr copy];
}

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    
    if (!dic) return nil;
    return [[[self alloc] init]modelWithDic:dic];
    
}

- (instancetype)modelWithDic:(NSDictionary *)dic {

    NSArray *properties = [self.class properties];
    
    for (int i = 0; i < properties.count ; i++) {
        JSClassPropertyInfo *propertyInfo = properties[i];
        id value = [dic valueForKey:propertyInfo.name];
        if (!value) continue;
        
        if (propertyInfo.isNumber){
            // 字符串->数字
            if ([value isKindOfClass:[NSString class]])
//                value = [[[NSNumberFormatter alloc]init] numberFromString:value];
            [self setValue:value forKey:propertyInfo.name];

        }else if (propertyInfo.isNSClass){
            if ( [propertyInfo.cls isSubclassOfClass:[NSArray class]] ) {
                //对象数组-》模型数组
                //books->JSBook
                if ([self.class respondsToSelector:@selector(objectInArray)]) {
                    
                    NSDictionary *tmpDic = [ (id<JSModel>) self.class objectInArray];
                    NSString *className = tmpDic[propertyInfo.name];
                    id cls = NSClassFromString(className);
                    //将value转换为数组
                    NSMutableArray *tmpObjArr = [NSMutableArray array];
                    NSArray *objArr = (NSArray *)value;
                    for (NSDictionary * obj in objArr) {
                        id model = [cls modelWithDic:obj];
                        [tmpObjArr addObject:model];
                    }
                    [self setValue:tmpObjArr forKey:propertyInfo.name];
                }
            }else{
                [self setValue:value forKey:propertyInfo.name];
            }
            
        }else{
            //自定义类
            //取出内层字典值
            NSDictionary *dic = (NSDictionary*)value;
            if (dic) {
                //将内层字典转换为模型
                id model = [propertyInfo.cls modelWithDic:dic];
                //将内层转换的模型，赋值给外层属性
                [self setValue:model forKey:propertyInfo.name];
            }
        }
        
    }
    return self;
}

@end
