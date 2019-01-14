class AutoreleasePoolPage
{
	static inline void *push()
	{
		/* It corresponds to creation and ownership of an NSAutoreleasePool object */ 
	}

	static inline void pop(void *token)
	{
		/* It corresponds to disposal of an NSAutoreleasePool object */
		releaseAll();
	}

	static inline id autorelease(id obj)
	{
		/* It corresponds to NSAutoreleasePool class method addObject. */ 
		AutoreleasePoolPage *autoreleasePoolPage = 
			/* getting active AutoreleasePoolPage object */
			autoreleasePoolPage->add(obj);
	}

	id *add(id obj)
	{
		/* add the obj to an internal array; */
	}
	
	void releaseAll()
	{
		/* calls release for all the objects in the internal array */
	}
};

void *objc_autoreleasePoolPush(void)
{
	return AutoreleasePoolPage::push();
}

void objc_autoreleasePoolPop(void *ctxt)
{
	AutoreleasePoolPage::pop(ctxt);
}

id objc_autorelease(id obj)
{
	return AutoreleasePoolPage::autorelease(obj);
}