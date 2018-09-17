struct obj_layout {
	NSUInteger retained; 
};

inline id
NSAllocateObject (Class aClass, NSUInteger extraBytes, NSZone *zone)
{
	int size = /* needed size to store the object */
	id new = NSZoneMalloc(zone, size);
	memset(new, 0, size);
	new = (id)&((struct obj_layout *)new)[1];
}