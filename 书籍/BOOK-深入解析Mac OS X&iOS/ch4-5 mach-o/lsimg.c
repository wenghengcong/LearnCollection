#include <dlfcn.h> // for dladdr(3)
#include <mach-o/dyld.h> // for _dyld_ functions

void listImages(void) 
{
	// List all mach-o images in a process
	uint32_t i;
	uint32_t ic = _dyld_image_count();
	printf ("Got %d images\n",ic); 
	for (i = 0; i < ic; i++)
	{
		printf ("%d: %p\t%s\t(slide: %p)\n", i,
_dyld_get_image_header(i), _dyld_get_image_name(i), _dyld_get_image_slide(i));
	}
}

void add_callback(const struct mach_header* mh, intptr_t vmaddr_slide) 
{
	// Using callbacks from dyld, we can get the same functionality // of enumerating the images in a binary
	Dl_info info;
	// Should really check return value of dladdr here...
	dladdr(mh, &info);
	printf ("Callback invoked for image: %p %s (slide: %p)\n", mh, info.dli_fname, vmaddr_slide);
}

void main (int argc, char **argv)
{
	// Calling listImages will enumerate all Mach-O objects loaded into // our address space, using the _dyld functions from mach-o/dyld.h
	listImages();
	// Alternatively, we can register a callback on add. This callback // will also be invoked for existing images at this point.
	_dyld_register_func_for_add_image(add_callback);

}