//
//  JSBHttpActionBase.m
//  JSBProjectBase
//
//  Created by wenghengcong on 16/1/3.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

#import "JSBHttpActionBase.h"
#import "NSString+JSB.h"
#import "UIImage+JSB.h"

@interface JSBHttpActionBase()

@property (nonatomic,retain) NSString * url;

@end

#pragma mark - base

@implementation JSBHttpActionBase

- (id)initWithActionURLString:(NSString *)str_url {
    
    self = [super init];
    if (self) {
        self.url = str_url;
        self.isValid = NO;
    }
    return self;
    
}

- (NSString *)getHttpActionUrl {
    return self.url;
}

- (BOOL)doActionWithSuccess:(JSBHttpActionSussessBlock)success Failure:(JSBHttpActionFailureBlock)failure {
    //必须实现该方法
#ifdef DEBUG
    assert(0);
#endif
    return YES;
}

+(NSURL *) createTempImageUploadFile:(UIImage *) origin_upload_image
{
    NSURL *uploadFilePath = nil;
    
    NSString * random_string = [NSString randomStringWithLength:32];
    NSString * strFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                              [NSString stringWithFormat: @"%@_%.0f.%@", random_string ,
                               [NSDate timeIntervalSinceReferenceDate] ,
                               @"jpg"]];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:strFilePath isDirectory:nil] )
    {
        [[NSFileManager defaultManager] removeItemAtPath:strFilePath error:nil];
    }
    
    NSData * binaryImageData = UIImageJPEGRepresentation(origin_upload_image , 0.7f);
    if( ![binaryImageData writeToFile:strFilePath atomically:YES] )
        return nil;
    uploadFilePath = [NSURL fileURLWithPath:strFilePath];
    return uploadFilePath;
}

+(NSURL *) createTempImageUploadFile:(UIImage *) origin_upload_image WithMaxSize:(CGSize) max_size
{
    UIImage * resizedImage = [UIImage reduce:origin_upload_image withMaxSize:max_size];
    if( !resizedImage )
        return nil;
    
    NSURL *uploadFilePath = nil;
    
    NSString * random_string = [NSString randomStringWithLength:32];
    NSString * strFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:
                              [NSString stringWithFormat: @"%@_%.0f.%@", random_string ,
                               [NSDate timeIntervalSinceReferenceDate] ,
                               @"jpg"]];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:strFilePath isDirectory:nil] )
    {
        [[NSFileManager defaultManager] removeItemAtPath:strFilePath error:nil];
    }
    
    NSData * binaryImageData = UIImageJPEGRepresentation(resizedImage , 0.7f);
    if( ![binaryImageData writeToFile:strFilePath atomically:YES] )
        return nil;
    
    uploadFilePath = [NSURL fileURLWithPath:strFilePath];
    return uploadFilePath;
}


@end

#pragma mark - get base

@implementation JSBHttpGetActionBase

- (BOOL)doActionWithSuccess:(JSBHttpActionSussessBlock)success Failure:(JSBHttpActionFailureBlock)failure {
    if( !self.isValid )
        return NO;
    
    AFHTTPRequestOperationManager * http_request_mgr = [[JSBHttpActionManager sharedManager] getHttpRequestMgr];
    if( !http_request_mgr )
        return NO;
    
    [http_request_mgr GET:[self getHttpActionUrl] parameters:self.parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      success( self , responseObject , operation );
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      failure( self , error , operation );
                  }];
    return YES;

}

@end

#pragma mark - post base

@implementation JSBHttpPostActionBase

- (BOOL)doActionWithSuccess:(JSBHttpActionSussessBlock)success Failure:(JSBHttpActionFailureBlock)failure {
    if( !self.isValid )
        return NO;
    AFHTTPRequestOperationManager * http_request_mgr = [[JSBHttpActionManager sharedManager] getHttpRequestMgr];
    if( !http_request_mgr )
        return NO;
    
    [http_request_mgr POST:[self getHttpActionUrl] parameters:self.parameters
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       success( self , responseObject , operation );
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       failure( self , error , operation );
                       
                   }];
    
    return YES;
}

@end

#pragma mark - post single image

@implementation JSBHttpPostActionWithSingleImageBase

- (id)initWithActionURLString:(NSString *)str_url {
    
    self = [super initWithActionURLString:str_url];
    if( self )
    {
        self.uploadImageMaxSize = CGSizeZero;
        self.uploadImageParameterName = @"photo";
    }
    return self;
}

- (BOOL)doActionWithSuccess:(JSBHttpActionSussessBlock)success Failure:(JSBHttpActionFailureBlock)failure
{
    if( !self.isValid )
        return NO;
    AFHTTPRequestOperationManager * http_request_mgr = [[JSBHttpActionManager sharedManager] getHttpRequestMgr];
    if( !http_request_mgr )
        return NO;
    
    NSURL * upload_file_url = nil;
    if( self.uploadImage )
    {
        //图片大小限制
        if( CGSizeEqualToSize(self.uploadImageMaxSize, CGSizeZero) )
            
        {
            upload_file_url = [JSBHttpActionBase createTempImageUploadFile:self.uploadImage];
        }
        else
        {
            upload_file_url = [JSBHttpActionBase createTempImageUploadFile:self.uploadImage WithMaxSize:self.uploadImageMaxSize];
        }
    }
    
    [http_request_mgr POST:[self getHttpActionUrl]
                parameters:self.parameters
 constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if( upload_file_url )
         {
             [formData appendPartWithFileURL:upload_file_url name:self.uploadImageParameterName error:nil];
             
         }
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if( upload_file_url )
         {
             [[NSFileManager defaultManager] removeItemAtURL:upload_file_url error:nil];
         }
         
         success( self , responseObject , operation );
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if( upload_file_url )
         {
             [[NSFileManager defaultManager] removeItemAtURL:upload_file_url error:nil];
         }
         
         failure( self , error , operation );
     }];
    
    return YES;
}

@end

#pragma mark - post base

@implementation JSBHttpPostActionWithManyImageBase
{
    NSMutableArray *_uploadFileUrlArr;
}

- (id)initWithActionURLString:(NSString *)str_url {
    
    self = [super initWithActionURLString:str_url];
    if( self )
    {
        _uploadFileUrlArr = [NSMutableArray array];
    }
    return self;
}

- (BOOL)doActionWithSuccess:(JSBHttpActionSussessBlock)success Failure:(JSBHttpActionFailureBlock)failure {
    
    if( !self.isValid )
        return NO;
    AFHTTPRequestOperationManager * http_request_mgr = [[JSBHttpActionManager sharedManager] getHttpRequestMgr];
    if( !http_request_mgr )
        return NO;
    
    
    [http_request_mgr POST:[self getHttpActionUrl]
                parameters:self.parameters
 constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSURL * upload_file_url = nil;
         int i = 0;
         for (UIImage *image in _uploadImageArr) {
             if (image) {
                 if( CGSizeEqualToSize(self.uploadImageMaxSize, CGSizeZero) )
                 {
                     upload_file_url = [JSBHttpActionBase createTempImageUploadFile:image];
                 }
                 else
                 {
                     upload_file_url = [JSBHttpActionBase createTempImageUploadFile:image WithMaxSize:self.uploadImageMaxSize];
                 }
                 if( upload_file_url )
                 {
                     [formData appendPartWithFileURL:upload_file_url name:_uploadImageParameterNameArr[i] error:nil];
                     [_uploadFileUrlArr addObject:upload_file_url];
                 }
             }
             i++;
         }
         
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         for (NSURL *upload_file_url in _uploadFileUrlArr) {
             if( upload_file_url )
             {
                 [[NSFileManager defaultManager] removeItemAtURL:upload_file_url error:nil];
             }
             
         }
         
         success( self , responseObject , operation );
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         for (NSURL *upload_file_url in _uploadFileUrlArr) {
             if( upload_file_url )
             {
                 [[NSFileManager defaultManager] removeItemAtURL:upload_file_url error:nil];
             }
             
         }
         
         failure( self , error , operation );
     }];
    
    return YES;

}


@end

#pragma mark - delete base


@implementation JSBHttpDeleteActionBase

- (BOOL)doActionWithSuccess:(JSBHttpActionSussessBlock)success Failure:(JSBHttpActionFailureBlock)failure {
    if( !self.isValid )
        return NO;
    AFHTTPRequestOperationManager * http_request_mgr = [[JSBHttpActionManager sharedManager] getHttpRequestMgr];
    if( !http_request_mgr )
        return NO;
    
    [http_request_mgr DELETE:[self getHttpActionUrl] parameters:self.parameters
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         success( self , responseObject , operation );
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         failure( self , error , operation );
                     }];
    return YES;
}

@end

