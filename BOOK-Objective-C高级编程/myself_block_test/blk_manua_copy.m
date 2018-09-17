
#import <Foundation/Foundation.h>

@interface Block: NSObject

@end

@implementation Block

id getBlockArray()
{
	int val = 10;
    return [[NSArray alloc] initWithObjects:
	 	^{NSLog(@"blk0:%d", val);}, 
		 ^{NSLog(@"blk1:%d", val);},
		  nil];
}

-(void)callBlock
{
	id obj =  getBlockArray();
	typedef void (^blk_t)(void);
	blk_t blk = (blk_t)[obj objectAtIndex:0]; 
	blk();
}

@end
