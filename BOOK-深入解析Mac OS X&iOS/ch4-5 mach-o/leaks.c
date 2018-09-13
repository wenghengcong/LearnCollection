#include <stdio.h> 

int f()
{
	char *c = malloc(24);
}

void main()
{
	f();
	sleep(100); 
}