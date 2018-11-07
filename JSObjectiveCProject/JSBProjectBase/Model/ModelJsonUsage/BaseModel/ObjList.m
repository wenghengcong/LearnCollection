//
//  ObjList.m
//  JSBProjectBase
//
//  Created by wenghengcong on 15/9/20.
//  Copyright © 2015年 JungleSong. All rights reserved.
//

#import "ObjList.h"

@interface ObjList()

@property (nonatomic,retain)    NSMutableDictionary  *   impl;

@end

@implementation ObjList

- (instancetype)init {
    self = [super init];
    if (self) {
        self.impl = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone{
    ObjList *list = [[ObjList alloc]init];
    list.impl = [self.impl copy];
    return list;
}
- (ObjBase *)findObjBase:(id)guid
{
    ObjBase * ret = nil;
    
    if( self.impl != nil && guid )
    {
        ret = [self.impl objectForKey:guid];
    }
    
    return ret;
}

- (BOOL)addObjBase:(ObjBase *)elm{
    
    BOOL ret = NO;
    if( self.impl != nil && elm != nil && elm.guid){
        [ self.impl setObject:elm forKey:elm.guid ];
        ret = YES;
    }
    
    return ret;
}

- (void)removeObjBase:(id) guid{
    if(  guid )
    {
        [ self.impl removeObjectForKey: guid ];
    }
}

- (ObjBase *) getObjectAtIndex:(NSInteger) idx WithIsDESC:(BOOL) is_desc {
    ObjBase * ret = nil;
    
    NSArray *sortedKeys = nil;
    if( is_desc )
    {
        sortedKeys = [self.impl keysSortedByValueUsingSelector:@selector(compareNumericallyDESC:)];
    }else{
        sortedKeys = [self.impl keysSortedByValueUsingSelector:@selector(compareNumericallyASC:)];
    }
    
    if( sortedKeys )
    {
        if( [sortedKeys count] >= idx + 1 )
        {
            NSNumber * key = [sortedKeys objectAtIndex:idx];
            ret = [self.impl objectForKey:key];
        }
    }
    
    return ret;
}


- (ObjBase *) getMaxIDObjBase{
    NSUInteger count = [self.impl count];
    
    if( count > 0 ){
        return [self getObjectAtIndex:0 WithIsDESC:YES];
    }
    return nil;
}

- (ObjBase *)getMinIDObjBase{
    NSUInteger count = [self.impl count];
    
    if( count > 0 ){
        return [self getObjectAtIndex:0 WithIsDESC:YES];
    }
    return nil;
}

- (NSInteger)indexOfObjBase:(ObjBase *) baseObj
{
    if( !baseObj )
        return -1;
    
    NSArray * allValues = [self.impl allValues];
    if( allValues )
    {
        NSInteger index = 0;
        NSEnumerator * itor = [allValues objectEnumerator];
        if( itor )
        {
            id value;
            while ( value = [itor nextObject] ) {
                ObjBase * elm = (ObjBase *)value;
                if( elm == baseObj )
                {
                    return index;
                }
                index += 1;
            }
        }
    }
    
    return -1;
}

- (void)removeAllObjBase
{
    [self.impl removeAllObjects];
}

- (void)limitSizeByGUID:(NSUInteger) limit_size
{
    if( [self.impl count] > limit_size )
    {
        NSUInteger remove_count = [self.impl count] - limit_size;
        NSArray *sortedKeys = [self.impl keysSortedByValueUsingSelector:@selector(compareNumericallyASC:)];
        
        for (NSUInteger n = 0; n < remove_count; n++) {
            [self.impl removeObjectForKey:[sortedKeys objectAtIndex:n]];
        }
    }
}

- (NSUInteger)countOfList
{
    NSUInteger count =  [self.impl count];
    return count;
}



- (void) appendFromObjList:(ObjList *) otherList
{
    if( otherList && otherList.impl )
    {
        [self.impl addEntriesFromDictionary:otherList.impl];
    }
}



@end
