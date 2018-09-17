#include <stdio.h>

void (^blk)(void) = ^{ printf("Global Block\n"); };

int main(int argc, char const *argv[])
{
	return 0;
}
