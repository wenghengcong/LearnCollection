@interface Test : NSObject
{
	id __strong obj_;
}

- (void)setObject:(id __strong)obj; 
@end

@implementation Test
- (id)init
{
	self = [super init];
    return self;
}

- (void)setObject:(id __strong)obj
{
	obj_ = obj;
}
@end