#import <Foundation/Foundation.h>

typedef void(^blk_t)(id obj);
int main()
{
    blk_t blk;
    {
        id array = [[NSMutableArray alloc] init];
        __block int val = 4;
        blk = [^(id obj) {
            [array addObject:obj];
            val = 8;
            NSLog(@"array count = %ld", [array count]);
        } copy];
        
    }
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
}
