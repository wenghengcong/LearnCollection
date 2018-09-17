int main(int argc, char const *argv[])
{
	__block int val = 10;
	void (^blk)(void) = ^{
		val = 2;
	};
	blk();
	return 0;
}