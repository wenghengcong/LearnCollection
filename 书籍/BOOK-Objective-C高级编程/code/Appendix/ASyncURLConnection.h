#import <Foundation/Foundation.h>

/*
 * By using typedef for a Block type variables, 
 * Source code will have better readability.
 */

typedef void (^completeBlock_t)(NSData *data);
typedef void (^errorBlock_t)(NSError *error);

@interface ASyncURLConnection : NSURLConnection
{
	/*
	 * Because ARC is enabled, all the variables below are
	 * qualified with __strong when it doesn't have an explicit qualifier. 
	 */
	NSMutableData *data_;
	completeBlock_t completeBlock_;
	errorBlock_t errorBlock_;
}

/*
 * To give the source code better readability,
 * The typedefined Block type variable is used for the argument. 
 */
 
+ (id)request:(NSString *)requestUrl
	completeBlock:(completeBlock_t)completeBlock
	errorBlock:(errorBlock_t)errorBlock;
	
- (id)initWithRequest:(NSString *)requestUrl
	completeBlock:(completeBlock_t)completeBlock
	errorBlock:(errorBlock_t)errorBlock;
@end