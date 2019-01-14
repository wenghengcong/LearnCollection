#import <Foundation/Foundation.h>

typedef void(^blk_t)(id obj);
int main()
{
    blk_t blk;
    {
        id array = [[NSMutableArray alloc] init];
        id __weak array2 = array;
        __block int val = 4;
        blk = [^(id obj) {
            [array2 addObject:obj];
            val = 8;
            NSLog(@"array2 count = %ld", [array2 count]);
        } copy];
        
    }
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
}
