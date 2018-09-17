#include <stdio.h>

int main(int argc, char const *argv[])
{
	int dmy = 256;
	int val = 10;
	const char * fmt = "val = %d\n";
	void (^blk)(void) = ^ {
		printf(fmt, val);
	};
	
	val = 2;
	fmt = "Thes values wre changed. val = %d\n";
	blk();

	return 0;
}