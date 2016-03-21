//
//  SuperMarket.h
//  FacadePattern_OC
//
//  Created by wenghengcong on 15/3/17.
//  Copyright (c) 2015年 wenghengcong. All rights reserved.
//

/**
 *  门面，用于直接与客户打交道
 *
 *  @return <#return value description#>
 */

#import <Foundation/Foundation.h>
#import "MobelCom.h"
#import "ClothesCom.h"

@interface SuperMarket : NSObject

/**
 *  直接售卖，手机的生产和贴牌不用我们用户理会，打给我们销售单就行了
 */
- (void)saleMobel;
- (void)saleClothes;

@end
