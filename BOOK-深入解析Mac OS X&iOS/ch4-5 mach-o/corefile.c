#include <stdio.h>
int main(int argc, char const *argv[])
{
	int i = 24;
	printf("%d\n", i/0);
	return 0;		//不会执行到这里
}