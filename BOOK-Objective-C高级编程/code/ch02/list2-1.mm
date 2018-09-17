id __strong obj0 = [[NSObject alloc] init]; /* object A */

/*
 * obj0 has a strong reference to object A 
 */

id __strong obj1 = [[NSObject alloc] init]; /* object B */

/*
 * obj1 has a strong reference to object B 
 */

id __strong obj2 = nil;

/*
 * obj2 has no reference 
 */

obj0 = obj1;

/*
 * Obj0 has a strong reference to object B, which has been assigned from obj1.
 * So, obj0 does not have a strong reference to object A anymore.
￼* Object A is disposed of because no one has ownership of it.
 *
 * At this moment, both obj0 and obj1 have strong references to object B. 
 */

 obj2 = obj0;

/*
 * Through obj0, obj2 has a strong reference to object B.
 *
 * At this moment, obj0, obj1 and obj2 have strong references to object B. 
 */

obj1 = nil;

/*
 * Because nil is assigned to obj1, strong references to object B disappear.
 *
 * At this moment, obj0 and obj2 have strong references to object B.
 */
 
obj0 = nil;

/*
 * Because nil is assigned to obj0, a strong reference to object B disappears.
 *
 * At this moment, obj2 has a strong reference to object B.
 */
 
obj2 = nil;

/*
 * Because nil is assigned to obj2, a strong reference to object B disappears.
 * Object B is disposed of because no one has ownership of it
 */