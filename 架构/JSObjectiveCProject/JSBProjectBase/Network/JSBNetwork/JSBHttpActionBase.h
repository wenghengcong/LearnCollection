//
//  JSBHttpActionBase.h
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSBHttpActionManager.h"

@class JSBHttpActionBase;

typedef void (^JSBHttpActionSussessBlock)(JSBHttpActionBase *action, id responseObject , AFHTTPRequestOperation *operation );
typedef void (^JSBHttpActionFailureBlock)(JSBHttpActionBase *action, NSError *error , AFHTTPRequestOperation *operation );


/**
 http 动作基础类
 */
@interface JSBHttpActionBase : NSObject


-(id) initWithActionURLString:(NSString *) str_url;

-(NSString *) getHttpActionUrl;

@property (nonatomic,assign)    BOOL    isValid;

@property (nonatomic,retain)    NSMutableDictionary *parameters;

- (BOOL) doActionWithSuccess:(JSBHttpActionSussessBlock) success Failure:(JSBHttpActionFailureBlock) failure;

+(NSURL *) createTempImageUploadFile:(UIImage *) origin_upload_image;
+(NSURL *) createTempImageUploadFile:(UIImage *) origin_upload_image WithMaxSize:(CGSize) max_size;

@end


/**
 *  http get 动作
 */
@interface JSBHttpGetActionBase : JSBHttpActionBase

- (BOOL) doActionWithSuccess:(JSBHttpActionSussessBlock) success Failure:(JSBHttpActionFailureBlock) failure;

@end


/**
 *  http post 动作
 */
@interface JSBHttpPostActionBase : JSBHttpActionBase

- (BOOL) doActionWithSuccess:(JSBHttpActionSussessBlock) success Failure:(JSBHttpActionFailureBlock) failure;

@end

/**
 *  http post 动作并且能够上传一张图片
 */
@interface JSBHttpPostActionWithSingleImageBase : JSBHttpActionBase

@property (nonatomic,retain) NSString   * uploadImageParameterName;
@property (nonatomic,retain) UIImage    * uploadImage;
@property (nonatomic,assign) CGSize     uploadImageMaxSize;

- (BOOL) doActionWithSuccess:(JSBHttpActionSussessBlock) success Failure:(JSBHttpActionFailureBlock) failure;

@end

/**
 * http post 动作并且能够上传多张图片
 */
@interface JSBHttpPostActionWithManyImageBase : JSBHttpActionBase

@property (nonatomic,strong) NSArray * uploadImageParameterNameArr;
@property (nonatomic,strong) NSArray * uploadImageArr;
@property (nonatomic,assign) CGSize    uploadImageMaxSize;

- (BOOL) doActionWithSuccess:(JSBHttpActionSussessBlock) success Failure:(JSBHttpActionFailureBlock) failure;

@end


/**
 *  http delete 动作
 */
@interface JSBHttpDeleteActionBase : JSBHttpActionBase

- (BOOL) doActionWithSuccess:(JSBHttpActionSussessBlock) success Failure:(JSBHttpActionFailureBlock) failure;

@end